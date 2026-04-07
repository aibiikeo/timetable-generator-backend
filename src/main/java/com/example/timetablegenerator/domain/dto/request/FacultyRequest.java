package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record FacultyRequest(

        @NotBlank(message = "Faculty name is required")
        String name

) {}