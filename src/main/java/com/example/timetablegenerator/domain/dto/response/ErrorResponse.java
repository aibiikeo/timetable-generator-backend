package com.example.timetablegenerator.domain.dto.response;

public record ErrorResponse(
        String code,
        String message,
        String details
) {}