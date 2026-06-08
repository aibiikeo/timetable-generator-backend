package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record MajorRequest(
        @NotBlank(message = "Major name is required")
        @Schema(example = "Software Engineering")
        String name,

        @NotBlank(message = "Faculty short name is required")
        @Size(max = 10, message = "Short name must not exceed 10 characters")
        @Schema(example = "SE")
        String shortName,

        @NotNull(message = "Department ID is required")
        @Positive(message = "Department ID must be positive")
        @Schema(example = "1")
        Long departmentId

) {}
