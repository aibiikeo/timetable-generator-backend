package com.example.timetablegenerator.domain.entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "assignments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"timetable", "subject", "teacher", "groups", "lessons"})
@EqualsAndHashCode(of = "id")
public class Assignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "timetable_id", nullable = false)
    private Timetable timetable;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    private Subject subject;

    @ManyToOne
    @JoinColumn(name = "teacher_id")
    private Teacher teacher;

    @ManyToMany
    @JoinTable(
            name = "assignment_groups",
            joinColumns = @JoinColumn(name = "assignment_id"),
            inverseJoinColumns = @JoinColumn(name = "group_id")
    )
    @Builder.Default
    private Set<StudyGroup> groups = new HashSet<>();

    @Column(name = "hours_per_week", nullable = false)
    private Integer hoursPerWeek;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Shift shift = Shift.ANY;

    @Enumerated(EnumType.STRING)
    @Column(name = "room_type_required", nullable = false)
    @Builder.Default
    private RoomType roomTypeRequired = RoomType.ANY;

    @Column(name = "hours_splitting")
    private String hoursSplitting; // Формат: "4+4" или "3+3+2"

    @Column(name = "generated_lessons_count")
    @Builder.Default
    private Integer generatedLessonsCount = 0;

    @OneToMany(mappedBy = "assignment", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Lesson> lessons = new ArrayList<>();

    @ElementCollection
    @Enumerated(EnumType.STRING)
    private Set<DayOfWeek> excludedDays;

    @ElementCollection
    private List<TimeSlotExclusion> excludedTimeSlots;

    @ElementCollection
    @Enumerated(EnumType.STRING)
    private List<DayOfWeek> preferredDays;

    private Long specificRoomId;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PlacementStatus placementStatus = PlacementStatus.PENDING;

    private String failureReason;

    @Column(name = "requires_manual_input")
    @Builder.Default
    private Boolean requiresManualInput = false;
}