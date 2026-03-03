package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.*;

public record SubjectRequest(
        @NotBlank(message = "Subject name is required")
        String name,

        @NotBlank(message = "Subject code is required")
        String code,

        @NotNull(message = "Total hours is required")
        @Positive(message = "Total hours must be positive")
        Integer totalHours,

        @NotNull(message = "Hours per week is required")
        @Positive(message = "Hours per week must be positive")
        Integer hoursPerWeek,

        @NotNull(message = "Faculty ID is required")
        @Positive(message = "Faculty ID must be positive")
        Long facultyId
) {
}

