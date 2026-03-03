package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.FacultyCreateRequest;
import com.example.timetablegenerator.domain.dto.request.FacultyUpdateRequest;
import com.example.timetablegenerator.domain.dto.response.FacultyResponse;
import com.example.timetablegenerator.domain.entities.Faculty;
import org.mapstruct.*;

@Mapper
public interface FacultyMapper {
    @Mapping(target = "id", ignore = true)
    Faculty toEntity(FacultyCreateRequest request);

    FacultyResponse toResponse(Faculty entity);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    void updateEntityFromRequest(FacultyUpdateRequest request, @MappingTarget Faculty entity);
}
