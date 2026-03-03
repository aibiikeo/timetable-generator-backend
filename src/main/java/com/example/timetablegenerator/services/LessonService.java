package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;

import java.util.List;
import java.util.Optional;

public interface LessonService {

    List<LessonResponse> getAllLessons(Long versionId);

    List<LessonResponse> getLessonsByAssignment(Long versionId, Long assignmentId);

    List<LessonResponse> getLessonsByTeacher(Long versionId, Long teacherId);

    List<LessonResponse> getLessonsByGroup(Long versionId, Long groupId);

    List<LessonResponse> getLessonsByRoom(Long versionId, Long roomId);

    Optional<LessonResponse> getLesson(Long versionId, Long lessonId);

    LessonResponse createLesson(Long versionId, LessonRequest request);

    LessonResponse updateLesson(Long versionId, Long lessonId, LessonRequest request);

    void deleteLesson(Long versionId, Long lessonId);
}
