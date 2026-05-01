package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.FacultyRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.FacultyService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Faculties")
@RequestMapping("/api/faculties")
@RequiredArgsConstructor
@Slf4j
public class FacultyController {

    private final FacultyService facultyService;

    @GetMapping
    public List<FacultyResponse> getAllFaculties() {
        log.info("Fetching all faculties");
        return facultyService.getAllFaculties();
    }

    @GetMapping("/{id}")
    public FacultyResponse getFaculty(@PathVariable Long id) {
        log.info("Fetching faculty with ID: {}", id);
        return facultyService.getFaculty(id)
                .orElseThrow(() -> new NotFoundException("Faculty with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public FacultyResponse createFaculty(@Valid @RequestBody FacultyRequest request) {
        log.info("Creating new faculty: {} ", request.name());
        return facultyService.createFaculty(request);
    }

    @PutMapping("/{id}")
    public FacultyResponse updateFaculty(@PathVariable Long id, @Valid @RequestBody FacultyRequest request) {
        log.info("Updating faculty ID: {} -> new name: {}", id, request.name());
        return facultyService.updateFaculty(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteFaculty(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode) {

        log.info("Deleting faculty with ID: {} using mode: {}", id, mode);
        facultyService.deleteFaculty(id, mode);
    }
}