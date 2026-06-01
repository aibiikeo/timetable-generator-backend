package com.example.timetablegenerator.domain.dto.response;

import java.util.List;

public record UnplacedLesson(
        Long assignmentId,
        String subjectName,
        String teacherName,
        List<String> groupNames,
        String reason
) {}
