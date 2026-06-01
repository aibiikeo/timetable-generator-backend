package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.entities.Degree;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.Comparator;
import java.util.Set;

@Mapper(componentModel = "spring")
public interface SubjectMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "major", ignore = true)
    @Mapping(target = "teachers", ignore = true)
    @Mapping(target = "groups", ignore = true)
    Subject toEntity(SubjectRequest request);

    @Mapping(target = "majorId", source = "major.id")
    @Mapping(target = "majorName", source = "major.name")
    @Mapping(target = "degree", source = "groups", qualifiedByName = "mapDegree")
    @Mapping(target = "departmentId", source = "major.department.id")
    @Mapping(target = "departmentName", source = "major.department.name")
    @Mapping(target = "facultyId", source = "major.department.faculty.id")
    @Mapping(target = "facultyName", source = "major.department.faculty.name")
    SubjectResponse toResponse(Subject entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "major", ignore = true)
    @Mapping(target = "teachers", ignore = true)
    @Mapping(target = "groups", ignore = true)
    void updateEntityFromRequest(SubjectRequest request, @MappingTarget Subject entity);

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
}
