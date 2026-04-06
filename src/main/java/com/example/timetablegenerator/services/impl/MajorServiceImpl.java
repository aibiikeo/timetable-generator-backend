package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.MajorRequest;
import com.example.timetablegenerator.domain.dto.response.MajorResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.MajorMapper;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.MajorRepository;
import com.example.timetablegenerator.repositories.StudyGroupRepository;
import com.example.timetablegenerator.repositories.SubjectRepository;
import com.example.timetablegenerator.services.MajorService;
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
public class MajorServiceImpl implements MajorService {

    private final MajorRepository majorRepository;
    private final DepartmentRepository departmentRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final SubjectRepository subjectRepository;
    private final MajorMapper majorMapper;

    @Override
    public List<MajorResponse> getAllMajors() {
        return majorRepository.findAll().stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public List<MajorResponse> getMajorsByDepartment(Long departmentId) {
        if (!departmentRepository.existsById(departmentId)) {
            throw new NotFoundException("Department not found with id: " + departmentId);
        }

        return majorRepository.findByDepartmentId(departmentId).stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public List<MajorResponse> getMajorsByFaculty(Long facultyId) {
        return majorRepository.findByDepartmentFacultyId(facultyId).stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<MajorResponse> getMajor(Long majorId) {
        return majorRepository.findById(majorId)
                .map(majorMapper::toResponse);
    }

    @Transactional
    @Override
    public MajorResponse createMajor(MajorRequest request) {
        Department department = departmentRepository.findById(request.departmentId())
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + request.departmentId()));

        Major major = majorMapper.toEntity(request);
        major.setDepartment(department);

        Major saved = majorRepository.save(major);
        log.info("Created major '{}' in department {}", saved.getName(), department.getId());

        return majorMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public MajorResponse updateMajor(Long majorId, MajorRequest request) {
        Major major = majorRepository.findById(majorId)
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + majorId));

        Department department = departmentRepository.findById(request.departmentId())
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + request.departmentId()));

        majorMapper.updateEntityFromRequest(request, major);
        major.setDepartment(department);

        Major updated = majorRepository.save(major);
        log.info("Updated major {} -> '{}'", majorId, updated.getName());

        return majorMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteMajor(Long majorId) {
        Major major = majorRepository.findById(majorId)
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + majorId));

        var groups = studyGroupRepository.findByMajorId(majorId);
        var subjects = subjectRepository.findByMajorId(majorId);

        if (!groups.isEmpty() || !subjects.isEmpty()) {
            throw new IllegalStateException(
                    "Cannot delete major with id " + majorId +
                            " because it has " + groups.size() + " associated study groups and " +
                            subjects.size() + " associated subjects"
            );
        }

        majorRepository.delete(major);
        log.info("Deleted major {}", majorId);
    }
}