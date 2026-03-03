package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "study_groups")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudyGroup {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @ManyToOne
    @JoinColumn(name = "faculty_id")
    private Faculty faculty;

    private Integer course;

    @Column(columnDefinition = "integer default 25")
    @Builder.Default
    private Integer studentCount = 25;

    @ManyToMany(mappedBy = "groups")
    @Builder.Default
    private Set<Subject> subjects = new HashSet<>();
}
