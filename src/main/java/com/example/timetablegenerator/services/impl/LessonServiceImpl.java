package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.request.MoveLessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.domain.dto.response.MoveLessonValidationResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.TimeSlot;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.LessonMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.repositories.TimeSlotRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.LessonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
@Slf4j
public class LessonServiceImpl implements LessonService {

    private final LessonRepository lessonRepository;
    private final TimetableRepository timetableRepository;
    private final AssignmentRepository assignmentRepository;
    private final RoomRepository roomRepository;
    private final TimeSlotRepository timeSlotRepository;
    private final LessonMapper lessonMapper;

    @Override
    public List<LessonResponse> getAllLessons(Long timetableId) {
        return lessonRepository.findByTimetableId(timetableId).stream()
                .map(lessonMapper::toResponse)
                .toList();
    }

    @Override
    public List<LessonResponse> getLessonsByAssignment(Long timetableId, Long assignmentId) {
        return lessonRepository.findByAssignmentId(assignmentId).stream()
                .filter(l -> l.getTimetable().getId().equals(timetableId))
                .map(lessonMapper::toResponse)
                .toList();
    }

    @Override
    public List<LessonResponse> getLessonsByTeacher(Long timetableId, Long teacherId) {
        return lessonRepository.findByTeacher_IdAndTimetableId(teacherId, timetableId).stream()
                .map(lessonMapper::toResponse)
                .toList();
    }

    @Override
    public List<LessonResponse> getLessonsByGroup(Long timetableId, Long groupId) {
        return lessonRepository.findByGroupIdAndTimetableId(groupId, timetableId).stream()
                .map(lessonMapper::toResponse)
                .toList();
    }

    @Override
    public List<LessonResponse> getLessonsByRoom(Long timetableId, Long roomId) {
        return lessonRepository.findByRoom_IdAndTimetableId(roomId, timetableId).stream()
                .map(lessonMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<LessonResponse> getLesson(Long timetableId, Long lessonId) {
        return lessonRepository.findByTimetableIdAndId(timetableId, lessonId)
                .map(lessonMapper::toResponse);
    }

    @Transactional
    @Override
    public LessonResponse createLesson(Long timetableId, LessonRequest request) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found: " + timetableId));

        Assignment assignment = assignmentRepository.findByIdAndTimetableId(request.assignmentId(), timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + request.assignmentId() + " in timetable: " + timetableId));

        Room room = resolveRoom(request.roomId());
        validateWeeklyHoursCapacity(assignment, request.durationHours(), null);

        Lesson lesson = lessonMapper.toEntity(request);
        lesson.setTimetable(timetable);
        lesson.setAssignment(assignment);
        lesson.setSubject(assignment.getSubject());
        lesson.setTeacher(assignment.getTeacher());
        lesson.setGroups(new HashSet<>(assignment.getGroups()));
        lesson.setRoom(room);

        Lesson saved = lessonRepository.save(lesson);
        return lessonMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public LessonResponse updateLesson(Long timetableId, Long lessonId, LessonRequest request) {
        Lesson lesson = lessonRepository.findByTimetableIdAndId(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException(
                        "Lesson not found with id: " + lessonId + " in timetable: " + timetableId));

        Assignment assignment = assignmentRepository.findByIdAndTimetableId(request.assignmentId(), timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + request.assignmentId() + " in timetable: " + timetableId));

        Room room = resolveRoom(request.roomId());
        validateWeeklyHoursCapacity(assignment, request.durationHours(), lessonId);

        lessonMapper.updateEntityFromRequest(request, lesson);
        lesson.setAssignment(assignment);
        lesson.setSubject(assignment.getSubject());
        lesson.setTeacher(assignment.getTeacher());
        lesson.setGroups(new HashSet<>(assignment.getGroups()));
        lesson.setRoom(room);

        Lesson updated = lessonRepository.save(lesson);
        return lessonMapper.toResponse(updated);
    }

    @Override
    public MoveLessonValidationResponse validateLessonMove(Long timetableId, Long lessonId, MoveLessonRequest request) {
        Lesson lesson = getLessonEntity(timetableId, lessonId);
        MoveCheck check = checkMove(timetableId, lesson, request);
        return new MoveLessonValidationResponse(check.valid(), check.messages(), check.targetEndTime());
    }

    @Transactional
    @Override
    public LessonResponse moveLesson(Long timetableId, Long lessonId, MoveLessonRequest request) {
        Lesson lesson = getLessonEntity(timetableId, lessonId);
        MoveCheck check = checkMove(timetableId, lesson, request);

        if (!check.valid()) {
            throw new IllegalArgumentException(String.join("; ", check.messages()));
        }

        lesson.setDayOfWeek(request.dayOfWeek());
        lesson.setStartTime(request.startTime());

        Lesson moved = lessonRepository.save(lesson);
        log.info("app | Moved lesson id={} in timetable={} to {} {}",
                lessonId,
                timetableId,
                request.dayOfWeek(),
                request.startTime());

        return lessonMapper.toResponse(moved);
    }

    @Override
    @Transactional
    public void deleteLesson(Long timetableId, Long lessonId) {
        Lesson lesson = lessonRepository.findByTimetableIdAndId(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException(
                        "Lesson not found with id " + lessonId + " in timetable " + timetableId
                ));

        lesson.getGroups().clear();

        lessonRepository.delete(lesson);

        log.info("app | Deleted lesson with id={} from timetable={}", lessonId, timetableId);
    }

    private Lesson getLessonEntity(Long timetableId, Long lessonId) {
        return lessonRepository.findByTimetableIdAndId(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException(
                        "Lesson not found with id: " + lessonId + " in timetable: " + timetableId));
    }

    private MoveCheck checkMove(Long timetableId, Lesson lesson, MoveLessonRequest request) {
        List<String> invalidTargetMessages = new ArrayList<>();
        TimeBlock targetBlock = null;

        try {
            targetBlock = resolveLessonBlock(request.dayOfWeek(), request.startTime(), lesson.getDurationHours());
        } catch (IllegalArgumentException ex) {
            invalidTargetMessages.add(ex.getMessage());
        }

        return new MoveCheck(targetBlock, invalidTargetMessages);
    }

    private TimeBlock resolveLessonBlock(DayOfWeek day, LocalTime startTime, Integer durationSlots) {
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
                throw new IllegalArgumentException("Selected time does not have enough consecutive lesson slots");
            }

            return new TimeBlock(daySlots.get(i).getStartTime(), daySlots.get(endExclusive - 1).getEndTime());
        }

        throw new IllegalArgumentException("Selected start time is not a valid lesson slot");
    }

    private Room resolveRoom(Long roomId) {
        if (roomId == null) {
            return null;
        }

        return roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found with id: " + roomId));
    }

    private void validateWeeklyHoursCapacity(Assignment assignment, Integer durationHours, Long editingLessonId) {
        int duration = durationHours == null ? 0 : durationHours;
        int placedHours = lessonRepository.findByAssignmentId(assignment.getId()).stream()
                .filter(lesson -> editingLessonId == null || !lesson.getId().equals(editingLessonId))
                .map(Lesson::getDurationHours)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();
        int weeklyHours = assignment.getHoursPerWeek() == null ? 0 : assignment.getHoursPerWeek();

        if (placedHours + duration > weeklyHours) {
            throw new IllegalArgumentException(
                    "Weekly hours limit exceeded. Remaining hours: " + Math.max(0, weeklyHours - placedHours)
            );
        }
    }

    private record TimeBlock(LocalTime start, LocalTime end) {
        private boolean overlaps(TimeBlock other) {
            return start.isBefore(other.end) && end.isAfter(other.start);
        }
    }

    private record MoveCheck(
            TimeBlock targetBlock,
            List<String> messages
    ) {
        private boolean valid() {
            return messages.isEmpty();
        }

        private LocalTime targetEndTime() {
            return targetBlock != null ? targetBlock.end() : null;
        }
    }
}
