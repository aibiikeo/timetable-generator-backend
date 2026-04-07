package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.DepartmentRequest;
import com.example.timetablegenerator.domain.dto.response.DepartmentResponse;
import com.example.timetablegenerator.domain.entities.Department;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface DepartmentMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", ignore = true)
    Department toEntity(DepartmentRequest request);

    @Mapping(target = "facultyId", source = "faculty.id")
    @Mapping(target = "facultyName", source = "faculty.name")
    DepartmentResponse toResponse(Department entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", ignore = true)
    void updateEntityFromRequest(DepartmentRequest request, @MappingTarget Department entity);
}