package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
import com.example.timetablegenerator.domain.entities.*;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.StudyGroupMapper;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.StudyGroupService;
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
public class StudyGroupServiceImpl implements StudyGroupService {

    private final StudyGroupRepository studyGroupRepository;
    private final MajorRepository majorRepository;
    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
    private final StudyGroupMapper studyGroupMapper;
    private final LunchRepository lunchRepository;
    private final SubjectRepository subjectRepository;

    @Override
    public List<StudyGroupResponse> getAllGroups() {
        return studyGroupRepository.findAll()
                .stream()
                .map(studyGroupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByFaculty(Long facultyId) {
        return studyGroupRepository.findByMajorDepartmentFacultyId(facultyId)
                .stream()
                .map(studyGroupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByDepartment(Long departmentId) {
        return studyGroupRepository.findByMajorDepartmentId(departmentId)
                .stream()
                .map(studyGroupMapper::toResponse)
                .toList();
    }

    @Override
    public List<StudyGroupResponse> getGroupsByMajor(Long majorId) {
        return studyGroupRepository.findByMajorId(majorId)
                .stream()
                .map(studyGroupMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<StudyGroupResponse> getGroup(Long groupId) {
        return studyGroupRepository.findById(groupId)
                .map(studyGroupMapper::toResponse);
    }

    @Override
    @Transactional
    public StudyGroupResponse createGroup(StudyGroupRequest request) {
        String normalizedName = normalize(request.name());

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        if (studyGroupRepository.existsByName(normalizedName)) {
            throw new IllegalStateException("Study group with name '" + normalizedName + "' already exists");
        }

        StudyGroup group = StudyGroup.builder()
                .name(normalizedName)
                .major(major)
                .degree(request.degree())
                .course(request.course())
                .studentCount(request.studentCount())
                .build();

        StudyGroup saved = studyGroupRepository.save(group);
        log.info("app | Created study group with id={}", saved.getId());

        return studyGroupMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public StudyGroupResponse updateGroup(Long groupId, StudyGroupRequest request) {
        StudyGroup group = studyGroupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Study group not found with id: " + groupId));

        String normalizedName = normalize(request.name());

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        studyGroupRepository.findByName(normalizedName)
                .filter(existing -> !existing.getId().equals(groupId))
                .ifPresent(existing -> {
                    throw new IllegalStateException("Study group with name '" + normalizedName + "' already exists");
                });

        group.setName(normalizedName);
        group.setMajor(major);
        group.setDegree(request.degree());
        group.setCourse(request.course());
        group.setStudentCount(request.studentCount());

        StudyGroup updated = studyGroupRepository.save(group);
        log.info("app | Updated study group with id={}", updated.getId());

        return studyGroupMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteGroup(Long groupId, DeleteMode mode) {
        StudyGroup group = studyGroupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Study group not found with id: " + groupId));

        List<Assignment> assignments = new ArrayList<>(assignmentRepository.findByGroupId(groupId));
        List<Lesson> lessons = new ArrayList<>(lessonRepository.findByGroupId(groupId));
        List<Subject> subjects = new ArrayList<>(group.getSubjects());

        List<Lunch> lunches = lunchRepository.findAll()
                .stream()
                .filter(lunch -> lunch.getGroupId() != null && lunch.getGroupId().equals(groupId))
                .toList();

        switch (mode) {
            case SIMPLE -> {
                if (!assignments.isEmpty() || !lessons.isEmpty() || !subjects.isEmpty() || !lunches.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete study group with id " + groupId +
                                    " because it is used in assignments, lessons, subjects or lunch settings"
                    );
                }
            }

            case DETACH -> {
                for (Assignment assignment : assignments) {
                    assignment.getGroups().removeIf(g -> g.getId().equals(groupId));
                }
                assignmentRepository.saveAll(assignments);

                for (Lesson lesson : lessons) {
                    lesson.getGroups().removeIf(g -> g.getId().equals(groupId));
                }
                lessonRepository.saveAll(lessons);

                for (Subject subject : subjects) {
                    subject.getGroups().removeIf(g -> g.getId().equals(groupId));
                }
                subjectRepository.saveAll(subjects);

                lunchRepository.deleteAll(lunches);
            }

            case WITH -> {
                for (Lesson lesson : lessons) {
                    if (lesson.getGroups().size() <= 1) {
                        lessonRepository.delete(lesson);
                    } else {
                        lesson.getGroups().removeIf(g -> g.getId().equals(groupId));
                        lessonRepository.save(lesson);
                    }
                }

                for (Assignment assignment : assignments) {
                    if (assignment.getGroups().size() <= 1) {
                        assignmentRepository.delete(assignment);
                    } else {
                        assignment.getGroups().removeIf(g -> g.getId().equals(groupId));
                        assignmentRepository.save(assignment);
                    }
                }

                for (Subject subject : subjects) {
                    subject.getGroups().removeIf(g -> g.getId().equals(groupId));
                }
                subjectRepository.saveAll(subjects);

                lunchRepository.deleteAll(lunches);
            }
        }

        studyGroupRepository.delete(group);
        log.info("app | Deleted study group with id={} using mode={}", groupId, mode);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Study group name must not be blank");
        }
        return value.trim();
    }
}
