package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.domain.dto.request.MoveLessonRequest;
import com.example.timetablegenerator.domain.dto.response.MoveLessonValidationResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.LessonService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Lessons")
@RequestMapping("/api/timetables/{timetableId}/lessons")
@RequiredArgsConstructor
@Slf4j
public class LessonController {

    private final LessonService lessonService;

    @GetMapping
    public List<LessonResponse> getAllLessons(@PathVariable Long timetableId) {
        return lessonService.getAllLessons(timetableId);
    }

    @GetMapping("/{lessonId}")
    public LessonResponse getLesson(@PathVariable Long timetableId, @PathVariable Long lessonId) {
        return lessonService.getLesson(timetableId, lessonId)
                .orElseThrow(() -> new NotFoundException("Lesson with id " + lessonId + " not found"));
    }

    @GetMapping("/assignment/{assignmentId}")
    public List<LessonResponse> getLessonsByAssignment(@PathVariable Long timetableId, @PathVariable Long assignmentId) {
        return lessonService.getLessonsByAssignment(timetableId, assignmentId);
    }

    @GetMapping("/teacher/{teacherId}")
    public List<LessonResponse> getLessonsByTeacher(@PathVariable Long timetableId, @PathVariable Long teacherId) {
        return lessonService.getLessonsByTeacher(timetableId, teacherId);
    }

    @GetMapping("/group/{groupId}")
    public List<LessonResponse> getLessonsByGroup(@PathVariable Long timetableId, @PathVariable Long groupId) {
        return lessonService.getLessonsByGroup(timetableId, groupId);
    }

    @GetMapping("/room/{roomId}")
    public List<LessonResponse> getLessonsByRoom(@PathVariable Long timetableId, @PathVariable Long roomId) {
        return lessonService.getLessonsByRoom(timetableId, roomId);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public LessonResponse createLesson(@PathVariable Long timetableId, @Valid @RequestBody LessonRequest request) {
        return lessonService.createLesson(timetableId, request);
    }

    @PutMapping("/{lessonId}")
    public LessonResponse updateLesson(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId,
            @Valid @RequestBody LessonRequest request) {
        return lessonService.updateLesson(timetableId, lessonId, request);
    }

    @PostMapping("/{lessonId}/move/validate")
    public MoveLessonValidationResponse validateLessonMove(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId,
            @Valid @RequestBody MoveLessonRequest request) {
        return lessonService.validateLessonMove(timetableId, lessonId, request);
    }

    @PatchMapping("/{lessonId}/move")
    public LessonResponse moveLesson(
            @PathVariable Long timetableId,
            @PathVariable Long lessonId,
            @Valid @RequestBody MoveLessonRequest request) {
        return lessonService.moveLesson(timetableId, lessonId, request);
    }

    @DeleteMapping("/{lessonId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteLesson(@PathVariable Long timetableId, @PathVariable Long lessonId) {
        lessonService.deleteLesson(timetableId, lessonId);
    }
}
