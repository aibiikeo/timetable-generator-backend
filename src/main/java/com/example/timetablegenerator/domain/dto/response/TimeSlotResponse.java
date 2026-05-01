package com.example.timetablegenerator.domain.dto.response;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record TimeSlotResponse(
        Long id,
        DayOfWeek dayOfWeek,
        Integer order,
        LocalTime startTime,
        LocalTime endTime,
        String description
) {
}