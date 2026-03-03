package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.RoomType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record RoomRequest(
        @NotBlank(message = "Room name is required")
        String name,

//        @Positive(message = "Capacity must be greater than 0")
        Integer capacity,

        @NotNull(message = "Room type is required")
        RoomType type
) {
}

