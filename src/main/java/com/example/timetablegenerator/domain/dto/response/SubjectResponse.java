package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;

public record SubjectResponse(
        Long id,
        String name,
        String code,
        Integer totalHours,
        Integer hoursPerWeek,
        Long majorId,
        String majorName,
        Degree degree,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName
) {
}