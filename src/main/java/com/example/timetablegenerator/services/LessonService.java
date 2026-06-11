package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.request.MoveLessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.domain.dto.response.MoveLessonValidationResponse;

import java.util.List;
import java.util.Optional;

public interface LessonService {

    List<LessonResponse> getAllLessons(Long timetableId);

    List<LessonResponse> getLessonsByAssignment(Long timetableId, Long assignmentId);

    List<LessonResponse> getLessonsByTeacher(Long timetableId, Long teacherId);

    List<LessonResponse> getLessonsByGroup(Long timetableId, Long groupId);

    List<LessonResponse> getLessonsByRoom(Long timetableId, Long roomId);

    Optional<LessonResponse> getLesson(Long timetableId, Long lessonId);

    LessonResponse createLesson(Long timetableId, LessonRequest request);

    LessonResponse updateLesson(Long timetableId, Long lessonId, LessonRequest request);

    MoveLessonValidationResponse validateLessonMove(Long timetableId, Long lessonId, MoveLessonRequest request);

    LessonResponse moveLesson(Long timetableId, Long lessonId, MoveLessonRequest request);

    void deleteLesson(Long timetableId, Long lessonId);
}
