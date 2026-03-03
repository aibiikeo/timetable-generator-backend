package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.FacultyCreateRequest;
import com.example.timetablegenerator.domain.dto.request.FacultyUpdateRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;

import java.util.List;
import java.util.Optional;

public interface FacultyService {

    List<FacultyResponse> getAllFaculties();

    Optional<FacultyResponse> getFaculty(Long facultyId);

    FacultyResponse createFaculty(FacultyCreateRequest request);

    FacultyResponse updateFaculty(Long facultyId, FacultyUpdateRequest request);

    void deleteFaculty(Long facultyId, DeleteMode mode);
}