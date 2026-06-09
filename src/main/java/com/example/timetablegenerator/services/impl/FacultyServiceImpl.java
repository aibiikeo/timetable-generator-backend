package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.FacultyRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.FacultyMapper;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.services.DepartmentService;
import com.example.timetablegenerator.services.FacultyService;
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
public class FacultyServiceImpl implements FacultyService {

    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final FacultyMapper facultyMapper;
    private final DepartmentService departmentService;

    @Override
    public List<FacultyResponse> getAllFaculties() {
        return facultyRepository.findAll()
                .stream()
                .map(facultyMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<FacultyResponse> getFaculty(Long facultyId) {
        return facultyRepository.findById(facultyId)
                .map(facultyMapper::toResponse);
    }

    @Override
    @Transactional
    public FacultyResponse createFaculty(FacultyRequest request) {
        String normalizedName = normalize(request.name());

        if (facultyRepository.existsByNameIgnoreCase(normalizedName)) {
            throw new IllegalStateException("Faculty with name '" + normalizedName + "' already exists");
        }

        Faculty faculty = Faculty.builder()
                .name(normalizedName)
                .build();

        Faculty saved = facultyRepository.save(faculty);
        log.info("app | Created faculty with id={}", saved.getId());

        return facultyMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public FacultyResponse updateFaculty(Long facultyId, FacultyRequest request) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        String normalizedName = normalize(request.name());

        facultyRepository.findByNameIgnoreCase(normalizedName)
                .filter(existing -> !existing.getId().equals(facultyId))
                .ifPresent(existing -> {
                    throw new IllegalStateException("Faculty with name '" + normalizedName + "' already exists");
                });

        faculty.setName(normalizedName);

        Faculty updated = facultyRepository.save(faculty);
        log.info("app | Updated faculty with id={}", updated.getId());

        return facultyMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteFaculty(Long facultyId, DeleteMode mode) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        List<Department> departments = new ArrayList<>(departmentRepository.findByFacultyId(facultyId));

        switch (mode) {
            case SIMPLE -> {
                if (!departments.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete faculty with id " + facultyId +
                                    " because it has " + departments.size() + " associated departments"
                    );
                }
            }

            case DETACH -> {
                for (Department department : departments) {
                    department.setFaculty(null);
                }
                departmentRepository.saveAll(departments);
            }

            case WITH -> {
                for (Department department : departments) {
                    departmentService.deleteDepartment(department.getId(), DeleteMode.WITH);
                }
            }
        }

        facultyRepository.delete(faculty);
        log.info("app | Deleted faculty with id={} using mode={}", facultyId, mode);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Faculty name must not be blank");
        }
        return value.trim();
    }
}