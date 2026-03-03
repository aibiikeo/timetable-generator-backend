package com.example.timetablegenerator.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtils {

    private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);

    @Value("${app.jwtSecret}")
    private String jwtSecret;

    @Value("${app.jwtExpirationMs}")
    private int jwtExpirationMs;

    @Value("${app.jwtRefreshExpirationMs:604800000}")
    private int jwtRefreshExpirationMs;

    public int getJwtExpirationMs() {
        return jwtExpirationMs;
    }

    public String generateJwtToken(Authentication authentication) {
        UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();
        String token = generateTokenFromUsername(userPrincipal.getUsername(), jwtExpirationMs);
        logger.info("Generated JWT token for user: {}", userPrincipal.getUsername());
        return token;
    }

    public String generateRefreshToken(Authentication authentication) {
        UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();
        return generateTokenFromUsername(userPrincipal.getUsername(), jwtRefreshExpirationMs);
    }

    private String generateTokenFromUsername(String username, long expirationMs) {
        return Jwts.builder()
                .subject(username)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(Keys.hmacShaKeyFor(jwtSecret.getBytes()))
                .compact();
    }

    public String getUserNameFromJwtToken(String token) {
        return Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(jwtSecret.getBytes()))
                .build().parseSignedClaims(token).getPayload().getSubject();
    }

    public boolean validateJwtToken(String authToken) {
        try {
            Jwts.parser().verifyWith(Keys.hmacShaKeyFor(jwtSecret.getBytes())).build().parseSignedClaims(authToken);
            return true;
        } catch (MalformedJwtException e) {
            logger.error("Invalid JWT token: {}", e.getMessage());
            logger.debug("Token content: {}", authToken);
        } catch (ExpiredJwtException e) {
            logger.error("JWT token is expired: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            logger.error("JWT token is unsupported: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.error("JWT claims string is empty: {}", e.getMessage());
        } catch (Exception e) {
            logger.error("Invalid JWT token: {}", e.getMessage());
        }
        return false;
    }
}