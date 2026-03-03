package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.LessonService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/timetables/{timetableId}/lessons")  // ← как ты и хотел
@RequiredArgsConstructor
public class LessonController {

    private final LessonService lessonService;

    @GetMapping
    public List<LessonResponse> getAllLessons(@PathVariable Long timetableId) {
        return lessonService.getAllLessons(timetableId);
    }

    @GetMapping("/assignment/{assignmentId}")
    public List<LessonResponse> getLessonsByAssignment(
            @PathVariable Long timetableId,
            @PathVariable Long assignmentId) {
        return lessonService.getLessonsByAssignment(timetableId, assignmentId);
    }

    @GetMapping("/teacher/{teacherId}")
    public List<LessonResponse> getLessonsByTeacher(
            @PathVariable Long timetableId,
            @PathVariable Long teacherId) {
        return lessonService.getLessonsByTeacher(timetableId, teacherId);
    }

    @GetMapping("/group/{groupId}")
    public List<LessonResponse> getLessonsByGroup(
            @PathVariable Long timetableId,
            @PathVariable Long groupId) {
        return lessonService.getLessonsByGroup(timetableId, groupId);
    }

    @GetMapping("/room/{roomId}")
    public List<LessonResponse> getLessonsByRoom(
            @PathVariable Long timetableId,
            @PathVariable Long roomId) {
        return lessonService.getLessonsByRoom(timetableId, roomId);
    }

    @GetMapping("/{lessonId}")
    public LessonResponse getLesson(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId) {

        return lessonService.getLesson(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException("Lesson with id " + lessonId + " not found in timetable " + timetableId));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public LessonResponse createLesson(
            @PathVariable Long timetableId,
            @Valid @RequestBody LessonRequest request) {
        return lessonService.createLesson(timetableId, request);
    }

    @PutMapping("/{lessonId}")
    public LessonResponse updateLesson(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId,
            @Valid @RequestBody LessonRequest request) {
        return lessonService.updateLesson(timetableId, lessonId, request);
    }

    @DeleteMapping("/{lessonId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteLesson(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId) {
        lessonService.deleteLesson(timetableId, lessonId);
    }
}