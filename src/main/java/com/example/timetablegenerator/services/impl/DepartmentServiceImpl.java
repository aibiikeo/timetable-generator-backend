package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DepartmentRequest;
import com.example.timetablegenerator.domain.dto.response.DepartmentResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.DepartmentMapper;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.repositories.MajorRepository;
import com.example.timetablegenerator.services.DepartmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Slf4j
@Transactional(readOnly = true)
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;
    private final FacultyRepository facultyRepository;
    private final MajorRepository majorRepository;
    private final DepartmentMapper departmentMapper;

    @Override
    public List<DepartmentResponse> getAllDepartments() {
        return departmentRepository.findAll().stream()
                .map(departmentMapper::toResponse)
                .toList();
    }

    @Override
    public List<DepartmentResponse> getDepartmentsByFaculty(Long facultyId) {
        if (!facultyRepository.existsById(facultyId)) {
            throw new NotFoundException("Faculty not found with id: " + facultyId);
        }

        return departmentRepository.findByFacultyId(facultyId).stream()
                .map(departmentMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<DepartmentResponse> getDepartment(Long departmentId) {
        return departmentRepository.findById(departmentId)
                .map(departmentMapper::toResponse);
    }

    @Transactional
    @Override
    public DepartmentResponse createDepartment(DepartmentRequest request) {
        Faculty faculty = facultyRepository.findById(request.facultyId())
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));

        Department department = departmentMapper.toEntity(request);
        department.setFaculty(faculty);

        Department saved = departmentRepository.save(department);
        log.info("Created department '{}' for faculty {}", saved.getName(), faculty.getId());

        return departmentMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public DepartmentResponse updateDepartment(Long departmentId, DepartmentRequest request) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + departmentId));

        Faculty faculty = facultyRepository.findById(request.facultyId())
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));

        departmentMapper.updateEntityFromRequest(request, department);
        department.setFaculty(faculty);

        Department updated = departmentRepository.save(department);
        log.info("Updated department {} -> '{}'", departmentId, updated.getName());

        return departmentMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteDepartment(Long departmentId) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + departmentId));

        var majors = majorRepository.findByDepartmentId(departmentId);
        if (!majors.isEmpty()) {
            throw new IllegalStateException(
                    "Cannot delete department with id " + departmentId +
                            " because it has " + majors.size() + " associated majors"
            );
        }

        departmentRepository.delete(department);
        log.info("Deleted department {}", departmentId);
    }
}