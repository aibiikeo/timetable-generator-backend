package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TeacherRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Teacher;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.AssignmentMapper;
import com.example.timetablegenerator.mappers.TeacherMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.TeacherRepository;
import com.example.timetablegenerator.services.TeacherService;
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
public class TeacherServiceImpl implements TeacherService {

    private final TeacherRepository teacherRepository;
    private final TeacherMapper teacherMapper;
    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
    private final AssignmentMapper assignmentMapper;

    @Override
    public List<TeacherResponse> getAllTeachers() {
        return teacherRepository.findAll().stream()
                .map(teacherMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<TeacherResponse> getTeacher(Long teacherId) {
        return teacherRepository.findById(teacherId)
                .map(teacherMapper::toResponse);
    }

    @Transactional
    @Override
    public TeacherResponse createTeacher(TeacherRequest request) {
        Teacher teacher = teacherMapper.toEntity(request);
        Teacher saved = teacherRepository.save(teacher);
        return teacherMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public TeacherResponse updateTeacher(Long teacherId, TeacherRequest request) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new NotFoundException("Teacher not found with id: " + teacherId));

        teacherMapper.updateEntityFromRequest(request, teacher);

        Teacher updated = teacherRepository.save(teacher);
        return teacherMapper.toResponse(updated);
    }

    @Override
    public List<AssignmentResponse> getAssignmentsByTeacherId(Long teacherId) {
        if (!teacherRepository.existsById(teacherId)) {
            throw new NotFoundException("Teacher not found with id: " + teacherId);
        }
        List<Assignment> assignments = assignmentRepository.findByTeacherId(teacherId);
        return assignments.stream()
                .map(assignmentMapper::toResponse)
                .toList();
    }

    @Transactional
    @Override
    public void deleteTeacher(Long teacherId, DeleteMode mode) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new NotFoundException("Teacher not found with id: " + teacherId));

        List<Assignment> assignments = assignmentRepository.findByTeacherId(teacherId);

        if (mode == DeleteMode.SIMPLE && !assignments.isEmpty()) {
            log.info("Auto-switching SIMPLE to DETACH for teacher {} because assignments exist", teacherId);
            mode = DeleteMode.DETACH;
        }

        switch (mode) {
            case SIMPLE -> {
                if (!assignments.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete teacher with id " + teacherId + " because it has " +
                                    assignments.size() + " associated assignments. Use DETACH or WITH mode."
                    );
                }
                teacherRepository.delete(teacher);
            }

            case DETACH -> {
                for (Assignment assignment : assignments) {
                    assignment.setTeacher(null);
                    assignmentRepository.save(assignment);
                }
                lessonRepository.detachTeacher(teacherId);
                teacherRepository.delete(teacher);
            }

            case WITH -> {
                lessonRepository.detachTeacher(teacherId);

                if (!assignments.isEmpty()) {
                    List<Long> assignmentIds = assignments.stream().map(Assignment::getId).toList();
                    lessonRepository.detachAssignments(assignmentIds);
                    assignmentRepository.deleteAll(assignments);
                }

                teacherRepository.delete(teacher);
            }
        }
    }
}