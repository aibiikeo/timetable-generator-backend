    package com.example.timetablegenerator.services.impl;

    import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
    import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
    import com.example.timetablegenerator.domain.entities.Assignment;
    import com.example.timetablegenerator.domain.entities.Lesson;
    import com.example.timetablegenerator.domain.entities.StudyGroup;
    import com.example.timetablegenerator.exceptions.NotFoundException;
    import com.example.timetablegenerator.mappers.StudyGroupMapper;
    import com.example.timetablegenerator.repositories.AssignmentRepository;
    import com.example.timetablegenerator.repositories.FacultyRepository;
    import com.example.timetablegenerator.repositories.LessonRepository;
    import com.example.timetablegenerator.repositories.StudyGroupRepository;
    import com.example.timetablegenerator.services.StudyGroupService;
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
    public class StudyGroupServiceImpl implements StudyGroupService {

        private final StudyGroupRepository groupRepository;
        private final FacultyRepository facultyRepository;
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
            facultyRepository.findById(facultyId)
                    .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + facultyId));

            return groupRepository.findByFacultyId(facultyId).stream()
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
            StudyGroup group = groupMapper.toEntity(request);

            if (request.facultyId() != null) {
                var faculty = facultyRepository.findById(request.facultyId())
                        .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));
                group.setFaculty(faculty);
            }

            return groupMapper.toResponse(groupRepository.save(group));
        }

        @Transactional
        @Override
        public StudyGroupResponse updateGroup(Long groupId, StudyGroupRequest request) {
            StudyGroup group = groupRepository.findById(groupId)
                    .orElseThrow(() -> new NotFoundException("StudyGroup not found with id: " + groupId));

            groupMapper.updateEntityFromRequest(request, group);

            if (request.facultyId() != null) {
                var faculty = facultyRepository.findById(request.facultyId())
                        .orElseThrow(() -> new NotFoundException("Faculty not found with id: " + request.facultyId()));
                group.setFaculty(faculty);
            }

            return groupMapper.toResponse(groupRepository.save(group));
        }

        @Transactional
        @Override
        public void deleteGroup(Long groupId) {
            StudyGroup group = groupRepository.findById(groupId)
                    .orElseThrow(() -> new NotFoundException("StudyGroup not found with id: " + groupId));

            // 1. Отвязываем группу от всех Assignments
            List<Assignment> assignments = assignmentRepository.findByGroupId(groupId);
            for (Assignment assignment : assignments) {
                assignment.getGroups().remove(group);
                assignmentRepository.save(assignment);
            }

            // 2. Отвязываем группу от всех уроков
            List<Lesson> lessons = lessonRepository.findByGroupId(groupId);
            for (Lesson lesson : lessons) {
                lesson.getGroups().remove(group);
            }

            // 3. Отвязываем от subjects
            group.getSubjects().forEach(subject -> subject.getGroups().remove(group));
            group.getSubjects().clear();

            // 4. Теперь можно безопасно удалить группу
            groupRepository.delete(group);
        }
    }