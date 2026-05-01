package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record FacultyRequest(
        @NotBlank(message = "Faculty name is required")
        @Schema(example = "Faculty of Computer Science")
        String name

) {}