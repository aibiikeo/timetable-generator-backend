package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.domain.entities.TimetableStatus;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.TimetableMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.TimetableService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
@Slf4j
public class TimetableServiceImpl implements TimetableService {

    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
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
    public TimetableResponse updateTimetable(Long timetableId, TimetableRequest request) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        timetable.setAcademicYearStart(request.academicYearStart());
        timetable.setSemester(request.semester());
        timetable.setGenerationSettings(request.generationSettings());

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
    public TimetableResponse archiveTimetable(Long timetableId) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        timetable.setStatus(TimetableStatus.ARCHIVED);

        Timetable updated = timetableRepository.save(timetable);
        return timetableMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteTimetable(Long timetableId, DeleteMode mode) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        List<Assignment> assignments = new ArrayList<>(assignmentRepository.findByTimetableId(timetableId));
        List<Lesson> lessons = new ArrayList<>(lessonRepository.findByTimetableId(timetableId));

        switch (mode) {
            case SIMPLE -> {
                if (!assignments.isEmpty() || !lessons.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete timetable with id " + timetableId +
                                    " because it contains " + assignments.size() +
                                    " assignments and " + lessons.size() + " lessons"
                    );
                }
            }

            case DETACH, WITH -> {
                lessonRepository.deleteAll(lessons);
                assignmentRepository.deleteAll(assignments);
            }
        }

        timetableRepository.delete(timetable);

        log.info("Deleted timetable with id={} using mode={}", timetableId, mode);
    }
}
