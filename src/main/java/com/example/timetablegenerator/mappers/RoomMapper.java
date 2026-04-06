package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.RoomRequest;
import com.example.timetablegenerator.domain.dto.response.RoomResponse;
import com.example.timetablegenerator.domain.entities.Room;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface RoomMapper {

    @Mapping(target = "id", ignore = true)
    Room toEntity(RoomRequest request);

    RoomResponse toResponse(Room entity);

    @Mapping(target = "id", ignore = true)
    void updateEntityFromRequest(RoomRequest request, @MappingTarget Room entity);
}