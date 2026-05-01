package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.TimeSlotRequest;
import com.example.timetablegenerator.domain.dto.response.TimeSlotResponse;

import java.time.DayOfWeek;
import java.util.List;
import java.util.Optional;

public interface TimeSlotService {

    List<TimeSlotResponse> getAllTimeSlots();

    List<TimeSlotResponse> getTimeSlotsByDay(DayOfWeek dayOfWeek);

    Optional<TimeSlotResponse> getTimeSlot(Long id);

    TimeSlotResponse createTimeSlot(TimeSlotRequest request);

    TimeSlotResponse updateTimeSlot(Long id, TimeSlotRequest request);

    void deleteTimeSlot(Long id);
}