package com.example.timetablegenerator.domain.dto.request;

import com.example.timetablegenerator.domain.entities.UserRole;
import jakarta.validation.constraints.*;

public record UserRequest(
        @Email(message = "Invalid email format")
        @NotBlank(message = "Email is required")
        String email,

        @NotBlank(message = "Password is required")
        @Size(min = 8, message = "Password must be at least 8 characters")
//        @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$",
//                message = "Password must contain at least one digit, one lowercase, one uppercase, and one special character")
        String password,

        @NotNull(message = "Role is required")
        UserRole role
) {
}