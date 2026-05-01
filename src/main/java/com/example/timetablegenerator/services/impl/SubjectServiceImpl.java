package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.SubjectMapper;
import com.example.timetablegenerator.mappers.TeacherMapper;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.SubjectService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
@Slf4j
public class SubjectServiceImpl implements SubjectService {

    private final SubjectRepository subjectRepository;
    private final MajorRepository majorRepository;
    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
    private final SubjectMapper subjectMapper;
    private final TeacherMapper teacherMapper;

    @Override
    public List<SubjectResponse> getAllSubjects() {
        return subjectRepository.findAll().stream()
                .map(subjectMapper::toResponse)
                .toList();
    }

    @Override
    public List<SubjectResponse> getSubjectsByFaculty(Long facultyId) {
        if (!facultyRepository.existsById(facultyId)) {
            throw new NotFoundException("Faculty not found with id: " + facultyId);
        }

        return subjectRepository.findByMajorDepartmentFacultyId(facultyId).stream()
                .map(subjectMapper::toResponse)
                .toList();
    }

    @Override
    public List<SubjectResponse> getSubjectsByDepartment(Long departmentId) {
        if (!departmentRepository.existsById(departmentId)) {
            throw new NotFoundException("Department not found with id: " + departmentId);
        }

        return subjectRepository.findByMajorDepartmentId(departmentId).stream()
                .map(subjectMapper::toResponse)
                .toList();
    }

    @Override
    public List<SubjectResponse> getSubjectsByMajor(Long majorId) {
        if (!majorRepository.existsById(majorId)) {
            throw new NotFoundException("Major not found with id: " + majorId);
        }

        return subjectRepository.findByMajorId(majorId).stream()
                .map(subjectMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<SubjectResponse> getSubjectById(Long subjectId) {
        return subjectRepository.findById(subjectId)
                .map(subjectMapper::toResponse);
    }

    @Override
    public Optional<SubjectResponse> getSubjectByCode(String code) {
        return subjectRepository.findByCode(code)
                .map(subjectMapper::toResponse);
    }

    @Transactional
    @Override
    public SubjectResponse createSubject(SubjectRequest request) {
        if (subjectRepository.existsByCode(request.code())) {
            throw new IllegalStateException("Subject with code '" + request.code() + "' already exists");
        }

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        Subject subject = subjectMapper.toEntity(request);
        subject.setMajor(major);

        Subject saved = subjectRepository.save(subject);
        log.info("Created subject '{}' for major {}", saved.getName(), major.getId());

        return subjectMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public SubjectResponse updateSubject(Long subjectId, SubjectRequest request) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + subjectId));

        Major major = majorRepository.findById(request.majorId())
                .orElseThrow(() -> new NotFoundException("Major not found with id: " + request.majorId()));

        subjectRepository.findByCode(request.code())
                .filter(existing -> !existing.getId().equals(subjectId))
                .ifPresent(existing -> {
                    throw new IllegalStateException("Subject with code '" + request.code() + "' already exists");
                });

        subjectMapper.updateEntityFromRequest(request, subject);
        subject.setMajor(major);

        Subject updated = subjectRepository.save(subject);
        log.info("Updated subject {} -> '{}'", subjectId, updated.getName());

        return subjectMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteSubject(Long subjectId, DeleteMode mode) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + subjectId));

        List<Assignment> assignments = new ArrayList<>(assignmentRepository.findBySubjectId(subjectId));
        List<Lesson> lessons = new ArrayList<>(lessonRepository.findBySubjectId(subjectId));

        switch (mode) {
            case SIMPLE -> {
                if (!assignments.isEmpty() || !lessons.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete subject with id " + subjectId +
                                    " because it is used in " + assignments.size() +
                                    " assignments and " + lessons.size() + " lessons"
                    );
                }
            }

            case DETACH -> {
                for (Assignment assignment : assignments) {
                    assignment.setSubject(null);
                }
                assignmentRepository.saveAll(assignments);

                for (Lesson lesson : lessons) {
                    lesson.setSubject(null);
                }
                lessonRepository.saveAll(lessons);
            }

            case WITH -> {
                lessonRepository.deleteAll(lessons);
                assignmentRepository.deleteAll(assignments);
            }
        }

        subject.getTeachers().clear();
        subject.getGroups().clear();

        subjectRepository.delete(subject);
        log.info("Deleted subject with id={} using mode={}", subjectId, mode);
    }

    @Override
    public List<TeacherResponse> getTeachersBySubject(Long subjectId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + subjectId));

        return subject.getTeachers().stream()
                .map(teacherMapper::toResponse)
                .toList();
    }
}