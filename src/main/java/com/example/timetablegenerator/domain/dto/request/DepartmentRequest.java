package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record DepartmentRequest(
        @NotBlank(message = "Department name is required")
        @Schema(example = "Department of Software Engineering")
        String name,

        @NotNull(message = "Faculty ID is required")
        @Positive(message = "Faculty ID must be positive")
        @Schema(example = "1")
        Long facultyId

) {}