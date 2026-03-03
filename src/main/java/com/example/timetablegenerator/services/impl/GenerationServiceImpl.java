package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;
import com.example.timetablegenerator.domain.dto.response.UnplacedLesson;
import com.example.timetablegenerator.domain.entities.*;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.generation.ConflictGraphBuilder;
import com.example.timetablegenerator.generation.GraphColoringScheduler;
import com.example.timetablegenerator.generation.LessonVertex;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.GenerationService;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import java.util.stream.Collectors;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;

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
    private final ConflictGraphBuilder conflictGraphBuilder;
    private final GraphColoringScheduler graphColoringScheduler;

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
        return convertToResponse(saved, splittingOptions);
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
        }

        // Загружаем временные слоты для каждого дня
        Map<DayOfWeek, List<GraphColoringScheduler.TimeSlotInfo>> slotsByDay = new EnumMap<>(DayOfWeek.class);
        for (DayOfWeek day : DayOfWeek.values()) {
            List<TimeSlot> dbSlots = timeSlotRepository.findLessonSlotsByDay(day);
            log.info("Day {}: {} lesson slots", day, dbSlots.size());
            List<GraphColoringScheduler.TimeSlotInfo> slotInfos = dbSlots.stream()
                    .map(ts -> new GraphColoringScheduler.TimeSlotInfo(ts.getStartTime(), ts.getEndTime()))
                    .toList();
            slotsByDay.put(day, slotInfos);
        }

        // Строим граф вершин
        List<LessonVertex> vertices = conflictGraphBuilder.buildVertices(assignments);
        conflictGraphBuilder.buildConflictGraph(vertices);

        List<Room> allRooms = roomRepository.findAll();

        Map<Long, GraphColoringScheduler.ScheduledSlot> placement =
                graphColoringScheduler.schedule(vertices, allRooms, slotsByDay);

        List<Lesson> lessonsToSave = new ArrayList<>();
        Map<Long, Assignment> assignmentMap = assignments.stream()
                .collect(Collectors.toMap(Assignment::getId, a -> a));

        int placedCount = 0;
        int failedCount = 0;

        for (LessonVertex vertex : vertices) {
            GraphColoringScheduler.ScheduledSlot slot = placement.get(vertex.getId());
            if (slot == null) {
                failedCount++;
                continue;
            }

            Assignment assignment = assignmentMap.get(vertex.getAssignmentId());
            if (assignment == null) {
                log.error("Assignment not found for vertex id {}", vertex.getAssignmentId());
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

        // Обновляем статусы назначений
        for (Assignment assignment : assignments) {
            List<Lesson> assignedLessons = lessonsToSave.stream()
                    .filter(l -> l.getAssignment().getId().equals(assignment.getId()))
                    .toList();

            int totalHoursAssigned = assignedLessons.stream()
                    .mapToInt(Lesson::getDurationHours).sum();

            if (totalHoursAssigned >= assignment.getHoursPerWeek()) {
                assignment.setPlacementStatus(PlacementStatus.SCHEDULED);
                assignment.setFailureReason(null);
                assignment.setRequiresManualInput(false);
            } else if (totalHoursAssigned > 0) {
                assignment.setPlacementStatus(PlacementStatus.PARTIAL);
                assignment.setFailureReason("Only " + totalHoursAssigned + " of " + assignment.getHoursPerWeek() + " hours placed");
                assignment.setRequiresManualInput(true);
            } else {
                assignment.setPlacementStatus(PlacementStatus.FAILED);
                assignment.setFailureReason("Could not place any lesson");
                assignment.setRequiresManualInput(true);
            }
            assignment.setGeneratedLessonsCount(assignedLessons.size());
            assignmentRepository.save(assignment);
        }

        // Обновляем статус расписания
        if (failedCount == 0 && placedCount == vertices.size()) {
            timetable.setStatus(TimetableStatus.GENERATED);
        } else if (placedCount > 0) {
            timetable.setStatus(TimetableStatus.PARTIAL);
        } else {
            timetable.setStatus(TimetableStatus.DRAFT);
        }
        timetableRepository.save(timetable);

        List<UnplacedLesson> failed = new ArrayList<>();
        for (Assignment assignment : assignments) {
            if (assignment.getPlacementStatus() == PlacementStatus.FAILED ||
                    assignment.getPlacementStatus() == PlacementStatus.PARTIAL) {
                failed.add(new UnplacedLesson(assignment.getId(), assignment.getFailureReason()));
            }
        }

        return GenerationResponse.builder()
                .timetableId(timetableId)
                .timetableName(timetable.getName())
                .totalVertices(vertices.size())
                .placedLessonsCount(placedCount)
                .failedVerticesCount(failedCount)
                .status(timetable.getStatus())
                .failedAssignments(failed)
                .build();
    }

    @Override
    @Transactional
    public Map<String, Object> retryFailedAssignments(Long timetableId, Map<Long, String> manualSplittings) {
        // Обновляем splitting для неудачных назначений
        for (Map.Entry<Long, String> entry : manualSplittings.entrySet()) {
            assignmentRepository.findById(entry.getKey()).ifPresent(a -> {
                a.setHoursSplitting(entry.getValue());
                assignmentRepository.save(a);
            });
        }
        // Перегенерируем всё заново, удаляя существующие уроки
        GenerationResponse response = generateTimetable(timetableId, GenerationMode.NEW);
        // Преобразуем GenerationResponse в Map<String, Object> для обратной совместимости, если нужно
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
    public boolean manualPlaceLesson(Long timetableId, Long assignmentId,
                                     String dayOfWeekStr, String startTimeStr,
                                     Integer durationHours, Long roomId) {
        DayOfWeek day = DayOfWeek.valueOf(dayOfWeekStr.toUpperCase());
        LocalTime startTime = LocalTime.parse(startTimeStr);

        Assignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new NotFoundException("Assignment not found"));

        // Проверяем конфликты на весь интервал
        boolean teacherBusy = false;
        for (int h = 0; h < durationHours; h++) {
            LocalTime current = startTime.plusHours(h);
            if (lessonRepository.existsByTimetableIdAndTeacherIdAndDayOfWeekAndStartTime(
                    timetableId, assignment.getTeacher().getId(), day, current)) {
                teacherBusy = true;
                break;
            }
        }
        if (teacherBusy) return false;

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

        // Обновляем статус назначения
        List<Lesson> assignedLessons = lessonRepository.findByAssignmentId(assignmentId);
        int totalHoursAssigned = assignedLessons.stream().mapToInt(Lesson::getDurationHours).sum();
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

    private AssignmentResponse convertToResponse(Assignment assignment, List<String> splittingOptions) {
        List<Long> groupIds = assignment.getGroups().stream()
                .map(StudyGroup::getId)
                .sorted()
                .toList();

        List<String> groupNames = assignment.getGroups().stream()
                .map(StudyGroup::getName)
                .sorted()
                .toList();

        String placementStatus = assignment.getPlacementStatus() != null ?
                assignment.getPlacementStatus().name() : "PENDING";

        return new AssignmentResponse(
                assignment.getId(),
                assignment.getSubject().getId(),
                assignment.getSubject().getName(),
                assignment.getTeacher().getId(),
                assignment.getTeacher().getFullName(),
                groupIds,
                groupNames,
                assignment.getHoursPerWeek(),
                assignment.getShift(),
                assignment.getRoomTypeRequired(),
                assignment.getHoursSplitting(),
                assignment.getGeneratedLessonsCount() != null ? assignment.getGeneratedLessonsCount() : 0,
                assignment.getHoursPerWeek(),
                placementStatus,
                assignment.getFailureReason(),
                splittingOptions,
                assignment.getHoursSplitting(),
                assignment.getRequiresManualInput()
        );
    }

    private List<TimeSlotExclusion> mapExcludedTimeSlots(List<AssignmentRequest.TimeSlotExclusion> dtos) {
        if (dtos == null) return null;
        return dtos.stream()
                .map(dto -> new TimeSlotExclusion(dto.day(), dto.startTime(), dto.endTime()))
                .collect(Collectors.toList());
    }
}