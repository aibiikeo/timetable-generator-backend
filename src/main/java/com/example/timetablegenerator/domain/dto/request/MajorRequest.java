package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.Degree;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record MajorRequest(

        @NotBlank(message = "Major name is required")
        String name,

        @NotBlank(message = "Faculty short name is required")
        @Size(max = 10, message = "Short name must not exceed 10 characters")
        String shortName,

        @NotNull(message = "Degree is required")
        Degree degree,

        @NotNull(message = "Department ID is required")
        @Positive(message = "Department ID must be positive")
        Long departmentId

) {}