package com.example.timetablegenerator.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "Timetable Generator API",
                version = "1.0"
        ),
        tags = {
                @Tag(name = "Authentication"),
                @Tag(name = "Users"),

                @Tag(name = "Faculties"),
                @Tag(name = "Departments"),
                @Tag(name = "Majors"),
                @Tag(name = "Study Groups"),

                @Tag(name = "Teachers"),
                @Tag(name = "Subjects"),
                @Tag(name = "Rooms"),

                @Tag(name = "Time Slots"),
                @Tag(name = "Lunch"),

                @Tag(name = "Timetables"),
                @Tag(name = "Assignments"),
                @Tag(name = "Generation"),
                @Tag(name = "Lessons")
        },
        security = {
                @SecurityRequirement(name = "bearerAuth")
        }
)
@SecurityScheme(
        name = "bearerAuth",
        scheme = "bearer",
        type = SecuritySchemeType.HTTP,
        bearerFormat = "JWT",
        in = SecuritySchemeIn.HEADER
)
public class OpenApiConfig {
}