package com.example.timetablegenerator.domain.dto.response;

public record SubjectResponse(
        Long id,
        String name,
        String code,
        Integer totalHours,
        Integer hoursPerWeek,
        Long facultyId
) {
}
