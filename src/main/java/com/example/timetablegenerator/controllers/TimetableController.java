package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.TimetableService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Timetables")
@RequestMapping("/api/timetables")
@RequiredArgsConstructor
@Slf4j
public class TimetableController {

    private final TimetableService timetableService;

    @GetMapping
    public List<TimetableResponse> getAllTimetables() {
        log.debug("Fetching all timetable versions");
        return timetableService.getAllTimetables();
    }

    @GetMapping("/published")
    public TimetableResponse getPublishedTimetable() {
        log.debug("Fetching published timetable");
        return timetableService.getPublishedTimetable()
                .orElseThrow(() -> new NotFoundException("No published timetable found"));
    }

    @GetMapping("/{id}")
    public TimetableResponse getTimetable(@PathVariable Long id) {
        log.debug("Fetching timetable ID: {}", id);
        return timetableService.getTimetable(id)
                .orElseThrow(() -> new NotFoundException("Timetable with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TimetableResponse createTimetable(@Valid @RequestBody TimetableRequest request) {
        log.info("Creating new timetable for {} {}", request.semester(), request.academicYearStart());
        return timetableService.createTimetable(request);
    }

    @PutMapping("/{id}")
    public TimetableResponse updateTimetable(
            @PathVariable Long id,
            @Valid @RequestBody TimetableRequest request
    ) {
        log.info("Updating timetable ID: {} for {} {}", id, request.semester(), request.academicYearStart());
        return timetableService.updateTimetable(id, request);
    }

    @PostMapping("/{id}/publish")
    @ResponseStatus(HttpStatus.OK)
    public TimetableResponse publishTimetable(@PathVariable Long id) {
        log.warn("Publishing timetable ID: {}", id);
        return timetableService.publishTimetable(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTimetable(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode
    ) {
        log.info("Deleting timetable with ID: {} using mode: {}", id, mode);
        timetableService.deleteTimetable(id, mode);
    }
}