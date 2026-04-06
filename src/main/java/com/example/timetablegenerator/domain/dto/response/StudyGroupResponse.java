package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;

public record StudyGroupResponse(
        Long id,
        String name,
        Integer course,
        Integer studentCount,
        Long majorId,
        String majorName,
        Degree degree,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName,
        String facultyShortName
) {
}