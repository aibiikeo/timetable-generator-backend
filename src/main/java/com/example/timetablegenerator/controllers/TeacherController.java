package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TeacherRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.TeacherService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teachers")
@RequiredArgsConstructor
@Slf4j
public class TeacherController {

    private final TeacherService teacherService;

    @GetMapping
    public List<TeacherResponse> getAllTeachers() {
        log.debug("Fetching all teachers");
        return teacherService.getAllTeachers();
    }

    @GetMapping("/{id}")
    public TeacherResponse getTeacher(@PathVariable Long id) {
        log.debug("Fetching teacher with ID: {}", id);
        return teacherService.getTeacher(id)
                .orElseThrow(() -> new NotFoundException("Teacher with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TeacherResponse createTeacher(@Valid @RequestBody TeacherRequest request) {
        log.info("Creating new teacher: {}", request.fullName());
        return teacherService.createTeacher(request);
    }

    @PutMapping("/{id}")
    public TeacherResponse updateTeacher(
            @PathVariable Long id,
            @Valid @RequestBody TeacherRequest request) {

        log.info("Updating teacher ID: {} -> new name: {}", id, request.fullName());
        return teacherService.updateTeacher(id, request);
    }

    @GetMapping("/{id}/assignments")
    public ResponseEntity<List<AssignmentResponse>> getAssignmentsByTeacherId(@PathVariable Long id) {
        return ResponseEntity.ok(teacherService.getAssignmentsByTeacherId(id));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTeacher(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode) {
        log.info("Deleting teacher with ID: {} using mode: {}", id, mode);
        teacherService.deleteTeacher(id, mode);
    }
}