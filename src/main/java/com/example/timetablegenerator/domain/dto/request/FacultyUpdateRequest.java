package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.Size;

public record FacultyUpdateRequest(
        String name,

        @Size(max = 10, message = "Short name must not exceed 10 characters")
        String shortName
) {
}
