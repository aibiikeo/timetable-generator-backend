package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.TimetableService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/timetables")
@RequiredArgsConstructor
@Slf4j
public class TimetableController {

    private final TimetableService timetableService;

    // Все версии расписания
    @GetMapping
    public List<TimetableResponse> getAllTimetables() {
        log.debug("Fetching all timetable versions");
        return timetableService.getAllTimetables();
    }

    // Текущая (опубликованная) версия
    @GetMapping("/current")
    public TimetableResponse getCurrentTimetable() {
        log.debug("Fetching current (published) timetable");
        return timetableService.getCurrentTimetable()
                .orElseThrow(() -> new NotFoundException("No published timetable found"));
    }

    // Конкретная версия по ID
    @GetMapping("/{id}")
    public TimetableResponse getTimetable(@PathVariable Long id) {
        log.debug("Fetching timetable version ID: {}", id);
        return timetableService.getTimetable(id)
                .orElseThrow(() -> new NotFoundException("Timetable with id " + id + " not found"));
    }

    // Создание новой версии (черновика)
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TimetableResponse createTimetable(@Valid @RequestBody TimetableRequest request) {
        log.info("Creating new timetable version: '{}' with {} assignments",
                request.name(), request.assignments().size());
        return timetableService.createTimetable(request);
    }

    // Публикация версии — делаем её текущей
    @PostMapping("/{id}/publish")
    @ResponseStatus(HttpStatus.OK)
    public TimetableResponse publishTimetable(@PathVariable Long id) {
        log.warn("Publishing timetable version ID: {} — it will become the current one", id);
        return timetableService.publishTimetable(id);
    }

    // Удаление версии (только если не опубликована, иначе — бизнес-ошибка в сервисе)
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTimetable(@PathVariable Long id) {
        log.info("Deleting timetable version ID: {}", id);
        timetableService.deleteTimetable(id);
    }
}