package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.Subject;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

@Mapper
public interface SubjectMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", source = "facultyId", qualifiedByName = "mapFaculty")
    @Mapping(target = "teachers", ignore = true)   // будут пустыми после создания/обновления
    @Mapping(target = "groups", ignore = true)
    Subject toEntity(SubjectRequest request);

    @Mapping(source = "faculty.id", target = "facultyId")
    SubjectResponse toResponse(Subject entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", source = "facultyId", qualifiedByName = "mapFaculty")
    @Mapping(target = "teachers", ignore = true)
    @Mapping(target = "groups", ignore = true)
    void updateEntityFromRequest(SubjectRequest request, @MappingTarget Subject entity);

    @Named("mapFaculty")
    default Faculty mapFaculty(Long id) {
        return id != null ? Faculty.builder().id(id).build() : null;
    }
}
