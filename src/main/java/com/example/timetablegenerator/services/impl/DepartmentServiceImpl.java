package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.DepartmentRequest;
import com.example.timetablegenerator.domain.dto.response.DepartmentResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.DepartmentMapper;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.repositories.MajorRepository;
import com.example.timetablegenerator.services.DepartmentService;
import com.example.timetablegenerator.services.MajorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;
    private final FacultyRepository facultyRepository;
    private final MajorRepository majorRepository;
    private final DepartmentMapper departmentMapper;
    private final MajorService majorService;

    @Override
    public List<DepartmentResponse> getAllDepartments() {
        return departmentRepository.findAll()
                .stream()
                .map(departmentMapper::toResponse)
                .toList();
    }

    @Override
    public List<DepartmentResponse> getDepartmentsByFaculty(Long facultyId) {
        return departmentRepository.findByFacultyId(facultyId)
                .stream()
                .map(departmentMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<DepartmentResponse> getDepartment(Long departmentId) {
        return departmentRepository.findById(departmentId)
                .map(departmentMapper::toResponse);
    }

    @Override
    @Transactional
    public DepartmentResponse createDepartment(DepartmentRequest request) {
        String normalizedName = normalize(request.name());

        Faculty faculty = facultyRepository.findById(request.facultyId())
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));

        departmentRepository.findByNameIgnoreCaseAndFacultyId(normalizedName, faculty.getId())
                .ifPresent(existing -> {
                    throw new IllegalStateException(
                            "Department with name '" + normalizedName + "' already exists in this faculty"
                    );
                });

        Department department = Department.builder()
                .name(normalizedName)
                .faculty(faculty)
                .build();

        Department saved = departmentRepository.save(department);
        log.info("Created department with id={}", saved.getId());

        return departmentMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public DepartmentResponse updateDepartment(Long departmentId, DepartmentRequest request) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + departmentId));

        String normalizedName = normalize(request.name());

        Faculty faculty = facultyRepository.findById(request.facultyId())
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));

        departmentRepository.findByNameIgnoreCaseAndFacultyId(normalizedName, faculty.getId())
                .filter(existing -> !existing.getId().equals(departmentId))
                .ifPresent(existing -> {
                    throw new IllegalStateException(
                            "Department with name '" + normalizedName + "' already exists in this faculty"
                    );
                });

        department.setName(normalizedName);
        department.setFaculty(faculty);

        Department updated = departmentRepository.save(department);
        log.info("Updated department with id={}", updated.getId());

        return departmentMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteDepartment(Long departmentId, DeleteMode mode) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + departmentId));

        List<Major> majors = new ArrayList<>(majorRepository.findByDepartmentId(departmentId));

        switch (mode) {
            case SIMPLE -> {
                if (!majors.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete department with id " + departmentId +
                                    " because it has " + majors.size() + " associated majors"
                    );
                }
            }

            case DETACH -> {
                for (Major major : majors) {
                    major.setDepartment(null);
                }
                majorRepository.saveAll(majors);
            }

            case WITH -> {
                for (Major major : majors) {
                    majorService.deleteMajor(major.getId(), DeleteMode.WITH);
                }
            }
        }

        departmentRepository.delete(department);
        log.info("Deleted department with id={} using mode={}", departmentId, mode);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Department name must not be blank");
        }
        return value.trim();
    }
}