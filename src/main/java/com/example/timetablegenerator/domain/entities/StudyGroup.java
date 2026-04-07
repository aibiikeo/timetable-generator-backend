package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "study_groups")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"major", "subjects"})
@EqualsAndHashCode(of = "id")
public class StudyGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "major_id", nullable = false)
    private Major major;

    @Column(nullable = false)
    private Integer course;

    @Column(columnDefinition = "integer default 25")
    @Builder.Default
    private Integer studentCount = 25;

    @ManyToMany(mappedBy = "groups")
    @Builder.Default
    private Set<Subject> subjects = new HashSet<>();
}