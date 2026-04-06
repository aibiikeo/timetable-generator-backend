package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.FacultyRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;
import com.example.timetablegenerator.domain.entities.Faculty;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface FacultyMapper {

    @Mapping(target = "id", ignore = true)
    Faculty toEntity(FacultyRequest request);

    FacultyResponse toResponse(Faculty entity);

    @Mapping(target = "id", ignore = true)
    void updateEntityFromRequest(FacultyRequest request, @MappingTarget Faculty entity);
}