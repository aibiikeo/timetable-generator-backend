package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.UserRole;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record UserUpdateRequest(
        @Email(message = "Invalid email format")
        @NotBlank(message = "Email is required")
        @Schema(example = "admin10@example.com")
        String email,

        @Pattern(regexp = "^$|.{8,}", message = "Password must be at least 8 characters")
        @Schema(example = "Admin12345", nullable = true)
        String password,

        @NotNull(message = "Role is required")
        @Schema(example = "ADMIN")
        UserRole role
) {
}
