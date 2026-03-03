package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.AssignmentMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.AssignmentService;
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
public class AssignmentServiceImpl implements AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final TimetableRepository timetableRepository;
    private final AssignmentMapper assignmentMapper;

    @Override
    public List<AssignmentResponse> getAllAssignments(Long timetableId) {
        return assignmentRepository.findByTimetableId(timetableId).stream()
                .map(assignmentMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<AssignmentResponse> getAssignment(Long timetableId, Long assignmentId) {
        return assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .map(assignmentMapper::toResponse);
    }

    @Transactional
    @Override
    public AssignmentResponse createAssignment(Long timetableId, AssignmentRequest request) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        Assignment assignment = assignmentMapper.toEntity(request);
        assignment.setTimetable(timetable);

        Assignment saved = assignmentRepository.save(assignment);
        return assignmentMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public AssignmentResponse updateAssignment(Long timetableId, Long assignmentId, AssignmentRequest request) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable: " + timetableId));

        assignmentMapper.updateEntityFromRequest(request, assignment);

        Assignment updated = assignmentRepository.save(assignment);
        return assignmentMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteAssignment(Long timetableId, Long assignmentId) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable: " + timetableId));

        assignmentRepository.delete(assignment);
    }
}
