package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.UserRole;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UserRequest(
        @Email(message = "Invalid email format")
        @NotBlank(message = "Email is required")
        @Schema(example = "admin10@example.com")
        String email,

        @NotBlank(message = "Password is required")
        @Size(min = 8, message = "Password must be at least 8 characters")
//        @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$",
//                message = "Password must contain at least one digit, one lowercase, one uppercase, and one special character")
        @Schema(example = "Admin12345")
        String password,

        @NotNull(message = "Role is required")
        @Schema(example = "ADMIN")
        UserRole role
) {
}