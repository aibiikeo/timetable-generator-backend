package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record DepartmentRequest(

        @NotBlank(message = "Department name is required")
        String name,

        @NotNull(message = "Faculty ID is required")
        @Positive(message = "Faculty ID must be positive")
        Long facultyId

) {}