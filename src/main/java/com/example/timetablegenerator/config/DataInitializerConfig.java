package com.example.timetablegenerator.config;

import com.example.timetablegenerator.domain.dto.request.SuperAdminRequest;
import com.example.timetablegenerator.domain.entities.UserRole;
import com.example.timetablegenerator.repositories.UserRepository;
import com.example.timetablegenerator.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DataInitializerConfig {

    private final UserRepository userRepository;
    private final UserService userService;

    @Bean
    public CommandLineRunner initSuperAdmin() {
        return args -> {
            if (userRepository.existsByRole(UserRole.SUPER_ADMIN)) {
                log.info("Super admin already exists. Skipping creation.");
                return;
            }

            try {
                SuperAdminRequest request = new SuperAdminRequest(
                        "superadmin@example.com",
                        "SuperSecret123"
                );

                userService.createFirstSuperAdmin(request);
                log.info("First super admin successfully created: {}", request.email());
            } catch (Exception e) {
                log.error("Error while creating super admin", e);
            }
        };
    }
}