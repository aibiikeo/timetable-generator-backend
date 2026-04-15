package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import lombok.Data;

import java.time.DayOfWeek;
import java.util.List;
import java.util.Set;

@Data
public class LessonVertex {

    private Long id;
    private Long assignmentId;

    private Set<Long> groupIds;
    private Long teacherId;

    private Shift shift;
    private RoomType roomTypeRequired;
    private Long specificRoomId;

    private int durationHours;

    private Set<DayOfWeek> excludedDays;
    private List<TimeSlotExclusion> excludedTimeSlots;
    private List<DayOfWeek> preferredDays;
}