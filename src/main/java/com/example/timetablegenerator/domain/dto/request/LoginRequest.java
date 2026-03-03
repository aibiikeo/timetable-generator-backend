package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.*;

public record LoginRequest(
        @Email(message = "Invalid email format")
        @NotBlank(message = "Email is required")
        String email,

        @NotBlank(message = "Password is required")
        String password
) {
}
