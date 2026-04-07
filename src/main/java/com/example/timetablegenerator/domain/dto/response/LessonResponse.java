package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;

public record LessonResponse(
        Long id,
        Long timetableId,
        Long assignmentId,
        String subjectName,
        String teacherName,
        List<String> groupNames,
        String roomName,
        DayOfWeek dayOfWeek,
        LocalTime startTime,
        Integer durationHours,

        Long majorId,
        String majorName,
        Degree degree,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName
) {
}