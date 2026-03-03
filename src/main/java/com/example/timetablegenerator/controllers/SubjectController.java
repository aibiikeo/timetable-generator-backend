package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.SubjectService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/subjects")
@RequiredArgsConstructor
@Slf4j
public class SubjectController {

    private final SubjectService subjectService;

    @GetMapping
    public List<SubjectResponse> getAllSubjects() {
        log.debug("Fetching all subjects");
        return subjectService.getAllSubjects();
    }

    @GetMapping("/{id}")
    public SubjectResponse getSubjectById(@PathVariable Long id) {
        log.debug("Fetching subject with ID: {}", id);
        return subjectService.getSubjectById(id)
                .orElseThrow(() -> new NotFoundException("Subject with id " + id + " not found"));
    }

    @GetMapping("/code/{code}")
    public SubjectResponse getSubjectByCode(@PathVariable String code) {
        log.debug("Fetching subject with code: {}", code);
        return subjectService.getSubjectByCode(code)
                .orElseThrow(() -> new NotFoundException("Subject with code '" + code + "' not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public SubjectResponse createSubject(@Valid @RequestBody SubjectRequest request) {
        log.info("Creating new subject: {} ({}) – {} hours/week, facultyId: {}",
                request.name(), request.code(), request.hoursPerWeek(), request.facultyId());
        return subjectService.createSubject(request);
    }

    @PutMapping("/{id}")
    public SubjectResponse updateSubject(
            @PathVariable Long id,
            @Valid @RequestBody SubjectRequest request) {

        log.info("Updating subject ID: {} → new name: {}, code: {}", id, request.name(), request.code());
        return subjectService.updateSubject(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteSubject(@PathVariable Long id) {
        log.info("Deleting subject with ID: {}", id);
        subjectService.deleteSubject(id);
    }

    @GetMapping("/{subjectId}/teachers")
    public List<TeacherResponse> getTeachersBySubject(@PathVariable Long subjectId) {
        log.debug("Fetching teachers for subject ID: {}", subjectId);
        return subjectService.getTeachersBySubject(subjectId);
    }
}