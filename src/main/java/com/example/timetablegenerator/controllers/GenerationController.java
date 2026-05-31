package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;
import com.example.timetablegenerator.services.GenerationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@Tag(name = "Generation")
@RequestMapping("/api/generation")
@RequiredArgsConstructor
@Slf4j
public class GenerationController {

    private final GenerationService generationService;

    @PostMapping("/timetables/{timetableId}/assignments")
    @PreAuthorize("hasRole('ADMIN') or hasRole('SUPER_ADMIN')")
    public ResponseEntity<AssignmentResponse> createAssignmentWithOptions(
            @PathVariable Long timetableId,
            @Valid @RequestBody AssignmentRequest request) {

        log.info("Creating assignment for timetable {}: subject={}, hours={}",
                timetableId, request.subjectId(), request.hoursPerWeek());

        AssignmentResponse response = generationService.createAssignmentWithOptions(timetableId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/splitting-options")
    public ResponseEntity<List<String>> getSplittingOptions(@RequestParam int hoursPerWeek) {
        log.debug("Getting splitting options for {} hours", hoursPerWeek);
        List<String> options = generationService.generateSplittingOptions(hoursPerWeek);
        return ResponseEntity.ok(options);
    }

    @PostMapping("/timetables/{timetableId}/generate")
    @PreAuthorize("hasRole('ADMIN') or hasRole('SUPER_ADMIN')")
    public ResponseEntity<GenerationResponse> generateTimetable(
            @PathVariable Long timetableId,
            @RequestParam(required = false, defaultValue = "NEW") GenerationMode mode) {
        log.info("Generating timetable {} with mode {}", timetableId, mode);
        GenerationResponse result = generationService.generateTimetable(timetableId, mode);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/timetables/{timetableId}/retry-failed")
    @PreAuthorize("hasRole('ADMIN') or hasRole('SUPER_ADMIN')")
    public ResponseEntity<GenerationResponse> retryFailedAssignments(
            @PathVariable Long timetableId,
            @RequestBody Map<Long, String> manualSplittings) {

        log.info("Retrying failed assignments for timetable {}: {}", timetableId, manualSplittings.size());
        GenerationResponse result = generationService.retryFailedAssignments(timetableId, manualSplittings);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/timetables/{timetableId}/assignments/{assignmentId}/manual-place")
    @PreAuthorize("hasRole('ADMIN') or hasRole('SUPER_ADMIN')")
    public ResponseEntity<Boolean> manualPlaceLesson(
            @PathVariable Long timetableId,
            @PathVariable Long assignmentId,
            @RequestParam String dayOfWeek,
            @RequestParam String startTime,
            @RequestParam Integer durationHours,
            @RequestParam Long roomId) {

        log.info("Manual placement for assignment {}: {} {} {}h room {}",
                assignmentId, dayOfWeek, startTime, durationHours, roomId);

        boolean success = generationService.manualPlaceLesson(
                timetableId, assignmentId, dayOfWeek, startTime, durationHours, roomId);

        return ResponseEntity.ok(success);
    }
}
