package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.AssignmentService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Assignments")
@RequestMapping("/api/timetables/{timetableId}/assignments")
@RequiredArgsConstructor
@Slf4j
public class AssignmentController {

    private final AssignmentService assignmentService;

    @GetMapping
    public List<AssignmentResponse> getAllAssignments(@PathVariable Long timetableId) {
        log.debug("app | Fetching all assignments for timetable ID: {}", timetableId);
        return assignmentService.getAllAssignments(timetableId);
    }

    @GetMapping("/{assignmentId}")
    public AssignmentResponse getAssignment(
            @PathVariable Long timetableId,
            @PathVariable Long assignmentId) {

        log.debug("app | Fetching assignment ID: {} in timetable ID: {}", assignmentId, timetableId);
        return assignmentService.getAssignment(timetableId, assignmentId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment with id " + assignmentId + " not found in timetable " + timetableId));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AssignmentResponse createAssignment(
            @PathVariable Long timetableId,
            @Valid @RequestBody AssignmentRequest request) {

        log.info("app | Creating new assignment in timetable {}: subjectId={}, teacherId={}, groups={}, {}h/week",
                timetableId, request.subjectId(), request.teacherId(), request.groupIds(), request.hoursPerWeek());
        return assignmentService.createAssignment(timetableId, request);
    }

    @PutMapping("/{assignmentId}")
    public AssignmentResponse updateAssignment(
            @PathVariable Long timetableId,
            @PathVariable Long assignmentId,
            @Valid @RequestBody AssignmentRequest request) {

        log.info("app | Updating assignment ID: {} in timetable {}", assignmentId, timetableId);
        return assignmentService.updateAssignment(timetableId, assignmentId, request);
    }

    @DeleteMapping("/{assignmentId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteAssignment(
            @PathVariable Long timetableId,
            @PathVariable Long assignmentId,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode) {

        log.info("app | Deleting assignment ID: {} from timetable {} using mode {}", assignmentId, timetableId, mode);
        assignmentService.deleteAssignment(timetableId, assignmentId, mode);
    }
}