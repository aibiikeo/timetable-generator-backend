package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface AssignmentMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "excludedTimeSlots", ignore = true)
    Assignment toEntity(AssignmentRequest request);

    AssignmentResponse toResponse(Assignment entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "excludedTimeSlots", ignore = true)
    void updateEntityFromRequest(AssignmentRequest request, @MappingTarget Assignment entity);
}