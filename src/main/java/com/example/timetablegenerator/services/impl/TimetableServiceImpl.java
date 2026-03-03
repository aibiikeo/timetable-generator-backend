package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.domain.entities.TimetableStatus;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.TimetableMapper;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.TimetableService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
public class TimetableServiceImpl implements TimetableService {

    private final TimetableRepository timetableRepository;
    private final TimetableMapper timetableMapper;

    @Override
    public List<TimetableResponse> getAllTimetables() {
        return timetableRepository.findAll().stream()
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .map(timetableMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<TimetableResponse> getCurrentTimetable() {
        return timetableRepository.findAll().stream()
                .filter(Timetable::isCurrent)
                .findFirst()
                .map(timetableMapper::toResponse);
    }

    @Override
    public Optional<TimetableResponse> getTimetable(Long timetableId) {
        return timetableRepository.findById(timetableId)
                .map(timetableMapper::toResponse);
    }

    @Transactional
    @Override
    public TimetableResponse createTimetable(TimetableRequest request) {
        Timetable timetable = timetableMapper.toEntity(request);

        timetable.setCreatedAt(LocalDateTime.now());
        timetable.setCurrent(false);
        timetable.setPublished(false);
        timetable.setStatus(TimetableStatus.DRAFT);

        if (timetableRepository.count() == 0) {
            timetable.setCurrent(true);
        }

        Timetable saved = timetableRepository.save(timetable);
        return timetableMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public TimetableResponse publishTimetable(Long timetableId) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        timetableRepository.findAll().stream()
                .filter(Timetable::isCurrent)
                .forEach(t -> {
                    t.setCurrent(false);
                    t.setPublished(true);
                    t.setStatus(TimetableStatus.PUBLISHED);
                });

        timetable.setCurrent(true);
        timetable.setPublished(true);
        timetable.setStatus(TimetableStatus.PUBLISHED);

        Timetable updated = timetableRepository.save(timetable);
        return timetableMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteTimetable(Long timetableId) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        if (timetable.isCurrent()) {
            throw new IllegalStateException("Cannot delete current timetable");
        }

        if (timetable.isPublished()) {
            throw new IllegalStateException("Cannot delete published timetable");
        }

        timetableRepository.delete(timetable);
    }
}