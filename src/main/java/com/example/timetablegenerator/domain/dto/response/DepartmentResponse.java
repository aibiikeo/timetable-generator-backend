package com.example.timetablegenerator.domain.dto.response;

public record DepartmentResponse(
        Long id,
        String name,
        Long facultyId,
        String facultyName,
        String facultyShortName
) {
}