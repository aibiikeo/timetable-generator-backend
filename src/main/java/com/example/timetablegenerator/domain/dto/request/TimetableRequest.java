package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

import java.util.List;
import java.util.Map;

public record TimetableRequest(

        @NotBlank(message = "Timetable name is required")
        String name,

//        @NotEmpty(message = "At least one assignment is required")
        @NotNull
        List<@Valid AssignmentRequest> assignments,

        @NotNull
        Map<String, Object> generationSettings
) {
}
