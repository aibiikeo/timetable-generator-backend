package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.DepartmentRequest;
import com.example.timetablegenerator.domain.dto.response.DepartmentResponse;

import java.util.List;
import java.util.Optional;

public interface DepartmentService {

    List<DepartmentResponse> getAllDepartments();

    List<DepartmentResponse> getDepartmentsByFaculty(Long facultyId);

    Optional<DepartmentResponse> getDepartment(Long departmentId);

    DepartmentResponse createDepartment(DepartmentRequest request);

    DepartmentResponse updateDepartment(Long departmentId, DepartmentRequest request);

    void deleteDepartment(Long departmentId, DeleteMode mode);
}