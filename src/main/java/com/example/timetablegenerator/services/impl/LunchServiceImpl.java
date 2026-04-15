package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.LunchRequest;
import com.example.timetablegenerator.domain.dto.response.LunchResponse;
import com.example.timetablegenerator.domain.entities.Lunch;
import com.example.timetablegenerator.repositories.LunchRepository;
import com.example.timetablegenerator.services.LunchService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LunchServiceImpl implements LunchService {

    private final LunchRepository lunchRepository;

    @Override
    public LunchResponse create(LunchRequest request) {
        validateTimes(request);

        Lunch lunch = Lunch.builder()
                .timetableId(request.getTimetableId())
                .groupId(request.getGroupId())
                .dayOfWeek(request.getDayOfWeek())
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .manual(request.isManual())
                .build();

        return toResponse(lunchRepository.save(lunch));
    }

    @Override
    public LunchResponse update(Long id, LunchRequest request) {
        validateTimes(request);

        Lunch lunch = lunchRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lunch not found: " + id));

        lunch.setTimetableId(request.getTimetableId());
        lunch.setGroupId(request.getGroupId());
        lunch.setDayOfWeek(request.getDayOfWeek());
        lunch.setStartTime(request.getStartTime());
        lunch.setEndTime(request.getEndTime());
        lunch.setManual(request.isManual());

        return toResponse(lunchRepository.save(lunch));
    }

    @Override
    public void delete(Long id) {
        if (!lunchRepository.existsById(id)) {
            throw new EntityNotFoundException("Lunch not found: " + id);
        }
        lunchRepository.deleteById(id);
    }

    @Override
    public LunchResponse getById(Long id) {
        Lunch lunch = lunchRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lunch not found: " + id));
        return toResponse(lunch);
    }

    @Override
    public List<LunchResponse> getByTimetable(Long timetableId) {
        return lunchRepository.findByTimetableId(timetableId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<LunchResponse> getByTimetableAndGroup(Long timetableId, Long groupId) {
        return lunchRepository.findByTimetableIdAndGroupId(timetableId, groupId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public void deleteByTimetable(Long timetableId) {
        lunchRepository.deleteByTimetableId(timetableId);
    }

    private void validateTimes(LunchRequest request) {
        if (!request.getEndTime().isAfter(request.getStartTime())) {
            throw new IllegalArgumentException("Lunch endTime must be after startTime");
        }
    }

    private LunchResponse toResponse(Lunch lunch) {
        return LunchResponse.builder()
                .id(lunch.getId())
                .timetableId(lunch.getTimetableId())
                .groupId(lunch.getGroupId())
                .dayOfWeek(lunch.getDayOfWeek())
                .startTime(lunch.getStartTime())
                .endTime(lunch.getEndTime())
                .manual(lunch.isManual())
                .build();
    }
}