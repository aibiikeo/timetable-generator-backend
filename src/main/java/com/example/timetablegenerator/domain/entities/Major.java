package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "majors")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"department"})
@EqualsAndHashCode(of = "id")
public class Major {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String shortName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Degree degree;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;
}