package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.response.PublicTimetableScheduleResponse;
import com.example.timetablegenerator.services.PublicTimetableService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.DayOfWeek;

@RestController
@Tag(name = "AIU Public Timetable")
@RequestMapping("/api/aiu-timetable")
@RequiredArgsConstructor
public class PublicTimetableController {

    private final PublicTimetableService publicTimetableService;

    @GetMapping
    public PublicTimetableScheduleResponse getSchedule(
            @RequestParam(required = false) Long facultyId,
            @RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) Long majorId,
            @RequestParam(required = false) Long groupId,
            @RequestParam(required = false) Long teacherId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) Long roomId,
            @RequestParam(required = false) DayOfWeek dayOfWeek
    ) {
        return publicTimetableService.getSchedule(
                facultyId,
                departmentId,
                majorId,
                groupId,
                teacherId,
                subjectId,
                roomId,
                dayOfWeek
        );
    }
}
