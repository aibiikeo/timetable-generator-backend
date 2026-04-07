package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "rooms")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(columnDefinition = "integer default 30")
    @Builder.Default
    private Integer capacity = 30;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RoomType type;
}
