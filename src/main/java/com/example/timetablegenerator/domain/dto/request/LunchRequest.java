package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Data
public class LunchRequest {

    @NotNull
    private Long timetableId;

    @NotNull
    private Long groupId;

    @NotNull
    private DayOfWeek dayOfWeek;

    @NotNull
    private LocalTime startTime;

    @NotNull
    private LocalTime endTime;

    private boolean manual = true;
}