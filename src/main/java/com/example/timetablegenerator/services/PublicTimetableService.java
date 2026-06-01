package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.response.PublicTimetableFilterOptionsResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableScheduleResponse;

import java.time.DayOfWeek;

public interface PublicTimetableService {
    PublicTimetableFilterOptionsResponse getFilterOptions(Long facultyId, Long departmentId);

    PublicTimetableScheduleResponse getSchedule(
            Long facultyId,
            Long departmentId,
            Long majorId,
            Long groupId,
            Long teacherId,
            Long subjectId,
            Long roomId,
            DayOfWeek dayOfWeek
    );
}
