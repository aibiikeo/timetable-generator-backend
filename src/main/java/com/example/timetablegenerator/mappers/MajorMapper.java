package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.MajorRequest;
import com.example.timetablegenerator.domain.dto.response.MajorResponse;
import com.example.timetablegenerator.domain.entities.Major;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface MajorMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "department", ignore = true)
    Major toEntity(MajorRequest request);

    @Mapping(target = "departmentId", source = "department.id")
    @Mapping(target = "departmentName", source = "department.name")
    @Mapping(target = "facultyId", source = "department.faculty.id")
    @Mapping(target = "facultyName", source = "department.faculty.name")
    @Mapping(target = "facultyShortName", source = "department.faculty.shortName")
    MajorResponse toResponse(Major entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "department", ignore = true)
    void updateEntityFromRequest(MajorRequest request, @MappingTarget Major entity);
}