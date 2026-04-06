package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;

public record MajorResponse(
        Long id,
        String name,
        Degree degree,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName,
        String facultyShortName
) {
}