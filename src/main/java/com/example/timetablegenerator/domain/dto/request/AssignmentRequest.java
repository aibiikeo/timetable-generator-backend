package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;

import java.time.DayOfWeek;
import java.util.List;

public record AssignmentRequest(
        @NotNull(message = "Subject ID is required") @Positive Long subjectId,
        @NotNull(message = "Teacher ID is required") @Positive Long teacherId,
        @NotEmpty(message = "At least one group must be assigned") List<@Positive Long> groupIds,
        @NotNull(message = "Hours per week is required") @Positive Integer hoursPerWeek,
        @NotNull(message = "Shift is required") Shift shift,
        @NotNull(message = "Required room type is required") RoomType roomTypeRequired,

        @Pattern(
                regexp = "^([1-4]\\+)*[1-4]$|^$",
                message = "Use format like '4+1' or '3+2+1' with numbers 1, 2, 3, 4"
        )
        String hoursSplitting,

        List<DayOfWeek> excludedDays,
        List<TimeSlotExclusion> excludedTimeSlots,
        List<DayOfWeek> preferredDays,
        Long specificRoomId
) {
    public record TimeSlotExclusion(
            DayOfWeek day,
            String startTime,
            String endTime
    ) {}
}