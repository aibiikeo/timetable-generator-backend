package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.LessonMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.LessonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

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
    @Transactional
    public void deleteLesson(Long timetableId, Long lessonId) {
        Lesson lesson = lessonRepository.findByTimetableIdAndId(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException(
                        "Lesson not found with id " + lessonId + " in timetable " + timetableId
                ));

        lesson.getGroups().clear();

        lessonRepository.delete(lesson);

        log.info("Deleted lesson with id={} from timetable={}", lessonId, timetableId);
    }

    private Room resolveRoom(Long roomId) {
        if (roomId == null) {
            return null;
        }

        return roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found with id: " + roomId));
    }
}