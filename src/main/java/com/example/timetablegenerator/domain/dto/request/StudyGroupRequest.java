package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.*;

public record StudyGroupRequest(
        @NotBlank(message = "Group name is required")
        String name,

        @NotNull(message = "Faculty ID is required")
        @Positive(message = "Faculty ID must be positive")
        Long facultyId,

        @NotNull(message = "Course is required")
        @Min(1) @Max(6)
        Integer course,

        @PositiveOrZero(message = "Student count cannot be negative")
        Integer studentCount
) {
}
