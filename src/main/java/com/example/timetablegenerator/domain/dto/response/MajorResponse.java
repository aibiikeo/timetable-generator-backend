package com.example.timetablegenerator.domain.dto.response;

public record MajorResponse(
        Long id,
        String name,
        String shortName,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName
) {
}
