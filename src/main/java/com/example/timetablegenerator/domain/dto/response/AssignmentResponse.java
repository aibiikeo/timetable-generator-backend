package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.Degree;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;

import java.util.List;

public record AssignmentResponse(
        Long id,
        Long subjectId,
        String subjectName,
        Long teacherId,
        String teacherName,
        List<Long> groupIds,
        List<String> groupNames,

        Integer hoursPerWeek,
        Shift shift,
        RoomType roomTypeRequired,
        Long specificRoomId,
        String hoursSplitting,
        int generatedLessonsCount,
        int requiredLessonsCount,

        String placementStatus,
        String failureReason,
        List<String> splittingOptions,
        String selectedSplitting,
        boolean requiresManualInput,

        Long majorId,
        String majorName,
        Degree degree,
        Long departmentId,
        String departmentName,
        Long facultyId,
        String facultyName
) {
}