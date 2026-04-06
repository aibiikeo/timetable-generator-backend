package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.TeacherRequest;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;
import com.example.timetablegenerator.domain.entities.Teacher;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface TeacherMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subjects", ignore = true)
    Teacher toEntity(TeacherRequest request);

    TeacherResponse toResponse(Teacher entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subjects", ignore = true)
    void updateEntityFromRequest(TeacherRequest request, @MappingTarget Teacher entity);
}