package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.LunchRequest;
import com.example.timetablegenerator.domain.dto.response.LunchResponse;
import com.example.timetablegenerator.services.LunchService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lunch")
@RequiredArgsConstructor
public class LunchController {

    private final LunchService lunchService;

    @PostMapping
    public LunchResponse create(@Valid @RequestBody LunchRequest request) {
        return lunchService.create(request);
    }

    @PutMapping("/{id}")
    public LunchResponse update(
            @PathVariable Long id,
            @Valid @RequestBody LunchRequest request
    ) {
        return lunchService.update(id, request);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        lunchService.delete(id);
    }

    @GetMapping("/{id}")
    public LunchResponse getById(@PathVariable Long id) {
        return lunchService.getById(id);
    }

    @GetMapping("/timetable/{timetableId}")
    public List<LunchResponse> getByTimetable(@PathVariable Long timetableId) {
        return lunchService.getByTimetable(timetableId);
    }

    @GetMapping("/timetable/{timetableId}/group/{groupId}")
    public List<LunchResponse> getByTimetableAndGroup(
            @PathVariable Long timetableId,
            @PathVariable Long groupId
    ) {
        return lunchService.getByTimetableAndGroup(timetableId, groupId);
    }
}