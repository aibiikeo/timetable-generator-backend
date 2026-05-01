package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record LessonRequest(
        @NotNull(message = "Assignment ID is required")
        @Positive(message = "Assignment ID must be a positive number")
        @Schema(example = "1")
        Long assignmentId,

        @NotNull(message = "Day of week is required")
        @Schema(example = "MONDAY")
        DayOfWeek dayOfWeek,

        @NotNull(message = "Start time is required")
        @Schema(example = "09:00")
        LocalTime startTime,

        @NotNull(message = "Duration is required")
        @Min(value = 1, message = "Duration must be at least 1 hour")
        @Max(value = 8, message = "Duration cannot exceed 8 hours")
        @Schema(example = "2")
        Integer durationHours,

        @Schema(example = "1")
        Long roomId
) {
}
