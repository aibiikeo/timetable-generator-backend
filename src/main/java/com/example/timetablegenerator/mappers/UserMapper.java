package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.UserRequest;
import com.example.timetablegenerator.domain.dto.response.UserResponse;
import com.example.timetablegenerator.domain.entities.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface UserMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "quickActionsAutoEnabled", ignore = true)
    @Mapping(target = "quickActionIds", ignore = true)
    User toEntity(UserRequest request);

    UserResponse toResponse(User entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "quickActionsAutoEnabled", ignore = true)
    @Mapping(target = "quickActionIds", ignore = true)
    void updateEntityFromRequest(UserRequest request, @MappingTarget User entity);
}
