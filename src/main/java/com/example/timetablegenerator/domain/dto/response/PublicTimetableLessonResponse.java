package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;

public record PublicTimetableLessonResponse(
        Long id,
        Long timetableId,
        String timetableName,
        DayOfWeek dayOfWeek,
        LocalTime startTime,
        LocalTime endTime,
        Integer durationHours,
        Long facultyId,
        String facultyName,
        Long departmentId,
        String departmentName,
        Long majorId,
        String majorName,
        Degree degree,
        Long subjectId,
        String subjectName,
        Long teacherId,
        String teacherName,
        Long roomId,
        String roomName,
        List<PublicFilterOptionResponse> groups
) {
}
