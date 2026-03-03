package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.SubjectMapper;
import com.example.timetablegenerator.mappers.TeacherMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.SubjectRepository;
import com.example.timetablegenerator.services.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
public class SubjectServiceImpl implements SubjectService {

    private final SubjectRepository subjectRepository;
    private final FacultyRepository facultyRepository;
    private final SubjectMapper subjectMapper;
    private final TeacherMapper teacherMapper;
    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;

    @Override
    public List<SubjectResponse> getAllSubjects() {
        return subjectRepository.findAll().stream()
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
        Subject subject = subjectMapper.toEntity(request);

        var faculty = facultyRepository.findById(request.facultyId())
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));

        subject.setFaculty(faculty);

        Subject saved = subjectRepository.save(subject);
        return subjectMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public SubjectResponse updateSubject(Long subjectId, SubjectRequest request) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + subjectId));

        subjectMapper.updateEntityFromRequest(request, subject);

        // Если в запросе пришёл новый facultyId — обновляем связь
        if (request.facultyId() != null) {
            var faculty = facultyRepository.findById(request.facultyId())
                    .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));
            subject.setFaculty(faculty);
        }

        Subject updated = subjectRepository.save(subject);
        return subjectMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteSubject(Long subjectId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + subjectId));

        List<Assignment> assignments = assignmentRepository.findBySubjectId(subjectId);
        for (Assignment assignment : assignments) {
            assignment.setSubject(null);
        }

        List<Lesson> lessons = lessonRepository.findBySubjectId(subjectId);
        for (Lesson lesson : lessons) {
            lesson.setSubject(null);
        }

        subjectRepository.delete(subject);
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