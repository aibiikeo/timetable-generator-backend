package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "timetables")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Timetable {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "created_at", updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "is_current")
    @Builder.Default
    private boolean current = false;

    @Column(name = "is_published")
    @Builder.Default
    private boolean published = false;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private TimetableStatus status = TimetableStatus.DRAFT;

    @Column(columnDefinition = "jsonb")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> generationSettings;

    @Column(columnDefinition = "jsonb")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> conflictReport;

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Assignment> assignments = new ArrayList<>();

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Lesson> lessons = new ArrayList<>();
}

