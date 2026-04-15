package com.example.timetablegenerator.domain.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalTime;

@Data
@Builder
public class LunchResponse {
    private Long id;
    private Long timetableId;
    private Long groupId;
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private boolean manual;
}