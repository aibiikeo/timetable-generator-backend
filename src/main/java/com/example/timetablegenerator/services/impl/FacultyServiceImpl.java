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
import com.example.timetablegenerator.services.FacultyService;
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
@Transactional(readOnly = true)
@Slf4j
public class FacultyServiceImpl implements FacultyService {

    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final FacultyMapper facultyMapper;

    @Override
    public List<FacultyResponse> getAllFaculties() {
        return facultyRepository.findAll().stream()
                .map(facultyMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<FacultyResponse> getFaculty(Long facultyId) {
        return facultyRepository.findById(facultyId)
                .map(facultyMapper::toResponse);
    }

    @Transactional
    @Override
    public FacultyResponse createFaculty(FacultyRequest request) {
        Faculty faculty = facultyMapper.toEntity(request);
        Faculty saved = facultyRepository.save(faculty);
        log.info("Created faculty '{}'", saved.getName());
        return facultyMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public FacultyResponse updateFaculty(Long facultyId, FacultyRequest request) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        facultyMapper.updateEntityFromRequest(request, faculty);

        Faculty updated = facultyRepository.save(faculty);
        log.info("Updated faculty {} -> '{}'", facultyId, updated.getName());
        return facultyMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteFaculty(Long facultyId, DeleteMode mode) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        List<Department> departments = departmentRepository.findByFacultyId(facultyId);

        if (mode == DeleteMode.SIMPLE && !departments.isEmpty()) {
            throw new IllegalStateException(
                    "Cannot delete faculty with id " + facultyId +
                            " because it has " + departments.size() + " associated departments"
            );
        }

        if (mode == DeleteMode.DETACH || mode == DeleteMode.WITH) {
            throw new IllegalStateException(
                    "Faculty deletion with mode " + mode +
                            " is not supported until cascading delete for departments/majors/groups is explicitly implemented"
            );
        }

        facultyRepository.delete(faculty);
        log.info("Deleted faculty {} (simple mode)", facultyId);
    }
}