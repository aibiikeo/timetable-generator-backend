package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(uses = {SubjectMapper.class, TeacherMapper.class})
public interface AssignmentMapper {

    @Mapping(target = "subject", source = "subjectId", qualifiedByName = "mapSubject")
    @Mapping(target = "teacher", source = "teacherId", qualifiedByName = "mapTeacher")
    @Mapping(target = "groups", source = "groupIds", qualifiedByName = "mapGroups")
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    @Mapping(target = "generatedLessonsCount", ignore = true)      // будет 0 по умолчанию
    @Mapping(target = "placementStatus", ignore = true)           // будет PENDING по умолчанию
    @Mapping(target = "failureReason", ignore = true)
    @Mapping(target = "requiresManualInput", ignore = true)       // будет false
    Assignment toEntity(AssignmentRequest request);

    @Mapping(target = "subjectId", source = "subject.id")
    @Mapping(target = "teacherId", source = "teacher.id")
    @Mapping(target = "requiredLessonsCount", ignore = true)      // вычисляется в сервисе
    @Mapping(target = "splittingOptions", ignore = true)
    @Mapping(target = "selectedSplitting", ignore = true)
    @Mapping(target = "subjectName", source = "subject.name")
    @Mapping(target = "teacherName", source = "teacher.fullName")
    @Mapping(target = "groupIds", source = "groups", qualifiedByName = "groupsToIds")
    @Mapping(target = "groupNames", source = "groups", qualifiedByName = "groupsToNames")
    @Mapping(target = "generatedLessonsCount", source = "lessons", qualifiedByName = "countLessons")
    AssignmentResponse toResponse(Assignment entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    @Mapping(target = "generatedLessonsCount", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    @Mapping(target = "placementStatus", ignore = true)
    @Mapping(target = "failureReason", ignore = true)
    @Mapping(target = "requiresManualInput", ignore = true)
    void updateEntityFromRequest(AssignmentRequest request, @MappingTarget Assignment entity);

    List<AssignmentResponse> toResponseList(List<Assignment> entities);

    @Named("mapSubject")
    default Subject mapSubject(Long id) {
        return id != null ? Subject.builder().id(id).build() : null;
    }

    @Named("mapTeacher")
    default Teacher mapTeacher(Long id) {
        return id != null ? Teacher.builder().id(id).build() : null;
    }

    @Named("mapGroups")
    default Set<StudyGroup> mapGroups(List<Long> ids) {
        if (ids == null) return Set.of();
        return ids.stream()
                .map(id -> StudyGroup.builder().id(id).build())
                .collect(Collectors.toSet());
    }

    @Named("groupsToIds")
    default List<Long> groupsToIds(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) return List.of();
        return groups.stream()
                .filter(Objects::nonNull)
                .map(StudyGroup::getId)
                .filter(Objects::nonNull)
                .sorted()
                .collect(Collectors.toList());
    }

    @Named("groupsToNames")
    default List<String> groupsToNames(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) return List.of();
        return groups.stream()
                .filter(Objects::nonNull)
                .map(StudyGroup::getName)
                .filter(Objects::nonNull)
                .sorted()
                .collect(Collectors.toList());
    }

    @Named("countLessons")
    default int countLessons(List<Lesson> lessons) {
        return lessons != null ? lessons.size() : 0;
    }
}