package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;
import com.example.timetablegenerator.domain.dto.response.ManualPlacementSuggestionResponse;
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
    private final LunchRepository lunchRepository;

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

        validateAssignmentFaculty(timetable, subject, groups);

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
        log.debug("app | Available splitting options for {} hours: {}", request.hoursPerWeek(), splittingOptions);

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
            lessonRepository.deleteLessonGroupLinksByTimetableId(timetableId);
            lessonRepository.deleteByTimetableId(timetableId);
            lunchRepository.deleteByTimetableIdAndManualFalse(timetableId);
            log.info("app | Generation mode NEW: existing lessons deleted for timetableId={}", timetableId);
        } else {
            log.info("app | Generation mode APPEND: existing lessons kept for timetableId={}", timetableId);
        }

        List<Lesson> existingLessons = lessonRepository.findByTimetableId(timetableId);
        Map<Long, Integer> existingHoursByAssignment = existingLessons.stream()
                .filter(lesson -> lesson.getAssignment() != null && lesson.getAssignment().getId() != null)
                .collect(Collectors.groupingBy(
                        lesson -> lesson.getAssignment().getId(),
                        Collectors.summingInt(Lesson::getDurationHours)
                ));

        Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay = new EnumMap<>(DayOfWeek.class);
        for (DayOfWeek day : TEACHING_DAYS) {
            List<TimeSlot> dbSlots = timeSlotRepository.findLessonSlotsByDay(day);
            List<CpSatScheduler.TimeSlotInfo> slotInfos = dbSlots.stream()
                    .map(ts -> new CpSatScheduler.TimeSlotInfo(ts.getStartTime(), ts.getEndTime()))
                    .toList();
            slotsByDay.put(day, slotInfos);

            log.info("app | Generation input: day={} lessonSlots={}", day, slotInfos.size());
        }

        List<LessonVertex> vertices = assignmentLessonExpander.buildVertices(assignments, existingHoursByAssignment);
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
                cpSatScheduler.schedule(vertices, allRooms, slotsByDay, existingLessons);
        long elapsedMs = System.currentTimeMillis() - startedAt;

        Map<Long, CpSatScheduler.ScheduledSlot> placement = schedulingResult.placed();
        Set<Long> unplacedVertexIds = schedulingResult.unplacedVertexIds();
        Map<Long, String> unplacedReasonsByVertex = schedulingResult.unplacedReasons();

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
        int placedSlotsCount = 0;

        for (LessonVertex vertex : vertices) {
            CpSatScheduler.ScheduledSlot slot = placement.get(vertex.getId());

            if (slot == null) {
                failedCount++;
                continue;
            }

            Assignment assignment = assignmentMap.get(vertex.getAssignmentId());
            if (assignment == null) {
                log.error("app | Assignment not found for vertex assignmentId={}", vertex.getAssignmentId());
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
            placedSlotsCount += vertex.getDurationHours();
        }

        lessonRepository.saveAll(lessonsToSave);

        Map<Long, Integer> assignedHoursByAssignment = new HashMap<>();
        Map<Long, Integer> assignedLessonsCountByAssignment = new HashMap<>();

        List<Lesson> allTimetableLessons = new ArrayList<>(existingLessons);
        allTimetableLessons.addAll(lessonsToSave);

        regenerateAutomaticLunches(timetableId, assignments, slotsByDay, allTimetableLessons);

        for (Lesson lesson : allTimetableLessons) {
            Long assignmentId = lesson.getAssignment().getId();
            assignedHoursByAssignment.merge(assignmentId, lesson.getDurationHours(), Integer::sum);
            assignedLessonsCountByAssignment.merge(assignmentId, 1, Integer::sum);
        }

        Map<Long, Long> failedVerticesByAssignment = new HashMap<>();
        Map<Long, Set<String>> failureReasonsByAssignment = new HashMap<>();
        for (LessonVertex vertex : vertices) {
            if (unplacedVertexIds.contains(vertex.getId()) || !placement.containsKey(vertex.getId())) {
                failedVerticesByAssignment.merge(vertex.getAssignmentId(), 1L, Long::sum);
                failureReasonsByAssignment
                        .computeIfAbsent(vertex.getAssignmentId(), _key -> new LinkedHashSet<>())
                        .add(unplacedReasonsByVertex.getOrDefault(vertex.getId(), "No placement returned by scheduler"));
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
                        "Placed %d of %d hours; %d lesson block(s) still unplaced. %s"
                                .formatted(
                                        totalHoursAssigned,
                                        assignment.getHoursPerWeek(),
                                        failedVerticesForAssignment,
                                        formatFailureReasons(failureReasonsByAssignment.get(assignment.getId()))
                                )
                );
                assignment.setRequiresManualInput(true);
            } else {
                assignment.setPlacementStatus(PlacementStatus.FAILED);
                assignment.setFailureReason(
                        failedVerticesForAssignment > 0
                                ? "Could not place any lesson blocks. %s"
                                .formatted(formatFailureReasons(failureReasonsByAssignment.get(assignment.getId())))
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
                        assignment.getSubject() != null ? assignment.getSubject().getName() : null,
                        assignment.getTeacher() != null ? assignment.getTeacher().getFullName() : null,
                        assignment.getGroups() == null
                                ? List.of()
                                : assignment.getGroups().stream()
                                .map(StudyGroup::getName)
                                .sorted()
                                .toList(),
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

        int totalLessonBlocks = vertices.size();
        int placedLessonBlocks = placedCount;
        int failedLessonBlocks = failedCount;
        int totalLessonSlots = vertices.stream()
                .mapToInt(LessonVertex::getDurationHours)
                .sum();
        int placedLessonSlots = placedSlotsCount;
        int failedLessonSlots = totalLessonSlots - placedLessonSlots;

        log.info(
                "Generation finished: timetableId={}, timetableStatus={}, totalBlocks={}, placedBlocks={}, failedBlocks={}, totalSlots={}, placedSlots={}, failedSlots={}, failedAssignments={}",
                timetableId,
                timetable.getStatus(),
                totalLessonBlocks,
                placedLessonBlocks,
                failedLessonBlocks,
                totalLessonSlots,
                placedLessonSlots,
                failedLessonSlots,
                failedAssignments.size()
        );

        return GenerationResponse.builder()
                .timetableId(timetableId)
                .timetableName(timetable.getName())
                .totalVertices(totalLessonBlocks)
                .placedLessonsCount(placedLessonBlocks)
                .failedVerticesCount(failedLessonBlocks)
                .totalLessonBlocks(totalLessonBlocks)
                .placedLessonBlocksCount(placedLessonBlocks)
                .failedLessonBlocksCount(failedLessonBlocks)
                .totalLessonSlots(totalLessonSlots)
                .placedLessonSlotsCount(placedLessonSlots)
                .failedLessonSlotsCount(failedLessonSlots)
                .status(timetable.getStatus())
                .failedAssignments(failedAssignments)
                .build();
    }

    @Override
    @Transactional
    public GenerationResponse retryFailedAssignments(Long timetableId, Map<Long, String> manualSplittings) {
        for (Map.Entry<Long, String> entry : manualSplittings.entrySet()) {
            assignmentRepository.findById(entry.getKey()).ifPresent(a -> {
                a.setHoursSplitting(entry.getValue());
                assignmentRepository.save(a);
            });
        }

        return generateTimetable(timetableId, GenerationMode.APPEND);
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

        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable: " + timetableId));

        List<LocalTime> coveredSlots = resolveCoveredSlotStarts(day, startTime, durationHours);
        Set<LocalTime> targetSlotSet = new HashSet<>(coveredSlots);

        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found"));

        List<Lesson> dayLessons = lessonRepository.findByTimetableId(timetableId).stream()
                .filter(lesson -> day.equals(lesson.getDayOfWeek()))
                .toList();

        for (Lesson existingLesson : dayLessons) {
            Set<LocalTime> existingSlotSet = new HashSet<>(resolveCoveredSlotStarts(
                    existingLesson.getDayOfWeek(),
                    existingLesson.getStartTime(),
                    existingLesson.getDurationHours()
            ));

            if (Collections.disjoint(targetSlotSet, existingSlotSet)) {
                continue;
            }

            if (assignment.getTeacher() != null
                    && existingLesson.getTeacher() != null
                    && Objects.equals(assignment.getTeacher().getId(), existingLesson.getTeacher().getId())) {
                log.warn(
                        "app | Manual placement rejected: teacher conflict for assignment={} with lesson={} teacher={} at {} {}",
                        assignmentId,
                        existingLesson.getId(),
                        assignment.getTeacher().getId(),
                        day,
                        startTime
                );
                return false;
            }

            if (hasSharedGroup(assignment.getGroups(), existingLesson.getGroups())) {
                log.warn(
                        "app | Manual placement rejected: group conflict for assignment={} with lesson={} at {} {}",
                        assignmentId,
                        existingLesson.getId(),
                        day,
                        startTime
                );
                return false;
            }

            if (existingLesson.getRoom() != null
                    && Objects.equals(room.getId(), existingLesson.getRoom().getId())) {
                log.warn(
                        "app | Manual placement rejected: room conflict for assignment={} with lesson={} room={} at {} {}",
                        assignmentId,
                        existingLesson.getId(),
                        room.getId(),
                        day,
                        startTime
                );
                return false;
            }
        }

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

        Lesson savedLesson = lessonRepository.save(lesson);
        log.info(
                "app | Manual placement saved lesson={} assignment={} timetable={} groupCount={} room={} at {} {}",
                savedLesson.getId(),
                assignmentId,
                timetableId,
                savedLesson.getGroups() == null ? 0 : savedLesson.getGroups().size(),
                room.getId(),
                day,
                startTime
        );

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

    @Override
    @Transactional(readOnly = true)
    public List<ManualPlacementSuggestionResponse> suggestManualPlacements(
            Long timetableId,
            Long assignmentId,
            Integer durationHours,
            int limit
    ) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable: " + timetableId));

        int duration = durationHours == null ? 0 : durationHours;
        if (duration < 1) {
            throw new IllegalArgumentException("Lesson duration must be at least 1 slot");
        }

        int remainingHours = remainingHours(assignment);
        if (duration > remainingHours) {
            return List.of();
        }

        int safeLimit = Math.max(1, Math.min(limit, 100));
        List<Room> rooms = roomsForManualPlacement(assignment);
        if (rooms.isEmpty()) {
            return List.of();
        }

        List<Lesson> timetableLessons = lessonRepository.findByTimetableId(timetableId);
        List<ManualPlacementSuggestionResponse> suggestions = new ArrayList<>();

        for (DayOfWeek day : TEACHING_DAYS) {
            List<TimeSlot> daySlots = timeSlotRepository.findLessonSlotsByDay(day);
            for (int startIdx = 0; startIdx + duration <= daySlots.size(); startIdx++) {
                TimeSlot startSlot = daySlots.get(startIdx);
                TimeSlot endSlot = daySlots.get(startIdx + duration - 1);

                Set<LocalTime> targetSlotSet = daySlots.subList(startIdx, startIdx + duration).stream()
                        .map(TimeSlot::getStartTime)
                        .collect(Collectors.toSet());

                for (Room room : rooms) {
                    if (hasPlacementConflict(assignment, room, day, targetSlotSet, timetableLessons)) {
                        continue;
                    }

                    suggestions.add(new ManualPlacementSuggestionResponse(
                            day,
                            startSlot.getStartTime(),
                            endSlot.getEndTime(),
                            duration,
                            room.getId(),
                            room.getName(),
                            room.getType(),
                            room.getCapacity(),
                            suggestionScore(assignment, room, day, startSlot.getStartTime(), endSlot.getEndTime())
                    ));
                }
            }
        }

        return suggestions.stream()
                .sorted(Comparator
                        .comparingInt(ManualPlacementSuggestionResponse::score)
                        .thenComparing(ManualPlacementSuggestionResponse::dayOfWeek)
                        .thenComparing(ManualPlacementSuggestionResponse::startTime)
                        .thenComparing(ManualPlacementSuggestionResponse::roomId))
                .limit(safeLimit)
                .toList();
    }

    private List<LocalTime> resolveCoveredSlotStarts(
            DayOfWeek day,
            LocalTime startTime,
            Integer durationSlots
    ) {
        int duration = durationSlots == null ? 0 : durationSlots;
        if (duration < 1) {
            throw new IllegalArgumentException("Lesson duration must be at least 1 slot");
        }

        List<TimeSlot> daySlots = timeSlotRepository.findLessonSlotsByDay(day);
        for (int i = 0; i < daySlots.size(); i++) {
            if (!daySlots.get(i).getStartTime().equals(startTime)) {
                continue;
            }

            int endExclusive = i + duration;
            if (endExclusive > daySlots.size()) {
                throw new IllegalArgumentException("Selected time does not have enough consecutive slots");
            }

            return daySlots.subList(i, endExclusive).stream()
                    .map(TimeSlot::getStartTime)
                    .toList();
        }

        throw new IllegalArgumentException("Selected start time is not a valid lesson slot");
    }

    private boolean hasPlacementConflict(
            Assignment assignment,
            Room room,
            DayOfWeek day,
            Set<LocalTime> targetSlotSet,
            List<Lesson> timetableLessons
    ) {
        for (Lesson existingLesson : timetableLessons) {
            if (!day.equals(existingLesson.getDayOfWeek())) {
                continue;
            }

            Set<LocalTime> existingSlotSet = new HashSet<>(resolveCoveredSlotStarts(
                    existingLesson.getDayOfWeek(),
                    existingLesson.getStartTime(),
                    existingLesson.getDurationHours()
            ));

            if (Collections.disjoint(targetSlotSet, existingSlotSet)) {
                continue;
            }

            if (assignment.getTeacher() != null
                    && existingLesson.getTeacher() != null
                    && Objects.equals(assignment.getTeacher().getId(), existingLesson.getTeacher().getId())) {
                return true;
            }

            if (hasSharedGroup(assignment.getGroups(), existingLesson.getGroups())) {
                return true;
            }

            if (existingLesson.getRoom() != null
                    && Objects.equals(room.getId(), existingLesson.getRoom().getId())) {
                return true;
            }
        }

        return false;
    }

    private List<Room> roomsForManualPlacement(Assignment assignment) {
        int requiredCapacity = requiredRoomCapacity(assignment);
        List<Room> result = new ArrayList<>(roomRepository.findAll());

        result.sort(Comparator
                .comparing((Room room) -> !isSpecificRoomMatch(assignment, room))
                .thenComparing(room -> !isRoomTypeCompatible(assignment, room))
                .thenComparing(room -> !hasRequiredCapacity(room, requiredCapacity))
                .thenComparing(Room::getId));
        return result;
    }

    private boolean isSpecificRoomMatch(Assignment assignment, Room room) {
        return assignment.getSpecificRoomId() == null
                || Objects.equals(room.getId(), assignment.getSpecificRoomId());
    }

    private boolean isRoomTypeCompatible(Assignment assignment, Room room) {
        return assignment.getRoomTypeRequired() == null
                || assignment.getRoomTypeRequired() == RoomType.ANY
                || room.getType() == assignment.getRoomTypeRequired();
    }

    private int requiredRoomCapacity(Assignment assignment) {
        if (assignment.getGroups() == null) {
            return 0;
        }

        return assignment.getGroups().stream()
                .map(StudyGroup::getStudentCount)
                .filter(Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();
    }

    private boolean hasRequiredCapacity(Room room, int requiredCapacity) {
        return requiredCapacity <= 0 || (room.getCapacity() != null && room.getCapacity() >= requiredCapacity);
    }

    private boolean isExcludedDay(Assignment assignment, DayOfWeek day) {
        return assignment.getExcludedDays() != null && assignment.getExcludedDays().contains(day);
    }

    private boolean isShiftCompatible(Shift shift, LocalTime startTime) {
        if (shift == null || shift == Shift.ANY) {
            return true;
        }

        boolean isMorning = startTime.isBefore(LocalTime.NOON);
        return (shift == Shift.MORNING && isMorning)
                || (shift == Shift.AFTERNOON && !isMorning);
    }

    private boolean isExcludedByTimeRule(
            Assignment assignment,
            DayOfWeek day,
            LocalTime blockStart,
            LocalTime blockEnd
    ) {
        if (assignment.getExcludedTimeSlots() == null || assignment.getExcludedTimeSlots().isEmpty()) {
            return false;
        }

        for (TimeSlotExclusion exclusion : assignment.getExcludedTimeSlots()) {
            if (exclusion.getDay() != day) {
                continue;
            }

            LocalTime excludedStart = LocalTime.parse(exclusion.getStartTime());
            LocalTime excludedEnd = LocalTime.parse(exclusion.getEndTime());
            if (blockStart.isBefore(excludedEnd) && blockEnd.isAfter(excludedStart)) {
                return true;
            }
        }

        return false;
    }

    private int suggestionScore(
            Assignment assignment,
            Room room,
            DayOfWeek day,
            LocalTime startTime,
            LocalTime endTime
    ) {
        int score = 0;

        if (assignment.getPreferredDays() != null
                && !assignment.getPreferredDays().isEmpty()
                && !assignment.getPreferredDays().contains(day)) {
            score += 15;
        }

        if (isExcludedDay(assignment, day)) {
            score += 2_000;
        }

        if (!isShiftCompatible(assignment.getShift(), startTime)) {
            score += 500;
        }

        if (isExcludedByTimeRule(assignment, day, startTime, endTime)) {
            score += 2_000;
        }

        if (day == DayOfWeek.SATURDAY) {
            score += 9_500;
        }

        if (!startTime.isBefore(LocalTime.of(16, 0))) {
            score += 25;
        } else if (!startTime.isBefore(LocalTime.NOON)) {
            score += 10;
        }

        int requiredCapacity = requiredRoomCapacity(assignment);
        if (!isSpecificRoomMatch(assignment, room)) {
            score += 300;
        }

        if (!isRoomTypeCompatible(assignment, room)) {
            score += 500;
        }

        if (!hasRequiredCapacity(room, requiredCapacity)) {
            score += 1_000;
        }

        return score;
    }

    private int remainingHours(Assignment assignment) {
        int placedHours = lessonRepository.findByAssignmentId(assignment.getId()).stream()
                .map(Lesson::getDurationHours)
                .filter(Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();

        int weeklyHours = assignment.getHoursPerWeek() == null ? 0 : assignment.getHoursPerWeek();
        return Math.max(0, weeklyHours - placedHours);
    }

    private boolean hasSharedGroup(Set<StudyGroup> firstGroups, Set<StudyGroup> secondGroups) {
        if (firstGroups == null || secondGroups == null || firstGroups.isEmpty() || secondGroups.isEmpty()) {
            return false;
        }

        Set<Long> firstGroupIds = firstGroups.stream()
                .map(StudyGroup::getId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        return secondGroups.stream()
                .map(StudyGroup::getId)
                .filter(Objects::nonNull)
                .anyMatch(firstGroupIds::contains);
    }

    private AssignmentResponse convertToResponse(Assignment assignment) {
        return assignmentMapper.toResponse(assignment);
    }

    private String formatFailureReasons(Set<String> reasons) {
        if (reasons == null || reasons.isEmpty()) {
            return "No detailed reason was reported.";
        }

        return reasons.stream()
                .filter(reason -> reason != null && !reason.isBlank())
                .limit(3)
                .collect(Collectors.joining(" "));
    }

    private void validateAssignmentFaculty(Timetable timetable, Subject subject, Set<StudyGroup> groups) {
        Long timetableFacultyId = timetable.getFaculty().getId();
        Long subjectFacultyId = facultyId(subject.getMajor());

        if (!timetableFacultyId.equals(subjectFacultyId)) {
            throw new IllegalArgumentException("Subject belongs to another faculty");
        }

        boolean hasGroupFromAnotherFaculty = groups.stream()
                .map(StudyGroup::getMajor)
                .map(this::facultyId)
                .anyMatch(groupFacultyId -> !timetableFacultyId.equals(groupFacultyId));

        if (hasGroupFromAnotherFaculty) {
            throw new IllegalArgumentException("All groups must belong to the timetable faculty");
        }
    }

    private Long facultyId(Major major) {
        if (major == null || major.getDepartment() == null || major.getDepartment().getFaculty() == null) {
            throw new IllegalArgumentException("Faculty data is missing");
        }

        return major.getDepartment().getFaculty().getId();
    }

    private List<TimeSlotExclusion> mapExcludedTimeSlots(List<AssignmentRequest.TimeSlotExclusion> dtos) {
        if (dtos == null) {
            return null;
        }

        return dtos.stream()
                .map(dto -> new TimeSlotExclusion(dto.day(), dto.startTime(), dto.endTime()))
                .collect(Collectors.toList());
    }

    private void regenerateAutomaticLunches(
            Long timetableId,
            List<Assignment> assignments,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay,
            List<Lesson> lessons
    ) {
        lunchRepository.deleteByTimetableIdAndManualFalse(timetableId);

        Set<GroupDayKey> manualLunches = lunchRepository.findByTimetableId(timetableId).stream()
                .filter(Lunch::isManual)
                .map(lunch -> new GroupDayKey(lunch.getGroupId(), lunch.getDayOfWeek()))
                .collect(Collectors.toSet());

        Set<StudyGroup> groups = assignments.stream()
                .flatMap(assignment -> assignment.getGroups().stream())
                .collect(Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(StudyGroup::getId))));

        Map<GroupDayKey, List<Lesson>> lessonsByGroupDay = new HashMap<>();
        for (Lesson lesson : lessons) {
            if (lesson.getGroups() == null) continue;
            for (StudyGroup group : lesson.getGroups()) {
                lessonsByGroupDay
                        .computeIfAbsent(new GroupDayKey(group.getId(), lesson.getDayOfWeek()), _key -> new ArrayList<>())
                        .add(lesson);
            }
        }

        List<Lunch> lunchesToSave = new ArrayList<>();
        for (StudyGroup group : groups) {
            for (DayOfWeek day : TEACHING_DAYS) {
                GroupDayKey key = new GroupDayKey(group.getId(), day);
                if (manualLunches.contains(key)) {
                    continue;
                }

                findLunchSlot(slotsByDay.getOrDefault(day, Collections.emptyList()), lessonsByGroupDay.getOrDefault(key, Collections.emptyList()))
                        .ifPresent(slot -> lunchesToSave.add(Lunch.builder()
                                .timetableId(timetableId)
                                .groupId(group.getId())
                                .dayOfWeek(day)
                                .startTime(slot.startTime())
                                .endTime(slot.endTime())
                                .manual(false)
                                .build()));
            }
        }

        if (!lunchesToSave.isEmpty()) {
            lunchRepository.saveAll(lunchesToSave);
        }

        log.info("app | Automatic lunch regenerated: timetableId={}, count={}", timetableId, lunchesToSave.size());
    }

    private Optional<CpSatScheduler.TimeSlotInfo> findLunchSlot(
            List<CpSatScheduler.TimeSlotInfo> daySlots,
            List<Lesson> dayLessons
    ) {
        return daySlots.stream()
                .filter(slot -> !slot.startTime().isBefore(LocalTime.NOON)
                        && !slot.endTime().isAfter(LocalTime.of(14, 0)))
                .filter(slot -> isLunchSlotFree(slot, daySlots, dayLessons))
                .findFirst();
    }

    private boolean isLunchSlotFree(
            CpSatScheduler.TimeSlotInfo slot,
            List<CpSatScheduler.TimeSlotInfo> daySlots,
            List<Lesson> dayLessons
    ) {
        for (Lesson lesson : dayLessons) {
            List<CpSatScheduler.TimeSlotInfo> lessonSlots = coveredTimeSlotInfos(lesson, daySlots);
            for (CpSatScheduler.TimeSlotInfo lessonSlot : lessonSlots) {
                boolean overlaps = slot.startTime().isBefore(lessonSlot.endTime())
                        && slot.endTime().isAfter(lessonSlot.startTime());
                if (overlaps) {
                    return false;
                }
            }
        }

        return true;
    }

    private List<CpSatScheduler.TimeSlotInfo> coveredTimeSlotInfos(
            Lesson lesson,
            List<CpSatScheduler.TimeSlotInfo> daySlots
    ) {
        for (int i = 0; i < daySlots.size(); i++) {
            if (!daySlots.get(i).startTime().equals(lesson.getStartTime())) {
                continue;
            }

            int endExclusive = Math.min(i + lesson.getDurationHours(), daySlots.size());
            return new ArrayList<>(daySlots.subList(i, endExclusive));
        }

        return List.of(new CpSatScheduler.TimeSlotInfo(
                lesson.getStartTime(),
                lesson.getStartTime().plusHours(lesson.getDurationHours())
        ));
    }

    private record GroupDayKey(Long groupId, DayOfWeek day) {}
}
