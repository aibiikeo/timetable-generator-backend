package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.domain.entities.Teacher;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.AssignmentMapper;
import com.example.timetablegenerator.repositories.AssignmentRepository;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.repositories.StudyGroupRepository;
import com.example.timetablegenerator.repositories.SubjectRepository;
import com.example.timetablegenerator.repositories.TeacherRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.AssignmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
@Slf4j
public class AssignmentServiceImpl implements AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final TimetableRepository timetableRepository;
    private final SubjectRepository subjectRepository;
    private final TeacherRepository teacherRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final RoomRepository roomRepository;
    private final AssignmentMapper assignmentMapper;

    @Override
    public List<AssignmentResponse> getAllAssignments(Long timetableId) {
        if (!timetableRepository.existsById(timetableId)) {
            throw new NotFoundException("Timetable not found with id: " + timetableId);
        }

        return assignmentRepository.findByTimetableId(timetableId).stream()
                .map(assignmentMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<AssignmentResponse> getAssignment(Long timetableId, Long assignmentId) {
        return assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .map(assignmentMapper::toResponse);
    }

    @Transactional
    @Override
    public AssignmentResponse createAssignment(Long timetableId, AssignmentRequest request) {
        Timetable timetable = timetableRepository.findById(timetableId)
                .orElseThrow(() -> new NotFoundException("Timetable not found with id: " + timetableId));

        Subject subject = subjectRepository.findById(request.subjectId())
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + request.subjectId()));

        Teacher teacher = teacherRepository.findById(request.teacherId())
                .orElseThrow(() -> new NotFoundException("Teacher not found with id: " + request.teacherId()));

        Set<StudyGroup> groups = resolveGroups(request.groupIds());

        validateAssignmentConsistency(subject, teacher, groups, request.specificRoomId(), request.roomTypeRequired());

        Assignment assignment = assignmentMapper.toEntity(request);
        assignment.setTimetable(timetable);
        assignment.setSubject(subject);
        assignment.setTeacher(teacher);
        assignment.setGroups(groups);

        Assignment saved = assignmentRepository.save(assignment);
        log.info("Created assignment {} in timetable {}", saved.getId(), timetableId);

        return assignmentMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public AssignmentResponse updateAssignment(Long timetableId, Long assignmentId, AssignmentRequest request) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable " + timetableId));

        Subject subject = subjectRepository.findById(request.subjectId())
                .orElseThrow(() -> new NotFoundException("Subject not found with id: " + request.subjectId()));

        Teacher teacher = teacherRepository.findById(request.teacherId())
                .orElseThrow(() -> new NotFoundException("Teacher not found with id: " + request.teacherId()));

        Set<StudyGroup> groups = resolveGroups(request.groupIds());

        validateAssignmentConsistency(subject, teacher, groups, request.specificRoomId(), request.roomTypeRequired());

        assignmentMapper.updateEntityFromRequest(request, assignment);
        assignment.setSubject(subject);
        assignment.setTeacher(teacher);
        assignment.setGroups(groups);

        Assignment updated = assignmentRepository.save(assignment);
        log.info("Updated assignment {} in timetable {}", assignmentId, timetableId);

        return assignmentMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteAssignment(Long timetableId, Long assignmentId) {
        Assignment assignment = assignmentRepository.findByIdAndTimetableId(assignmentId, timetableId)
                .orElseThrow(() -> new NotFoundException(
                        "Assignment not found with id: " + assignmentId + " in timetable " + timetableId));

        assignmentRepository.delete(assignment);
        log.info("Deleted assignment {} from timetable {}", assignmentId, timetableId);
    }

    private Set<StudyGroup> resolveGroups(List<Long> groupIds) {
        List<StudyGroup> foundGroups = studyGroupRepository.findAllById(groupIds);

        if (foundGroups.size() != groupIds.size()) {
            throw new NotFoundException("One or more study groups were not found");
        }

        return new HashSet<>(foundGroups);
    }

    private void validateAssignmentConsistency(
            Subject subject,
            Teacher teacher,
            Set<StudyGroup> groups,
            Long specificRoomId,
            com.example.timetablegenerator.domain.entities.RoomType roomTypeRequired
    ) {
        if (!subject.getTeachers().isEmpty() && !subject.getTeachers().contains(teacher)) {
            throw new IllegalStateException("Selected teacher is not assigned to the selected subject");
        }

        for (StudyGroup group : groups) {
            if (!group.getMajor().getId().equals(subject.getMajor().getId())) {
                throw new IllegalStateException(
                        "Group '" + group.getName() + "' belongs to a different major than subject '" + subject.getName() + "'"
                );
            }
        }

        if (specificRoomId != null) {
            Room room = roomRepository.findById(specificRoomId)
                    .orElseThrow(() -> new NotFoundException("Room not found with id: " + specificRoomId));

            if (roomTypeRequired != com.example.timetablegenerator.domain.entities.RoomType.ANY
                    && room.getType() != roomTypeRequired) {
                throw new IllegalStateException("Specific room type does not match required room type");
            }
        }
    }
}