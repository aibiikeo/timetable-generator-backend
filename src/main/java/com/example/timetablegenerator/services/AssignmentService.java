package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;

import java.util.List;
import java.util.Optional;

public interface AssignmentService {

    List<AssignmentResponse> getAllAssignments(Long timetableId);

    Optional<AssignmentResponse> getAssignment(Long timetableId, Long assignmentId);

    AssignmentResponse createAssignment(Long timetableId, AssignmentRequest request);

    AssignmentResponse updateAssignment(Long timetableId, Long assignmentId, AssignmentRequest request);

    void deleteAssignment(Long timetableId, Long assignmentId, DeleteMode mode);
}