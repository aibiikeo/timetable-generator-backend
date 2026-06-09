package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.TimeSlotRequest;
import com.example.timetablegenerator.domain.dto.response.TimeSlotResponse;
import com.example.timetablegenerator.domain.entities.TimeSlot;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.repositories.TimeSlotRepository;
import com.example.timetablegenerator.services.TimeSlotService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class TimeSlotServiceImpl implements TimeSlotService {

    private final TimeSlotRepository timeSlotRepository;

    @Override
    public List<TimeSlotResponse> getAllTimeSlots() {
        return timeSlotRepository.findAll()
                .stream()
                .sorted(Comparator
                        .comparing(TimeSlot::getDayOfWeek, Comparator.nullsFirst(Comparator.naturalOrder()))
                        .thenComparing(TimeSlot::getOrder, Comparator.nullsLast(Comparator.naturalOrder())))
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<TimeSlotResponse> getTimeSlotsByDay(DayOfWeek dayOfWeek) {
        return timeSlotRepository.findLessonSlotsByDay(dayOfWeek)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public Optional<TimeSlotResponse> getTimeSlot(Long id) {
        return timeSlotRepository.findById(id)
                .map(this::toResponse);
    }

    @Override
    @Transactional
    public TimeSlotResponse createTimeSlot(TimeSlotRequest request) {
        validateTimeRange(request);

        TimeSlot timeSlot = TimeSlot.builder()
                .dayOfWeek(request.dayOfWeek())
                .order(request.order())
                .startTime(request.startTime())
                .endTime(request.endTime())
                .description(request.description())
                .build();

        TimeSlot saved = timeSlotRepository.save(timeSlot);
        return toResponse(saved);
    }

    @Override
    @Transactional
    public TimeSlotResponse updateTimeSlot(Long id, TimeSlotRequest request) {
        validateTimeRange(request);

        TimeSlot existing = timeSlotRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("TimeSlot with id " + id + " not found"));

        existing.setDayOfWeek(request.dayOfWeek());
        existing.setOrder(request.order());
        existing.setStartTime(request.startTime());
        existing.setEndTime(request.endTime());
        existing.setDescription(request.description());

        TimeSlot saved = timeSlotRepository.save(existing);
        return toResponse(saved);
    }

    @Override
    @Transactional
    public void deleteTimeSlot(Long id) {
        if (!timeSlotRepository.existsById(id)) {
            throw new NotFoundException("TimeSlot with id " + id + " not found");
        }

        timeSlotRepository.deleteById(id);

        log.info("app | Deleted time slot with id={}", id);
    }

    private void validateTimeRange(TimeSlotRequest request) {
        if (!request.startTime().isBefore(request.endTime())) {
            throw new IllegalArgumentException("Start time must be before end time");
        }
    }

    private TimeSlotResponse toResponse(TimeSlot timeSlot) {
        return new TimeSlotResponse(
                timeSlot.getId(),
                timeSlot.getDayOfWeek(),
                timeSlot.getOrder(),
                timeSlot.getStartTime(),
                timeSlot.getEndTime(),
                timeSlot.getDescription()
        );
    }
}