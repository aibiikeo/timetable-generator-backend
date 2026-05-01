package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.config.JwtUtils;
import com.example.timetablegenerator.domain.dto.request.LoginRequest;
import com.example.timetablegenerator.domain.dto.request.RefreshTokenRequest;
import com.example.timetablegenerator.domain.dto.response.AuthResponse;
import com.example.timetablegenerator.domain.dto.response.ErrorResponse;
import com.example.timetablegenerator.services.AuthService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SecurityRequirement(name = "")
@Tag(name = "Authentication")
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;
    private final JwtUtils jwtUtils;

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = authService.authenticateUser(request);
            log.info("User {} logged in successfully", request.email());
            return ResponseEntity.ok(response);

        } catch (BadCredentialsException e) {
            log.warn("Invalid credentials for user: {}", request.email());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(
                            "AUTH_001",
                            "Invalid email or password",
                            "Please check your credentials and try again"
                    ));

        } catch (DisabledException e) {
            log.warn("Disabled account attempted login: {}", request.email());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(
                            "AUTH_002",
                            "Account is disabled",
                            "Please contact administrator"
                    ));

        } catch (LockedException e) {
            log.warn("Locked account attempted login: {}", request.email());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(
                            "AUTH_003",
                            "Account is locked",
                            "Too many failed login attempts. Try again later or contact administrator"
                    ));

        } catch (Exception e) {
            log.error("Unexpected error during login for user: {}", request.email(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(
                            "AUTH_999",
                            "Internal server error",
                            "Please try again later"
                    ));
        }
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest request) {
        try {
            String newAccessToken = authService.refreshAccessToken(request.refreshToken());
            return ResponseEntity.ok(new AuthResponse(newAccessToken, null, jwtUtils.getJwtExpirationMs() / 1000L));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse("AUTH_004", "Invalid refresh token", "Please login again"));
        }
    }
}
