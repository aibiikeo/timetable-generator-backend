package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.entities.TimeSlot;
import com.example.timetablegenerator.repositories.TimeSlotRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/time-slots")
@RequiredArgsConstructor
public class TimeSlotController {

    private final TimeSlotRepository timeSlotRepository;

    @GetMapping
    public List<TimeSlot> getAllTimeSlots() {
        return timeSlotRepository.findAll();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TimeSlot createTimeSlot(@RequestBody TimeSlot timeSlot) {
        return timeSlotRepository.save(timeSlot);
    }

    @PutMapping("/{id}")
    public TimeSlot updateTimeSlot(@PathVariable Long id, @RequestBody TimeSlot timeSlot) {
        timeSlot.setId(id);
        return timeSlotRepository.save(timeSlot);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTimeSlot(@PathVariable Long id) {
        timeSlotRepository.deleteById(id);
    }
}