package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.Degree;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record MajorRequest(

        @NotBlank(message = "Major name is required")
        String name,

        @NotNull(message = "Degree is required")
        Degree degree,

        @NotNull(message = "Department ID is required")
        @Positive(message = "Department ID must be positive")
        Long departmentId

) {}