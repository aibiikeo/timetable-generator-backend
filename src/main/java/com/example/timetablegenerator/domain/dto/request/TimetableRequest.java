package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.Semester;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

public record TimetableRequest(
        @Schema(example = "Spring 2026 SE timetable")
        String name,

        @NotNull(message = "Academic year start is required")
        @Schema(example = "2025")
        Integer academicYearStart,

        @NotNull(message = "Semester is required")
        @Schema(example = "SPRING")
        Semester semester,

        @NotNull(message = "Faculty is required")
        @Schema(example = "1")
        Long facultyId
) {
}
