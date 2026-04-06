package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.FacultyRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.FacultyMapper;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.FacultyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Slf4j
@Transactional(readOnly = true)
public class FacultyServiceImpl implements FacultyService {

    private final FacultyRepository facultyRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final SubjectRepository subjectRepository;
    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
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
        return facultyMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public FacultyResponse updateFaculty(Long facultyId, FacultyRequest request) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        facultyMapper.updateEntityFromRequest(request, faculty);
        Faculty updated = facultyRepository.save(faculty);
        return facultyMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteFaculty(Long facultyId, DeleteMode mode) {
        Faculty faculty = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

        List<StudyGroup> groups = studyGroupRepository.findByMajorDepartmentFacultyId(facultyId);
        List<Subject> subjects = subjectRepository.findByMajorDepartmentFacultyId(facultyId);

        if (mode == DeleteMode.SIMPLE && (!groups.isEmpty() || !subjects.isEmpty())) {
            log.info("Auto-switching SIMPLE to DETACH for faculty {} because associated groups or subjects exist", facultyId);
            mode = DeleteMode.DETACH;
        }

        switch (mode) {
            case SIMPLE -> {
                if (!groups.isEmpty() || !subjects.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete faculty with id " + facultyId + " because it has " +
                                    groups.size() + " associated study groups and " +
                                    subjects.size() + " associated subjects. Use DETACH or WITH_GROUPS mode."
                    );
                }
                facultyRepository.delete(faculty);
                log.info("Deleted faculty {} (simple mode)", facultyId);
            }

            case DETACH -> {
                // Обработка групп
                if (!groups.isEmpty()) {
                    for (StudyGroup group : groups) {
                        group.setMajor(null);
                        studyGroupRepository.save(group);
                    }
                    log.info("Detached {} groups from faculty {} (detach mode)", groups.size(), facultyId);
                    log.warn("{} groups now have no faculty assigned. Group IDs: {}",
                            groups.size(),
                            groups.stream().map(g -> String.valueOf(g.getId())).toList());
                }

                // Обработка предметов
                if (!subjects.isEmpty()) {
                    for (Subject subject : subjects) {
                        subject.setMajor(null);
                        subjectRepository.save(subject);
                    }
                    log.info("Detached {} subjects from faculty {} (detach mode)", subjects.size(), facultyId);
                    log.warn("{} subjects now have no faculty assigned. Subject IDs: {}",
                            subjects.size(),
                            subjects.stream().map(s -> String.valueOf(s.getId())).toList());
                }

                facultyRepository.delete(faculty);
                log.info("Deleted faculty {} (detach mode)", facultyId);
            }

            case WITH -> {
                // Обработка групп
                if (!groups.isEmpty()) {
                    // Удаляем группы из всех связанных assignments
                    for (StudyGroup group : groups) {
                        // Удаляем группы из всех связанных assignments
                        assignmentRepository.removeGroupFromAllAssignments(group.getId());
                        log.debug("Removed group {} from all assignments", group.getId());

                        // Разрываем связи с уроками
                        List<Lesson> lessons = lessonRepository.findByGroupId(group.getId());
                        for (Lesson lesson : lessons) {
                            lesson.getGroups().remove(group);
                            lessonRepository.save(lesson);
                        }

                        log.debug("Removed group {} from all assignments and lessons", group.getId());
                    }


                    // Теперь удаляем группы
                    studyGroupRepository.deleteAll(groups);
                    log.info("Deleted {} groups from faculty {} (with-groups mode)", groups.size(), facultyId);
                }

                // Обработка предметов
                if (!subjects.isEmpty()) {
                    // Перемещаем предметы в временный факультет или оставляем без факультета
                    // (зависит от бизнес-логики, показываем warning)
                    log.warn("{} subjects are still associated with faculty {} and will be left without faculty after deletion. Subject IDs: {}",
                            subjects.size(), facultyId,
                            subjects.stream().map(s -> String.valueOf(s.getId())).toList());

                    // В режиме WITH_GROUPS можно либо удалить предметы, либо отвязать
                    // Пока отвязываем, как в режиме DETACH
                    for (Subject subject : subjects) {
                        subject.setMajor(null);
                        subjectRepository.save(subject);
                    }
                    log.info("Detached {} subjects from faculty {} (with-groups mode)", subjects.size(), facultyId);
                }

                facultyRepository.delete(faculty);
                log.info("Deleted faculty {} (with-groups mode)", facultyId);
            }
        }
    }
}