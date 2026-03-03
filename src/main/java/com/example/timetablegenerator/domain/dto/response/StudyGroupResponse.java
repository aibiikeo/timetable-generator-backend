package com.example.timetablegenerator.domain.dto.response;

public record StudyGroupResponse(
        Long id,
        String name,
        Long facultyId,
        String facultyName,
        Integer course,
        Integer studentCount
) {
}
