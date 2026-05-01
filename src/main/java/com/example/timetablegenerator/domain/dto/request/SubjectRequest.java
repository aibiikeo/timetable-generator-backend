package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record SubjectRequest(

        @NotBlank(message = "Subject name is required")
        @Schema(example = "Algorithms and Data Structures")
        String name,

        @NotBlank(message = "Subject code is required")
        @Schema(example = "CS201")
        String code,

        @NotNull(message = "Total hours is required")
        @Positive(message = "Total hours must be positive")
        @Schema(example = "60")
        Integer totalHours,

        @NotNull(message = "Hours per week is required")
        @Positive(message = "Hours per week must be positive")
        @Schema(example = "4")
        Integer hoursPerWeek,

        @NotNull(message = "Major ID is required")
        @Positive(message = "Major ID must be positive")
        @Schema(example = "19")
        Long majorId

) {}