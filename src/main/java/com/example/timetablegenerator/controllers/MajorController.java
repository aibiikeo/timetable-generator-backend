package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.MajorRequest;
import com.example.timetablegenerator.domain.dto.response.MajorResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.MajorService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Majors")
@RequestMapping("/api/majors")
@RequiredArgsConstructor
@Slf4j
public class MajorController {

    private final MajorService majorService;

    @GetMapping
    public List<MajorResponse> getAllMajors() {
        log.debug("Fetching all majors");
        return majorService.getAllMajors();
    }

    @GetMapping("/department/{departmentId}")
    public List<MajorResponse> getMajorsByDepartment(@PathVariable Long departmentId) {
        log.debug("Fetching majors for department ID: {}", departmentId);
        return majorService.getMajorsByDepartment(departmentId);
    }

    @GetMapping("/faculty/{facultyId}")
    public List<MajorResponse> getMajorsByFaculty(@PathVariable Long facultyId) {
        log.debug("Fetching majors for faculty ID: {}", facultyId);
        return majorService.getMajorsByFaculty(facultyId);
    }

    @GetMapping("/{id}")
    public MajorResponse getMajor(@PathVariable Long id) {
        log.debug("Fetching major with ID: {}", id);
        return majorService.getMajor(id)
                .orElseThrow(() -> new NotFoundException("Major with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public MajorResponse createMajor(@Valid @RequestBody MajorRequest request) {
        log.info("Creating major '{}' in department {}", request.name(), request.departmentId());
        return majorService.createMajor(request);
    }

    @PutMapping("/{id}")
    public MajorResponse updateMajor(
            @PathVariable Long id,
            @Valid @RequestBody MajorRequest request
    ) {
        log.info("Updating major {} -> '{}'", id, request.name());
        return majorService.updateMajor(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteMajor(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode
    ) {
        log.info("Deleting major with ID: {} using mode: {}", id, mode);
        majorService.deleteMajor(id, mode);
    }
}