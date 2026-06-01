package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.LessonRequest;
import com.example.timetablegenerator.domain.dto.response.LessonResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Degree;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import org.mapstruct.*;

import java.util.Comparator;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring")
public interface LessonMapper {

    @Mapping(target = "assignment", source = "assignmentId", qualifiedByName = "mapAssignment")
    @Mapping(target = "room", source = "roomId", qualifiedByName = "mapRoom")
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    Lesson toEntity(LessonRequest request);

    @Mapping(target = "timetableId", source = "timetable.id")
    @Mapping(target = "assignmentId", source = "assignment.id")
    @Mapping(target = "subjectName", source = "subject.name")
    @Mapping(target = "teacherName", source = "teacher.fullName")
    @Mapping(target = "groupNames", source = "groups", qualifiedByName = "mapGroupNames")
    @Mapping(target = "roomName", source = "room", qualifiedByName = "mapRoomName")

    @Mapping(target = "majorId", source = "subject.major.id")
    @Mapping(target = "majorName", source = "subject.major.name")
    @Mapping(target = "degree", source = "groups", qualifiedByName = "mapDegree")
    @Mapping(target = "departmentId", source = "subject.major.department.id")
    @Mapping(target = "departmentName", source = "subject.major.department.name")
    @Mapping(target = "facultyId", source = "subject.major.department.faculty.id")
    @Mapping(target = "facultyName", source = "subject.major.department.faculty.name")
    LessonResponse toResponse(Lesson entity);

    @Mapping(target = "assignment", source = "assignmentId", qualifiedByName = "mapAssignment")
    @Mapping(target = "room", source = "roomId", qualifiedByName = "mapRoom")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    void updateEntityFromRequest(LessonRequest request, @MappingTarget Lesson entity);

    List<LessonResponse> toResponseList(List<Lesson> entities);

    @AfterMapping
    default void afterToEntity(@MappingTarget Lesson lesson, LessonRequest request) {
        if (lesson.getAssignment() != null) {
            lesson.setSubject(lesson.getAssignment().getSubject());
            lesson.setTeacher(lesson.getAssignment().getTeacher());
            lesson.setGroups(lesson.getAssignment().getGroups());
        }
    }

    @AfterMapping
    default void afterUpdate(@MappingTarget Lesson lesson, LessonRequest request) {
        if (lesson.getAssignment() != null) {
            lesson.setSubject(lesson.getAssignment().getSubject());
            lesson.setTeacher(lesson.getAssignment().getTeacher());
            lesson.setGroups(lesson.getAssignment().getGroups());
        }
    }

    @Named("mapAssignment")
    default Assignment mapAssignment(Long id) {
        return id != null ? Assignment.builder().id(id).build() : null;
    }

    @Named("mapRoom")
    default Room mapRoom(Long id) {
        return id != null ? Room.builder().id(id).build() : null;
    }

    @Named("mapGroupNames")
    default List<String> mapGroupNames(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) {
            return List.of();
        }
        return groups.stream()
                .map(StudyGroup::getName)
                .sorted()
                .toList();
    }

    @Named("mapDegree")
    default Degree mapDegree(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) {
            return null;
        }

        return groups.stream()
                .map(StudyGroup::getDegree)
                .filter(java.util.Objects::nonNull)
                .sorted(Comparator.comparing(Enum::name))
                .findFirst()
                .orElse(null);
    }

    @Named("mapRoomName")
    default String mapRoomName(Room room) {
        return room != null ? room.getName() : "Дистанционно";
    }
}
