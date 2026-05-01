package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.MajorRequest;
import com.example.timetablegenerator.domain.dto.response.MajorResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.MajorMapper;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.MajorRepository;
import com.example.timetablegenerator.repositories.StudyGroupRepository;
import com.example.timetablegenerator.repositories.SubjectRepository;
import com.example.timetablegenerator.services.MajorService;
import com.example.timetablegenerator.services.StudyGroupService;
import com.example.timetablegenerator.services.SubjectService;
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
public class MajorServiceImpl implements MajorService {

    private final MajorRepository majorRepository;
    private final DepartmentRepository departmentRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final SubjectRepository subjectRepository;
    private final MajorMapper majorMapper;
    private final StudyGroupService studyGroupService;
    private final SubjectService subjectService;

    @Override
    public List<MajorResponse> getAllMajors() {
        return majorRepository.findAll()
                .stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public List<MajorResponse> getMajorsByDepartment(Long departmentId) {
        return majorRepository.findByDepartmentId(departmentId)
                .stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public List<MajorResponse> getMajorsByFaculty(Long facultyId) {
        return majorRepository.findByDepartment_Faculty_Id(facultyId)
                .stream()
                .map(majorMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<MajorResponse> getMajor(Long majorId) {
        return majorRepository.findById(majorId)
                .map(majorMapper::toResponse);
    }

    @Override
    @Transactional
    public MajorResponse createMajor(MajorRequest request) {
        String normalizedName = normalize(request.name());
        String normalizedShortName = normalizeShortName(request.shortName());

        Department department = departmentRepository.findById(request.departmentId())
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + request.departmentId()));

        majorRepository.findByNameIgnoreCaseAndDepartmentId(normalizedName, department.getId())
                .ifPresent(existing -> {
                    throw new IllegalStateException(
                            "Major with name '" + normalizedName + "' already exists in this department"
                    );
                });

        Major major = Major.builder()
                .name(normalizedName)
                .shortName(normalizedShortName)
                .degree(request.degree())
                .department(department)
                .build();

        Major saved = majorRepository.save(major);
        log.info("Created major with id={}", saved.getId());

        return majorMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public MajorResponse updateMajor(Long majorId, MajorRequest request) {
        Major major = majorRepository.findById(majorId)
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + majorId));

        String normalizedName = normalize(request.name());
        String normalizedShortName = normalizeShortName(request.shortName());

        Department department = departmentRepository.findById(request.departmentId())
                .orElseThrow(() -> new NotFoundException("Department not found with id: " + request.departmentId()));

        majorRepository.findByNameIgnoreCaseAndDepartmentId(normalizedName, department.getId())
                .filter(existing -> !existing.getId().equals(majorId))
                .ifPresent(existing -> {
                    throw new IllegalStateException(
                            "Major with name '" + normalizedName + "' already exists in this department"
                    );
                });

        major.setName(normalizedName);
        major.setShortName(normalizedShortName);
        major.setDegree(request.degree());
        major.setDepartment(department);

        Major updated = majorRepository.save(major);
        log.info("Updated major with id={}", updated.getId());

        return majorMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteMajor(Long majorId, DeleteMode mode) {
        Major major = majorRepository.findById(majorId)
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + majorId));

        List<StudyGroup> groups = new ArrayList<>(studyGroupRepository.findByMajorId(majorId));
        List<Subject> subjects = new ArrayList<>(subjectRepository.findByMajorId(majorId));

        switch (mode) {
            case SIMPLE -> {
                if (!groups.isEmpty() || !subjects.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete major with id " + majorId +
                                    " because it has " + groups.size() + " associated groups and " +
                                    subjects.size() + " associated subjects"
                    );
                }
            }

            case DETACH -> {
                for (StudyGroup group : groups) {
                    group.setMajor(null);
                }

                for (Subject subject : subjects) {
                    subject.setMajor(null);
                }

                studyGroupRepository.saveAll(groups);
                subjectRepository.saveAll(subjects);
            }

            case WITH -> {
                for (Subject subject : subjects) {
                    subjectService.deleteSubject(subject.getId(), DeleteMode.WITH);
                }

                for (StudyGroup group : groups) {
                    studyGroupService.deleteGroup(group.getId(), DeleteMode.WITH);
                }
            }
        }

        majorRepository.delete(major);
        log.info("Deleted major with id={} using mode={}", majorId, mode);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Major name must not be blank");
        }
        return value.trim();
    }

    private String normalizeShortName(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Major short name must not be blank");
        }
        return value.trim();
    }
}