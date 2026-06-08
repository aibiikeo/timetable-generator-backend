package com.example.timetablegenerator.domain.dto.response;

public record QuickActionOptionResponse(
        String id,
        String label,
        String method,
        String pathTemplate,
        String group
) {
}
