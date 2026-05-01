package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Data
public class LunchRequest {
    @NotNull
    @Schema(example = "3")
    private Long timetableId;

    @NotNull
    @Schema(example = "1")
    private Long groupId;

    @NotNull
    @Schema(example = "MONDAY")
    private DayOfWeek dayOfWeek;

    @NotNull
    @Schema(example = "12:20")
    private LocalTime startTime;

    @NotNull
    @Schema(example = "13:00")
    private LocalTime endTime;

    @Schema(example = "true")
    private boolean manual = true;
}