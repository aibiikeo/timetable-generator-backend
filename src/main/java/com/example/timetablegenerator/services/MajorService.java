package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.MajorRequest;
import com.example.timetablegenerator.domain.dto.response.MajorResponse;

import java.util.List;
import java.util.Optional;

public interface MajorService {

    List<MajorResponse> getAllMajors();

    List<MajorResponse> getMajorsByDepartment(Long departmentId);

    List<MajorResponse> getMajorsByFaculty(Long facultyId);

    Optional<MajorResponse> getMajor(Long majorId);

    MajorResponse createMajor(MajorRequest request);

    MajorResponse updateMajor(Long majorId, MajorRequest request);

    void deleteMajor(Long majorId);
}