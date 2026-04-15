package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;
import com.example.timetablegenerator.domain.dto.response.UnplacedLesson;
import com.example.timetablegenerator.domain.entities.*;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.generation.AssignmentLessonExpander;
import com.example.timetablegenerator.generation.CpSatScheduler;
import com.example.timetablegenerator.generation.LessonVertex;
import com.example.timetablegenerator.mappers.AssignmentMapper;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.GenerationService;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GenerationServiceImpl implements GenerationService {

    private final AssignmentRepository assignmentRepository;
    private final TimetableRepository timetableRepository;
    private final SubjectRepository subjectRepository;
    private final TeacherRepository teacherRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final RoomRepository roomRepository;
    private final LessonRepository lessonRepository;
    private final TimeSlotRepository timeSlotRepository;

    private final AssignmentLessonExpander assignmentLessonExpander;
    private final CpSatScheduler cpSatScheduler;
    private final AssignmentMapper assignmentMapper;

    private static final List<DayOfWeek> TEACHING_DAYS = List.of(
            DayOfWeek.MONDAY,
            DayOfWeek.TUESDAY,
            DayOfWeek.WEDNESDAY,
            DayOfWeek.THURSDAY,
            DayOfWeek.FRIDAY,
            DayOfWeek.SATURDAY
    );

    @Override
    @Transactional
    public AssignmentResponse createAssignmentWithOptions(Long timetableId, AssignmentRequest request) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found"));

        Subject subject = subjectRepository.findById(request.subjectId())
                .orElseThrow(() -> new NotFoundException("Subject not found"));

        Teacher teacher = teacherRepository.findById(request.teacherId())
                .orElseThrow(() -> new NotFoundException("Teacher not found"));

        Set<StudyGroup> groups = new HashSet<>(studyGroupRepository.findAllById(request.groupIds()));
        if (groups.size() != request.groupIds().size()) {
            throw new NotFoundException("Some groups not found");
        }

        Assignment assignment = Assignment.builder()
                .timetable(timetable)
                .subject(subject)
                .teacher(teacher)
                .groups(groups)
                .hoursPerWeek(request.hoursPerWeek())
                .shift(request.shift())
                .roomTypeRequired(request.roomTypeRequired())
                .hoursSplitting(request.hoursSplitting())
                .excludedDays(request.excludedDays() != null ? new HashSet<>(request.excludedDays()) : null)
                .excludedTimeSlots(mapExcludedTimeSlots(request.excludedTimeSlots()))
                .preferredDays(request.preferredDays())
                .specificRoomId(request.specificRoomId())
                .placementStatus(PlacementStatus.PENDING)
                .requiresManualInput(false)
                .build();

        Assignment saved = assignmentRepository.save(assignment);

        List<String> splittingOptions = HoursSplittingUtils.generateSplittingOptionsForUI(request.hoursPerWeek());
        log.debug("Available splitting options for {} hours: {}", request.hoursPerWeek(), splittingOptions);

        return convertToResponse(saved);
    }

    @Override
    public List<String> generateSplittingOptions(int hoursPerWeek) {
        return HoursSplittingUtils.generateSplittingOptionsForUI(hoursPerWeek);
    }

    @Override
    @Transactional
    public GenerationResponse generateTimetable(Long timetableId, GenerationMode mode) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found"));

        List<Assignment> assignments = assignmentRepository.findByTimetableId(timetableId);
        if (assignments.isEmpty()) {
            throw new IllegalStateException("No assignments to generate timetable");
        }

        if (mode == GenerationMode.NEW) {
            lessonRepository.deleteAll(lessonRepository.findByTimetableId(timetableId));
            log.info("Generation mode NEW: existing lessons deleted for timetableId={}", timetableId);
        } else {
            log.info("Generation mode APPEND: existing lessons kept for timetableId={}", timetableId);
        }

        Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay = new EnumMap<>(DayOfWeek.class);
        for (DayOfWeek day : TEACHING_DAYS) {
            List<TimeSlot> dbSlots = timeSlotRepository.findLessonSlotsByDay(day);
            List<CpSatScheduler.TimeSlotInfo> slotInfos = dbSlots.stream()
                    .map(ts -> new CpSatScheduler.TimeSlotInfo(ts.getStartTime(), ts.getEndTime()))
                    .toList();
            slotsByDay.put(day, slotInfos);

            log.info("Generation input: day={} lessonSlots={}", day, slotInfos.size());
        }

        List<LessonVertex> vertices = assignmentLessonExpander.buildVertices(assignments);
        List<Room> allRooms = roomRepository.findAll();

        log.info(
                "Generation input summary: timetableId={}, mode={}, assignments={}, vertices={}, rooms={}",
                timetableId,
                mode,
                assignments.size(),
                vertices.size(),
                allRooms.size()
        );

        long startedAt = System.currentTimeMillis();
        CpSatScheduler.SchedulingResult schedulingResult =
                cpSatScheduler.schedule(vertices, allRooms, slotsByDay);
        long elapsedMs = System.currentTimeMillis() - startedAt;

        Map<Long, CpSatScheduler.ScheduledSlot> placement = schedulingResult.placed();
        Set<Long> unplacedVertexIds = schedulingResult.unplacedVertexIds();

        log.info(
                "Generation solver result: timetableId={}, placedVertices={}, unplacedVertices={}, elapsedMs={}",
                timetableId,
                placement.size(),
                unplacedVertexIds.size(),
                elapsedMs
        );

        Map<Long, Assignment> assignmentMap = assignments.stream()
                .collect(Collectors.toMap(Assignment::getId, a -> a));

        List<Lesson> lessonsToSave = new ArrayList<>();
        int placedCount = 0;
        int failedCount = 0;

        for (LessonVertex vertex : vertices) {
            CpSatScheduler.ScheduledSlot slot = placement.get(vertex.getId());

            if (slot == null) {
                failedCount++;
                continue;
            }

            Assignment assignment = assignmentMap.get(vertex.getAssignmentId());
            if (assignment == null) {
                log.error("Assignment not found for vertex assignmentId={}", vertex.getAssignmentId());
                failedCount++;
                continue;
            }

            Lesson lesson = Lesson.builder()
                    .timetable(timetable)
                    .assignment(assignment)
                    .subject(assignment.getSubject())
                    .teacher(assignment.getTeacher())
                    .groups(new HashSet<>(assignment.getGroups()))
                    .room(slot.room())
                    .dayOfWeek(slot.day())
                    .startTime(slot.startTime())
                    .durationHours(slot.durationHours())
                    .build();

            lessonsToSave.add(lesson);
            placedCount++;
        }

        lessonRepository.saveAll(lessonsToSave);

        Map<Long, Integer> assignedHoursByAssignment = new HashMap<>();
        Map<Long, Integer> assignedLessonsCountByAssignment = new HashMap<>();

        for (Lesson lesson : lessonsToSave) {
            Long assignmentId = lesson.getAssignment().getId();
            assignedHoursByAssignment.merge(assignmentId, lesson.getDurationHours(), Integer::sum);
            assignedLessonsCountByAssignment.merge(assignmentId, 1, Integer::sum);
        }

        Map<Long, Long> failedVerticesByAssignment = new HashMap<>();
        for (LessonVertex vertex : vertices) {
            if (unplacedVertexIds.contains(vertex.getId()) || !placement.containsKey(vertex.getId())) {
                failedVerticesByAssignment.merge(vertex.getAssignmentId(), 1L, Long::sum);
            }
        }

        List<UnplacedLesson> failedAssignments = new ArrayList<>();

        for (Assignment assignment : assignments) {
            int totalHoursAssigned = assignedHoursByAssignment.getOrDefault(assignment.getId(), 0);
            int generatedLessonsCount = assignedLessonsCountByAssignment.getOrDefault(assignment.getId(), 0);
            long failedVerticesForAssignment = failedVerticesByAssignment.getOrDefault(assignment.getId(), 0L);

            if (totalHoursAssigned >= assignment.getHoursPerWeek()) {
                assignment.setPlacementStatus(PlacementStatus.SCHEDULED);
                assignment.setFailureReason(null);
                assignment.setRequiresManualInput(false);
            } else if (totalHoursAssigned > 0) {
                assignment.setPlacementStatus(PlacementStatus.PARTIAL);
                assignment.setFailureReason(
                        "Placed %d of %d hours; %d lesson block(s) still unplaced"
                                .formatted(totalHoursAssigned, assignment.getHoursPerWeek(), failedVerticesForAssignment)
                );
                assignment.setRequiresManualInput(true);
            } else {
                assignment.setPlacementStatus(PlacementStatus.FAILED);
                assignment.setFailureReason(
                        failedVerticesForAssignment > 0
                                ? "Could not place any lesson blocks"
                                : "No feasible placement returned"
                );
                assignment.setRequiresManualInput(true);
            }

            assignment.setGeneratedLessonsCount(generatedLessonsCount);
            assignmentRepository.save(assignment);

            if (assignment.getPlacementStatus() == PlacementStatus.FAILED
                    || assignment.getPlacementStatus() == PlacementStatus.PARTIAL) {
                failedAssignments.add(new UnplacedLesson(
                        assignment.getId(),
                        assignment.getFailureReason()
                ));
            }

            log.info(
                    "Assignment generation result: assignmentId={}, status={}, assignedHours={}, hoursPerWeek={}, generatedLessonsCount={}, failedVertices={}",
                    assignment.getId(),
                    assignment.getPlacementStatus(),
                    totalHoursAssigned,
                    assignment.getHoursPerWeek(),
                    generatedLessonsCount,
                    failedVerticesForAssignment
            );
        }

        if (failedCount == 0 && placedCount == vertices.size()) {
            timetable.setStatus(TimetableStatus.GENERATED);
        } else if (placedCount > 0) {
            timetable.setStatus(TimetableStatus.PARTIAL);
        } else {
            timetable.setStatus(TimetableStatus.DRAFT);
        }
        timetableRepository.save(timetable);

        log.info(
                "Generation finished: timetableId={}, timetableStatus={}, totalVertices={}, placedLessons={}, failedVertices={}, failedAssignments={}",
                timetableId,
                timetable.getStatus(),
                vertices.size(),
                placedCount,
                failedCount,
                failedAssignments.size()
        );

        return GenerationResponse.builder()
                .timetableId(timetableId)
                .timetableName(timetable.getName())
                .totalVertices(vertices.size())
                .placedLessonsCount(placedCount)
                .failedVerticesCount(failedCount)
                .status(timetable.getStatus())
                .failedAssignments(failedAssignments)
                .build();
    }

    @Override
    @Transactional
    public Map<String, Object> retryFailedAssignments(Long timetableId, Map<Long, String> manualSplittings) {
        for (Map.Entry<Long, String> entry : manualSplittings.entrySet()) {
            assignmentRepository.findById(entry.getKey()).ifPresent(a -> {
                a.setHoursSplitting(entry.getValue());
                assignmentRepository.save(a);
            });
        }

        GenerationResponse response = generateTimetable(timetableId, GenerationMode.NEW);

        return Map.of(
                "timetableId", response.getTimetableId(),
                "timetableName", response.getTimetableName(),
                "totalVertices", response.getTotalVertices(),
                "placedLessons", response.getPlacedLessonsCount(),
                "failedVertices", response.getFailedVerticesCount(),
                "status", response.getStatus().toString(),
                "failedAssignments", response.getFailedAssignments()
        );
    }

    @Override
    @Transactional
    public boolean manualPlaceLesson(Long timetableId,
                                     Long assignmentId,
                                     String dayOfWeekStr,
                                     String startTimeStr,
                                     Integer durationHours,
                                     Long roomId) {
        DayOfWeek day = DayOfWeek.valueOf(dayOfWeekStr.toUpperCase());
        LocalTime startTime = LocalTime.parse(startTimeStr);

        Assignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new NotFoundException("Assignment not found"));

        boolean teacherBusy = false;
        for (int h = 0; h < durationHours; h++) {
            LocalTime current = startTime.plusHours(h);
            if (lessonRepository.existsByTimetableIdAndTeacherIdAndDayOfWeekAndStartTime(
                    timetableId, assignment.getTeacher().getId(), day, current)) {
                teacherBusy = true;
                break;
            }
        }
        if (teacherBusy) {
            return false;
        }

        for (StudyGroup group : assignment.getGroups()) {
            for (int h = 0; h < durationHours; h++) {
                LocalTime current = startTime.plusHours(h);
                if (lessonRepository.existsByTimetableIdAndGroupIdAndDayOfWeekAndStartTime(
                        timetableId, group.getId(), day, current)) {
                    return false;
                }
            }
        }

        for (int h = 0; h < durationHours; h++) {
            LocalTime current = startTime.plusHours(h);
            if (lessonRepository.existsByTimetableIdAndRoomIdAndDayOfWeekAndStartTime(
                    timetableId, roomId, day, current)) {
                return false;
            }
        }

        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found"));

        Lesson lesson = Lesson.builder()
                .timetable(assignment.getTimetable())
                .assignment(assignment)
                .subject(assignment.getSubject())
                .teacher(assignment.getTeacher())
                .groups(new HashSet<>(assignment.getGroups()))
                .room(room)
                .dayOfWeek(day)
                .startTime(startTime)
                .durationHours(durationHours)
                .build();

        lessonRepository.save(lesson);

        List<Lesson> assignedLessons = lessonRepository.findByAssignmentId(assignmentId);
        int totalHoursAssigned = assignedLessons.stream()
                .mapToInt(Lesson::getDurationHours)
                .sum();

        if (totalHoursAssigned >= assignment.getHoursPerWeek()) {
            assignment.setPlacementStatus(PlacementStatus.SCHEDULED);
            assignment.setFailureReason(null);
            assignment.setRequiresManualInput(false);
        } else {
            assignment.setPlacementStatus(PlacementStatus.PARTIAL);
            assignment.setRequiresManualInput(true);
        }

        assignment.setGeneratedLessonsCount(assignedLessons.size());
        assignmentRepository.save(assignment);

        return true;
    }

    private AssignmentResponse convertToResponse(Assignment assignment) {
        return assignmentMapper.toResponse(assignment);
    }

    private List<TimeSlotExclusion> mapExcludedTimeSlots(List<AssignmentRequest.TimeSlotExclusion> dtos) {
        if (dtos == null) {
            return null;
        }

        return dtos.stream()
                .map(dto -> new TimeSlotExclusion(dto.day(), dto.startTime(), dto.endTime()))
                .collect(Collectors.toList());
    }
}