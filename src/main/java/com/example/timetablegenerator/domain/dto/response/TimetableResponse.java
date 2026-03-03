package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.TimetableStatus;

import java.time.LocalDateTime;
import java.util.List;

public record TimetableResponse(
        Long id,
        String name,
        LocalDateTime createdAt,
        boolean isCurrent,
        TimetableStatus status,
        List<AssignmentResponse> assignments,
        int totalLessons,
        int totalRequiredLessons
) {
}
