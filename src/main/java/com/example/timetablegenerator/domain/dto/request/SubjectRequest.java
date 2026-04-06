package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

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

        @NotNull(message = "Major ID is required")
        @Positive(message = "Major ID must be positive")
        Long majorId

) {}