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
        return timetableRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(timetableMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<TimetableResponse> getPublishedTimetable() {
        return timetableRepository.findFirstByStatusOrderByCreatedAtDesc(TimetableStatus.PUBLISHED)
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

        Integer maxVersion = timetableRepository.findMaxVersion(
                request.academicYearStart(),
                request.semester()
        );

        int newVersion = (maxVersion == null) ? 0 : maxVersion + 1;

        timetable.setVersion(newVersion);
        timetable.setStatus(TimetableStatus.DRAFT);

        if (request.name() != null && !request.name().isBlank()) {
            timetable.setName(request.name().trim());
        }

        timetable.syncDerivedFields();

        Timetable saved = timetableRepository.save(timetable);
        return timetableMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public TimetableResponse publishTimetable(Long timetableId) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        List<Timetable> publishedTimetables = timetableRepository.findAllByStatus(TimetableStatus.PUBLISHED);

        for (Timetable published : publishedTimetables) {
            if (!published.getId().equals(timetableId)) {
                published.setStatus(TimetableStatus.ARCHIVED);
            }
        }

        timetable.setStatus(TimetableStatus.PUBLISHED);

        Timetable updated = timetableRepository.save(timetable);
        return timetableMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteTimetable(Long timetableId) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        if (timetable.getStatus() == TimetableStatus.PUBLISHED) {
            throw new IllegalStateException("Cannot delete published timetable");
        }

        timetableRepository.delete(timetable);
    }
}