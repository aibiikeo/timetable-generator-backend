package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.DepartmentRequest;
import com.example.timetablegenerator.domain.dto.response.DepartmentResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.DepartmentService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Departments")
@RequestMapping("/api/departments")
@RequiredArgsConstructor
@Slf4j
public class DepartmentController {

    private final DepartmentService departmentService;

    @GetMapping
    public List<DepartmentResponse> getAllDepartments() {
        log.debug("app | Fetching all departments");
        return departmentService.getAllDepartments();
    }

    @GetMapping("/faculty/{facultyId}")
    public List<DepartmentResponse> getDepartmentsByFaculty(@PathVariable Long facultyId) {
        log.debug("app | Fetching departments for faculty ID: {}", facultyId);
        return departmentService.getDepartmentsByFaculty(facultyId);
    }

    @GetMapping("/{id}")
    public DepartmentResponse getDepartment(@PathVariable Long id) {
        log.debug("app | Fetching department with ID: {}", id);
        return departmentService.getDepartment(id)
                .orElseThrow(() -> new NotFoundException("Department with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public DepartmentResponse createDepartment(@Valid @RequestBody DepartmentRequest request) {
        log.info("app | Creating department '{}' for faculty {}", request.name(), request.facultyId());
        return departmentService.createDepartment(request);
    }

    @PutMapping("/{id}")
    public DepartmentResponse updateDepartment(
            @PathVariable Long id,
            @Valid @RequestBody DepartmentRequest request
    ) {
        log.info("app | Updating department {} -> '{}'", id, request.name());
        return departmentService.updateDepartment(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteDepartment(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode
    ) {
        log.info("app | Deleting department with ID: {} using mode: {}", id, mode);
        departmentService.deleteDepartment(id, mode);
    }
}