package com.example.timetablegenerator.domain.dto.response;

import java.util.List;

public record PublicTimetableScheduleResponse(
        TimetableResponse timetable,
        int totalLessons,
        List<PublicTimetableLessonResponse> lessons,
        List<LunchResponse> lunches
) {
}
