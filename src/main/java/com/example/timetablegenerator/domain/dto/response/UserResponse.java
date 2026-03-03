package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.UserRole;

public record UserResponse(
        Long id,
        String email,
        UserRole role
) {}
