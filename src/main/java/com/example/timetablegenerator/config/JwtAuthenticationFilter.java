package com.example.timetablegenerator.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    private final JwtUtils jwtUtils;
    private final UserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtUtils jwtUtils, UserDetailsService userDetailsService) {
        this.jwtUtils = jwtUtils;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        try {
            String jwt = parseJwt(request);

            if (jwt != null) {
                logger.debug("Attempting to validate JWT token");

                // Проверяем, что токен имеет правильный формат JWT (содержит точки)
                if (!isValidJwtFormat(jwt)) {
                    logger.warn("Invalid JWT format: token does not contain required parts");
                } else if (jwtUtils.validateJwtToken(jwt)) {
                    String username = jwtUtils.getUserNameFromJwtToken(jwt);

                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    logger.debug("User {} authenticated successfully", username);
                }
            }
        } catch (Exception e) {
            logger.error("Cannot set user authentication: {}", e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            String token = headerAuth.substring(7);

            // Дополнительная валидация формата
            if (!StringUtils.hasText(token)) {
                logger.warn("Bearer token is empty after 'Bearer ' prefix");
                return null;
            }

            // Проверяем, что токен не равен строке "null"
            if ("null".equalsIgnoreCase(token.trim())) {
                logger.warn("Bearer token is literally 'null' string");
                return null;
            }

            logger.debug("Extracted JWT token: {}... (first 20 chars)",
                    token.length() > 20 ? token.substring(0, 20) : token);
            return token;
        }

        return null;
    }

    private boolean isValidJwtFormat(String token) {
        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        // JWT должен содержать ровно 2 точки для JWS или 4 для JWE
        long dotCount = token.chars().filter(ch -> ch == '.').count();
        return dotCount == 2 || dotCount == 4;
    }
}