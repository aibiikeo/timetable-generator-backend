package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.UserRequest;
import com.example.timetablegenerator.domain.dto.response.UserResponse;
import com.example.timetablegenerator.domain.entities.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface UserMapper {
    @Mapping(target = "id", ignore = true)
    User toEntity(UserRequest request);
    UserResponse toResponse(User entity);
}
