package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.*;

public record StudyGroupRequest(

        @NotBlank(message = "Group name is required")
        String name,

        @NotNull(message = "Major ID is required")
        @Positive(message = "Major ID must be positive")
        Long majorId,

        @NotNull(message = "Course is required")
        @Min(value = 1, message = "Course must be at least 1")
        @Max(value = 6, message = "Course must not exceed 6")
        Integer course,

        @NotNull(message = "Student count is required")
        @PositiveOrZero(message = "Student count cannot be negative")
        Integer studentCount

) {}