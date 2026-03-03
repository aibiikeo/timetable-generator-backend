package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.RoomType;

public record RoomResponse(
        Long id,
        String name,
        Integer capacity,
        RoomType type
) {
}
