package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.TimeSlotRequest;
import com.example.timetablegenerator.domain.dto.response.TimeSlotResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.TimeSlotService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek;
import java.util.List;

@RestController
@Tag(name = "Time Slots")
@RequestMapping("/api/time-slots")
@RequiredArgsConstructor
@Slf4j
public class TimeSlotController {

    private final TimeSlotService timeSlotService;

    @GetMapping
    public List<TimeSlotResponse> getAllTimeSlots() {
        log.debug("Fetching all time slots");
        return timeSlotService.getAllTimeSlots();
    }

    @GetMapping("/day/{dayOfWeek}")
    public List<TimeSlotResponse> getTimeSlotsByDay(@PathVariable DayOfWeek dayOfWeek) {
        log.debug("Fetching time slots for day: {}", dayOfWeek);
        return timeSlotService.getTimeSlotsByDay(dayOfWeek);
    }

    @GetMapping("/{id}")
    public TimeSlotResponse getTimeSlot(@PathVariable Long id) {
        log.debug("Fetching time slot with ID: {}", id);
        return timeSlotService.getTimeSlot(id)
                .orElseThrow(() -> new NotFoundException("TimeSlot with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TimeSlotResponse createTimeSlot(@Valid @RequestBody TimeSlotRequest request) {
        log.info("Creating time slot: day={}, order={}, start={}, end={}",
                request.dayOfWeek(), request.order(), request.startTime(), request.endTime());

        return timeSlotService.createTimeSlot(request);
    }

    @PutMapping("/{id}")
    public TimeSlotResponse updateTimeSlot(
            @PathVariable Long id,
            @Valid @RequestBody TimeSlotRequest request
    ) {
        log.info("Updating time slot ID: {}", id);
        return timeSlotService.updateTimeSlot(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTimeSlot(@PathVariable Long id) {
        log.info("Deleting time slot with ID: {}", id);
        timeSlotService.deleteTimeSlot(id);
    }
}