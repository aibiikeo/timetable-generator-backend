package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.SemesterType;
import com.example.timetablegenerator.domain.entities.TimetableStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public record TimetableResponse(
        Long id,
        String name,
        Integer academicYearStart,
        Integer academicYearEnd,
        SemesterType semester,
        Integer version,
        LocalDateTime createdAt,
        TimetableStatus status,
        Map<String, Object> generationSettings,
        Map<String, Object> conflictReport,
        List<AssignmentResponse> assignments,
        int totalLessons,
        int totalRequiredLessons
) {
}