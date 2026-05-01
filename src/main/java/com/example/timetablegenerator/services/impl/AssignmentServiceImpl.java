package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.*;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.AssignmentMapper;
import com.example.timetablegenerator.repositories.*;
import com.example.timetablegenerator.services.AssignmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
public class AssignmentServiceImpl implements AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final LessonRepository lessonRepository;
    private final TimetableRepository timetableRepository;
    private final SubjectRepository subjectRepository;
    private final TeacherRepository teacherRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final AssignmentMapper assignmentMapper;

    @Override
    public List<AssignmentResponse> getAllAssignments(Long timetableId) {
        log.debug("Fetching all assignments for timetableId={}", timetableId);

        List<AssignmentResponse> responses = assignmentRepository.findByTimetableId(timetableId).stream()
                .map(assignmentMapper::toResponse)
                .toList();

        log.debug("Fetched {} assignments for timetableId={}", responses.size(), timetableId);
        return responses;
    }

    @Override
    public Optional<AssignmentResponse> getAssignment(Long timetableId, Long assignmentId) {
        log.debug("Fetching assignment id={} for timetableId={}", assignmentId, timetableId);

        Optional<AssignmentResponse> response = assignmentRepository
                .findByIdAndTimetableId(assignmentId, timetableId)
                .map(assignmentMapper::toResponse);

        if (response.isPresent()) {
            log.debug("Assignment found: id={} in timetableId={}", assignmentId, timetableId);
        } else {
            log.debug("Assignment not found: id={} in timetableId={}", assignmentId, timetableId);
        }

        return response;
    }

    @Transactional
    @Override
    public AssignmentResponse createAssignment(Long timetableId, AssignmentRequest request) {
        log.info(
                "Creating assignment for timetableId={}, subjectId={}, teacherId={}, groupIds={}",
                timetableId,
                request.subjectId(),
                request.teacherId(),
                request.groupIds()
        );

        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> {
                    log.warn("Timetable not found while creating assignment. timetableId={}", timetableId);
                    return new NotFoundException("Timetable not found with id: " + timetableId);
                });

        Subject subject = subjectRepository.findById(request.subjectId())
                .orElseThrow(() -> {
                    log.warn("Subject not found while creating assignment. subjectId={}", request.subjectId());
                    return new NotFoundException("Subject not found with id: " + request.subjectId());
                });

        Teacher teacher = teacherRepository.findById(request.teacherId())
                .orElseThrow(() -> {
                    log.warn("Teacher not found while creating assignment. teacherId={}", request.teacherId());
                    return new NotFoundException("Teacher not found with id: " + request.teacherId());
                });

        Set<StudyGroup> groups = loadGroups(request.groupIds());

        validateAssignmentRequest(request, groups);

        Assignment assignment = assignmentMapper.toEntity(request);
        assignment.setTimetable(timetable);
        assignment.setSubject(subject);
        assignment.setTeacher(teacher);
        assignment.setGroups(groups);

        Assignment saved = assignmentRepository.save(assignment);

        log.info(
                "Assignment created successfully. assignmentId={}, timetableId={}, subjectId={}, teacherId={}, groupsCount={}",
                saved.getId(),
                timetableId,
                subject.getId(),
                teacher.getId(),
                groups.size()
        );

        return assignmentMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public AssignmentResponse updateAssignment(Long timetableId, Long assignmentId, AssignmentRequest request) {
        log.info(
                "Updating assignment id={} for timetableId={}, newSubjectId={}, newTeacherId={}, newGroupIds={}",
                assignmentId,
                timetableId,
                request.subjectId(),
                request.teacherId(),
                request.groupIds()
        );

        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> {
                    log.warn(
                            "Assignment not found while updating. assignmentId={}, timetableId={}",
                            assignmentId,
                            timetableId
                    );
                    return new NotFoundException(
                            "Assignment not found with id: " + assignmentId + " in timetable: " + timetableId
                    );
                });

        Subject subject = subjectRepository.findById(request.subjectId())
                .orElseThrow(() -> {
                    log.warn("Subject not found while updating assignment. subjectId={}", request.subjectId());
                    return new NotFoundException("Subject not found with id: " + request.subjectId());
                });

        Teacher teacher = teacherRepository.findById(request.teacherId())
                .orElseThrow(() -> {
                    log.warn("Teacher not found while updating assignment. teacherId={}", request.teacherId());
                    return new NotFoundException("Teacher not found with id: " + request.teacherId());
                });

        Set<StudyGroup> groups = loadGroups(request.groupIds());

        validateAssignmentRequest(request, groups);

        assignmentMapper.updateEntityFromRequest(request, assignment);
        assignment.setSubject(subject);
        assignment.setTeacher(teacher);
        assignment.setGroups(groups);

        Assignment updated = assignmentRepository.save(assignment);

        log.info(
                "Assignment updated successfully. assignmentId={}, timetableId={}, subjectId={}, teacherId={}, groupsCount={}",
                updated.getId(),
                timetableId,
                subject.getId(),
                teacher.getId(),
                groups.size()
        );

        return assignmentMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteAssignment(Long timetableId, Long assignmentId, DeleteMode mode) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id " + assignmentId + " in timetable " + timetableId
                ));

        List<Lesson> lessons = new ArrayList<>(lessonRepository.findByAssignmentId(assignmentId));

        switch (mode) {
            case SIMPLE -> {
                if (!lessons.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete assignment with id " + assignmentId +
                                    " because it is used in " + lessons.size() + " lessons"
                    );
                }
            }

            case DETACH -> {
                for (Lesson lesson : lessons) {
                    lesson.setAssignment(null);
                }

                lessonRepository.saveAll(lessons);
            }

            case WITH -> lessonRepository.deleteAll(lessons);
        }

        assignmentRepository.delete(assignment);

        log.info(
                "Deleted assignment with id={} from timetable={} using mode={}",
                assignmentId,
                timetableId,
                mode
        );
    }

    private Set<StudyGroup> loadGroups(List<Long> groupIds) {
        log.debug("Loading study groups: {}", groupIds);

        if (groupIds == null || groupIds.isEmpty()) {
            log.warn("Assignment request contains no study groups");
            throw new IllegalArgumentException("Assignment must contain at least one study group");
        }

        Set<StudyGroup> groups = new LinkedHashSet<>(studyGroupRepository.findAllById(groupIds));

        if (groups.size() != groupIds.size()) {
            log.warn(
                    "Some study groups were not found. requestedCount={}, foundCount={}, requestedIds={}",
                    groupIds.size(),
                    groups.size(),
                    groupIds
            );
            throw new NotFoundException("One or more study groups were not found");
        }

        log.debug("Loaded {} study groups successfully", groups.size());
        return groups;
    }

    private void validateAssignmentRequest(AssignmentRequest request, Set<StudyGroup> groups) {
        if (request.hoursPerWeek() == null || request.hoursPerWeek() <= 0) {
            log.warn("Invalid hoursPerWeek in assignment request: {}", request.hoursPerWeek());
            throw new IllegalArgumentException("hoursPerWeek must be greater than 0");
        }

        if (request.shift() == null) {
            log.warn("Shift is null in assignment request");
            throw new IllegalArgumentException("shift must not be null");
        }

        if (groups == null || groups.isEmpty()) {
            log.warn("Assignment validation failed: groups are empty");
            throw new IllegalArgumentException("Assignment must contain at least one study group");
        }

        log.debug(
                "Assignment request validated successfully. hoursPerWeek={}, shift={}, groupsCount={}",
                request.hoursPerWeek(),
                request.shift(),
                groups.size()
        );
    }
}