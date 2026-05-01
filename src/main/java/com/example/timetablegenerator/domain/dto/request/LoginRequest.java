package com.example.timetablegenerator.domain.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record LoginRequest(
        @Email(message = "Invalid email format")
        @NotBlank(message = "Email is required")
        @Schema(example = "superadmin@example.com")
        String email,

        @NotBlank(message = "Password is required")
        @Schema(example = "SuperSecret123")
        String password
) {
}
