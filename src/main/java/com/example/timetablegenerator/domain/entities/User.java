package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role;

    @Builder.Default
    @Column(nullable = false, columnDefinition = "boolean default true")
    private boolean quickActionsAutoEnabled = true;

    @Builder.Default
    @ElementCollection
    @CollectionTable(name = "user_quick_actions", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "action_id", nullable = false)
    @OrderColumn(name = "position")
    private List<String> quickActionIds = new ArrayList<>();
}

