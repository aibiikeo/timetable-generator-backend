package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;
import java.time.DayOfWeek;
import java.time.LocalTime;

/**
 * Представляет временной слот для занятий.
 * Может быть общим для всех дней или привязан к конкретному дню недели.
 */
@Entity
@Table(name = "time_slots")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimeSlot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "day_of_week")
    private DayOfWeek dayOfWeek;

    @Column(name = "slot_order", nullable = false)
    private Integer order;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(name = "is_lunch")
    private boolean isLunch;

    @Column(name = "description")
    private String description;
}