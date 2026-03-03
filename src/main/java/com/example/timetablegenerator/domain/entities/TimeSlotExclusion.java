package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.Embeddable;
import lombok.Data;

import java.time.DayOfWeek;

@Embeddable
@Data
public class TimeSlotExclusion {
    private DayOfWeek day;
    private String startTime;
    private String endTime;

    public TimeSlotExclusion() {
    }

    public TimeSlotExclusion(DayOfWeek day, String startTime, String endTime) {
        this.day = day;
        this.startTime = startTime;
        this.endTime = endTime;
    }
}
