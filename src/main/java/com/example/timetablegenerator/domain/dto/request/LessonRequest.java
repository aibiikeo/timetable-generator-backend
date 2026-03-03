package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.*;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record LessonRequest(
        @NotNull(message = "Assignment ID is required")
        @Positive(message = "Assignment ID must be a positive number")
        Long assignmentId,

        @NotNull(message = "Day of week is required")
        DayOfWeek dayOfWeek,

        @NotNull(message = "Start time is required")
        LocalTime startTime,

        @NotNull(message = "Duration is required")
        @Min(value = 1, message = "Duration must be at least 1 hour")
        @Max(value = 8, message = "Duration cannot exceed 8 hours")
        Integer durationHours,

        Long roomId
) {
}
