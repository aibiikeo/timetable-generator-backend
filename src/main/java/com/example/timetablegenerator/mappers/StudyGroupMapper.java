package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

@Mapper
public interface StudyGroupMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", source = "facultyId", qualifiedByName = "mapFaculty")
    @Mapping(target = "subjects", ignore = true)
    StudyGroup toEntity(StudyGroupRequest request);

    @Mapping(target = "facultyId", source = "faculty.id")
    @Mapping(target = "facultyName", source = "faculty.name")
    StudyGroupResponse toResponse(StudyGroup entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", source = "facultyId", qualifiedByName = "mapFaculty")
    @Mapping(target = "subjects", ignore = true)
    void updateEntityFromRequest(StudyGroupRequest request, @MappingTarget StudyGroup entity);

    @Named("mapFaculty")
    default Faculty mapFaculty(Long id) {
        return id != null ? Faculty.builder().id(id).build() : null;
    }
}
