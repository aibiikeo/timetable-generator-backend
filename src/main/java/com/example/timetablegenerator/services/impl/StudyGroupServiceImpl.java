package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.StudyGroupMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.MajorRepository;
import com.example.timetablegenerator.repositories.StudyGroupRepository;
import com.example.timetablegenerator.services.StudyGroupService;
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
public class StudyGroupServiceImpl implements StudyGroupService {

    private final StudyGroupRepository groupRepository;
    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final MajorRepository majorRepository;
    private final LessonRepository lessonRepository;
    private final AssignmentRepository assignmentRepository;
    private final StudyGroupMapper groupMapper;

    @Override
    public List<StudyGroupResponse> getAllGroups() {
        return groupRepository.findAll().stream()
                .map(groupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByFaculty(Long facultyId) {
        if (!facultyRepository.existsById(facultyId)) {
            throw new NotFoundException("Faculty not found with id: " + facultyId);
        }

        return groupRepository.findByMajorDepartmentFacultyId(facultyId).stream()
                .map(groupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByDepartment(Long departmentId) {
        if (!departmentRepository.existsById(departmentId)) {
            throw new NotFoundException("Department not found with id: " + departmentId);
        }

        return groupRepository.findByMajorDepartmentId(departmentId).stream()
                .map(groupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByMajor(Long majorId) {
        if (!majorRepository.existsById(majorId)) {
            throw new NotFoundException("Major not found with id: " + majorId);
        }

        return groupRepository.findByMajorId(majorId).stream()
                .map(groupMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<StudyGroupResponse> getGroup(Long groupId) {
        return groupRepository.findById(groupId)
                .map(groupMapper::toResponse);
    }

    @Transactional
    @Override
    public StudyGroupResponse createGroup(StudyGroupRequest request) {
        if (groupRepository.existsByName(request.name())) {
            throw new IllegalStateException("Study group with name '" + request.name() + "' already exists");
        }

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        StudyGroup group = groupMapper.toEntity(request);
        group.setMajor(major);

        StudyGroup saved = groupRepository.save(group);
        log.info("Created study group '{}' for major {}", saved.getName(), major.getId());

        return groupMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public StudyGroupResponse updateGroup(Long groupId, StudyGroupRequest request) {
        StudyGroup group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Study group not found with id: " + groupId));

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        groupRepository.findByName(request.name())
                .filter(existing -> !existing.getId().equals(groupId))
                .ifPresent(existing -> {
                    throw new IllegalStateException("Study group with name '" + request.name() + "' already exists");
                });

        groupMapper.updateEntityFromRequest(request, group);
        group.setMajor(major);

        StudyGroup updated = groupRepository.save(group);
        log.info("Updated study group {} -> '{}'", groupId, updated.getName());

        return groupMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteGroup(Long groupId) {
        StudyGroup group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Study group not found with id: " + groupId));

        // 1. Удаляем группу из assignments
        List<Assignment> assignments = assignmentRepository.findByGroupId(groupId);
        for (Assignment assignment : assignments) {
            assignment.getGroups().remove(group);
            assignmentRepository.save(assignment);
        }

        // 2. Удаляем группу из lessons
        List<Lesson> lessons = lessonRepository.findByGroupId(groupId);
        for (Lesson lesson : lessons) {
            lesson.getGroups().remove(group);
            lessonRepository.save(lesson);
        }

        // 3. Удаляем группу из subjects
        group.getSubjects().forEach(subject -> subject.getGroups().remove(group));
        group.getSubjects().clear();

        // 4. Удаляем саму группу
        groupRepository.delete(group);
        log.info("Deleted study group {}", groupId);
    }
}