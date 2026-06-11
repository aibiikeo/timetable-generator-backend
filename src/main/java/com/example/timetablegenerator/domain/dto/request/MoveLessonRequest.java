package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record MoveLessonRequest(
        @NotNull(message = "Day of week is required")
        @Schema(example = "MONDAY")
        DayOfWeek dayOfWeek,

        @NotNull(message = "Start time is required")
        @Schema(example = "14:00")
        LocalTime startTime
) {
}
