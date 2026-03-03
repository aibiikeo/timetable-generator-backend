package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.LoginRequest;
import com.example.timetablegenerator.domain.dto.response.AuthResponse;

public interface AuthService {
    AuthResponse authenticateUser(LoginRequest request);
    String refreshAccessToken(String refreshToken);
}