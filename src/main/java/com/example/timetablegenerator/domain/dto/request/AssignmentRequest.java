package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import jakarta.validation.constraints.*;

import java.time.DayOfWeek;
import java.util.List;

public record AssignmentRequest(
        @NotNull(message = "Subject ID is required") @Positive Long subjectId,
        @NotNull(message = "Teacher ID is required") @Positive Long teacherId,
        @NotEmpty(message = "At least one group must be assigned") List<@Positive Long> groupIds,
        @NotNull(message = "Hours per week is required") @Positive Integer hoursPerWeek,
        @NotNull(message = "Shift is required") Shift shift,
        @NotNull(message = "Required room type is required") RoomType roomTypeRequired,

        // Разделение часов - опционально, если не указано, система сама выберет
        @Pattern(regexp = "^([2-4]\\+)*[2-4]$|^$",
                message = "Use format like '4+4' or '3+3+2' with numbers 2, 3, 4")
        String hoursSplitting,

        // Новые поля для настроек
        List<DayOfWeek> excludedDays,           // Дни, когда нельзя проводить
        List<TimeSlotExclusion> excludedTimeSlots, // Конкретные время и дни
        List<DayOfWeek> preferredDays,          // Предпочтительные дни преподавателя
        Long specificRoomId                     // Конкретная аудитория (если выбрана)
) {
    public record TimeSlotExclusion(
            DayOfWeek day,
            String startTime,  // "08:00"
            String endTime     // "10:00"
    ) {}
}