package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "quick_action_usage",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "action_id"})
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuickActionUsage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "action_id", nullable = false)
    private String actionId;

    @Builder.Default
    @Column(nullable = false)
    private long useCount = 0;

    @Column(nullable = false)
    private LocalDateTime lastUsedAt;
}
