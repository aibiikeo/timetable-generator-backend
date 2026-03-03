package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.LoginRequest;
import com.example.timetablegenerator.domain.dto.response.AuthResponse;
import com.example.timetablegenerator.config.JwtUtils;
import com.example.timetablegenerator.services.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final UserDetailsService userDetailsService;

    @Override
    public AuthResponse authenticateUser(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.email(), loginRequest.password()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String accessToken = jwtUtils.generateJwtToken(authentication);
        String refreshToken = jwtUtils.generateRefreshToken(authentication);

        return new AuthResponse(accessToken, refreshToken, jwtUtils.getJwtExpirationMs() / 1000L);
    }

    @Override
    public String refreshAccessToken(String refreshToken) {
        if (!jwtUtils.validateJwtToken(refreshToken)) {
            throw new BadCredentialsException("Invalid refresh token");
        }

        String username = jwtUtils.getUserNameFromJwtToken(refreshToken);
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        return jwtUtils.generateJwtToken(authentication);
    }
}