package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.Semester;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.Map;

public record TimetableRequest(

        String name,

        @NotNull(message = "Academic year start is required")
        Integer academicYearStart,

        @NotNull(message = "Semester is required")
        Semester semester,

        @NotNull(message = "Assignments are required")
        List<@Valid AssignmentRequest> assignments,

        @NotNull(message = "Generation settings are required")
        Map<String, Object> generationSettings
) {
}