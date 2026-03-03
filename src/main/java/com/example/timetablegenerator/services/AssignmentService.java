package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;

import java.util.List;
import java.util.Optional;

public interface AssignmentService {

    List<AssignmentResponse> getAllAssignments(Long versionId);

    Optional<AssignmentResponse> getAssignment(Long versionId, Long assignmentId);

    AssignmentResponse createAssignment(Long versionId, AssignmentRequest request);

    AssignmentResponse updateAssignment(Long versionId, Long assignmentId, AssignmentRequest request);

    void deleteAssignment(Long versionId, Long assignmentId);
}
