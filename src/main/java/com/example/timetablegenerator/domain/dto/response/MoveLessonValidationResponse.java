package com.example.timetablegenerator.domain.dto.response;

import java.time.LocalTime;
import java.util.List;

public record MoveLessonValidationResponse(
        boolean valid,
        List<String> conflicts,
        LocalTime targetEndTime
) {
}
