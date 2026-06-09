package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "timetables")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"assignments", "lessons"})
@EqualsAndHashCode(of = "id")
public class Timetable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "academic_year_start", nullable = false)
    private Integer academicYearStart;

    @Column(name = "academic_year_end", nullable = false)
    private Integer academicYearEnd;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Semester semester;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "faculty_id", nullable = false)
    private Faculty faculty;

    @Column(nullable = false)
    @Builder.Default
    private Integer version = 0;

    @Column(name = "created_at", updatable = false, nullable = false)
    private LocalDateTime createdAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private TimetableStatus status = TimetableStatus.DRAFT;

    @Column(columnDefinition = "jsonb")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> conflictReport;

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Assignment> assignments = new ArrayList<>();

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Lesson> lessons = new ArrayList<>();

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        syncDerivedFields();
    }

    public void syncDerivedFields() {
        if (academicYearStart == null) {
            throw new IllegalStateException("Academic year start is required");
        }
        if (semester == null) {
            throw new IllegalStateException("Semester is required");
        }
        if (faculty == null) {
            throw new IllegalStateException("Faculty is required");
        }
        if (version == null) {
            version = 0;
        }

        this.academicYearEnd = academicYearStart + 1;

        if (name == null || name.isBlank()) {
            this.name = buildDefaultName();
        }
    }

    public String buildDefaultName() {
        return "Course Schedule " + faculty.getName() + " " + semester + " "
                + academicYearStart + "-" + academicYearEnd
                + " v" + version;
    }
}
