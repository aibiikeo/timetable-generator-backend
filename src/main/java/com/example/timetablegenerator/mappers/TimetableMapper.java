package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Timetable;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface TimetableMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    Timetable toEntity(TimetableRequest request);

    TimetableResponse toResponse(Timetable entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    void updateEntityFromRequest(TimetableRequest request, @MappingTarget Timetable entity);
}