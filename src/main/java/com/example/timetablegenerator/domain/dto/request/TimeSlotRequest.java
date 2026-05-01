package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record TimeSlotRequest(
        @Schema(example = "MONDAY")
        DayOfWeek dayOfWeek,

        @NotNull(message = "Slot order is required")
        @Schema(example = "1")
        Integer order,

        @NotNull(message = "Start time is required")
        @Schema(example = "08:00")
        LocalTime startTime,

        @NotNull(message = "End time is required")
        @Schema(example = "08:40")
        LocalTime endTime,

        @Schema(example = "First lesson")
        String description
) {
}