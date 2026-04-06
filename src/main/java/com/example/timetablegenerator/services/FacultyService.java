package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.FacultyRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;

import java.util.List;
import java.util.Optional;

public interface FacultyService {

    List<FacultyResponse> getAllFaculties();

    Optional<FacultyResponse> getFaculty(Long facultyId);

    FacultyResponse createFaculty(FacultyRequest request);

    FacultyResponse updateFaculty(Long facultyId, FacultyRequest request);

    void deleteFaculty(Long facultyId, DeleteMode mode);
}