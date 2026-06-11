package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.RoomType;

import java.time.DayOfWeek;
import java.time.LocalTime;

public record ManualPlacementSuggestionResponse(
        DayOfWeek dayOfWeek,
        LocalTime startTime,
        LocalTime endTime,
        Integer durationHours,
        Long roomId,
        String roomName,
        RoomType roomType,
        Integer roomCapacity,
        int score
) {
}
