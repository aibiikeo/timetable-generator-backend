package com.example.timetablegenerator.domain.dto.response;

public record UnplacedLesson(
        Long assignmentId,
        String reason
) {}
