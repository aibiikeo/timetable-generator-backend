package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Timetable;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(uses = AssignmentMapper.class)
public interface TimetableMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)           // установится в сущности через @Builder.Default
    @Mapping(target = "current", ignore = true)             // false по умолчанию
    @Mapping(target = "published", ignore = true)           // false
    @Mapping(target = "status", ignore = true)              // DRAFT
    @Mapping(target = "generationSettings", ignore = true)  // будет маппиться отдельно, если нужно
    @Mapping(target = "conflictReport", ignore = true)
    @Mapping(target = "assignments", source = "assignments") // использует AssignmentMapper.toEntity
    @Mapping(target = "lessons", ignore = true)             // пустой список по умолчанию
    Timetable toEntity(TimetableRequest request);

    // остальные методы без изменений
    @Mapping(target = "totalLessons", expression = "java(entity.getLessons() != null ? entity.getLessons().size() : 0)")
    @Mapping(target = "totalRequiredLessons", constant = "0")
    @Mapping(target = "isCurrent", source = "current")
    TimetableResponse toResponse(Timetable entity);

    List<TimetableResponse> toResponseList(List<Timetable> entities);
}
