package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;

import java.time.DayOfWeek;
import java.util.List;

public record AssignmentRequest(
        @NotNull(message = "Subject ID is required")
        @Positive
        @Schema(example = "1")
        Long subjectId,

        @NotNull(message = "Teacher ID is required")
        @Positive
        @Schema(example = "1")
        Long teacherId,

        @NotEmpty(message = "At least one group must be assigned")
        @Schema(example = "[1]")
        List<@Positive Long> groupIds,

        @NotNull(message = "Hours per week is required")
        @Positive
        @Schema(example = "4")
        Integer hoursPerWeek,

        @NotNull(message = "Shift is required")
        @Schema(example = "MORNING")
        Shift shift,

        @NotNull(message = "Required room type is required")
        @Schema(example = "CLASSROOM")
        RoomType roomTypeRequired,

        @Pattern(
                regexp = "^([1-4]\\+)*[1-4]$|^$",
                message = "Use format like '4+1' or '3+2+1' with numbers 1, 2, 3, 4"
        )
        @Schema(example = "2+2")
        String hoursSplitting,

        @Schema(example = "[\"SATURDAY\"]")
        List<DayOfWeek> excludedDays,

        @Schema(example = "[{\"day\":\"MONDAY\",\"startTime\":\"12:00\",\"endTime\":\"14:00\"}]")
        List<TimeSlotExclusion> excludedTimeSlots,

        @Schema(example = "[\"MONDAY\",\"WEDNESDAY\"]")
        List<DayOfWeek> preferredDays,

        @Schema(example = "1")
        Long specificRoomId
) {
    public record TimeSlotExclusion(
            @Schema(example = "MONDAY")
            DayOfWeek day,

            @Schema(example = "12:00")
            String startTime,

            @Schema(example = "14:00")
            String endTime
    ) {}
}