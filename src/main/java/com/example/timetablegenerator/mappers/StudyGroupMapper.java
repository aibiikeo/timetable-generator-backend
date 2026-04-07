package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface StudyGroupMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "major", ignore = true)
    @Mapping(target = "subjects", ignore = true)
    StudyGroup toEntity(StudyGroupRequest request);

    @Mapping(target = "majorId", source = "major.id")
    @Mapping(target = "majorName", source = "major.name")
    @Mapping(target = "degree", source = "major.degree")
    @Mapping(target = "departmentId", source = "major.department.id")
    @Mapping(target = "departmentName", source = "major.department.name")
    @Mapping(target = "facultyId", source = "major.department.faculty.id")
    @Mapping(target = "facultyName", source = "major.department.faculty.name")
    StudyGroupResponse toResponse(StudyGroup entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "major", ignore = true)
    @Mapping(target = "subjects", ignore = true)
    void updateEntityFromRequest(StudyGroupRequest request, @MappingTarget StudyGroup entity);
}