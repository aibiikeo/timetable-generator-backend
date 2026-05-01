package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.RoomType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record RoomRequest(
        @NotBlank(message = "Room name is required")
        @Schema(example = "A-101")
        String name,

        @NotNull(message = "Capacity is required")
        @Positive(message = "Capacity must be greater than 0")
        @Schema(example = "30")
        Integer capacity,

        @NotNull(message = "Room type is required")
        @Schema(example = "CLASSROOM")
        RoomType type
) {
}

