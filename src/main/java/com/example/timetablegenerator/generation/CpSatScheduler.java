package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.google.ortools.Loader;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;

@Component
@RequiredArgsConstructor
public class CpSatScheduler {

    static {
        Loader.loadNativeLibraries();
    }

    public record ScheduledSlot(DayOfWeek day, LocalTime startTime, int durationHours, Room room) {}
    public record TimeSlotInfo(LocalTime startTime, LocalTime endTime) {}
    public record SchedulingResult(Map<Long, ScheduledSlot> placed, Set<Long> unplacedVertexIds) {}

    private final SchedulingCandidateGenerator candidateGenerator;
    private final CpSatModel modelFacade;
    private final RoomMatchingAssigner roomAssigner;
    private final SchedulingDiagnostics diagnostics;

    public SchedulingResult schedule(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<TimeSlotInfo>> slotsByDay
    ) {
        return schedule(vertices, allRooms, slotsByDay, Collections.emptyList());
    }

    public SchedulingResult schedule(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<TimeSlotInfo>> slotsByDay,
            List<Lesson> fixedLessons
    ) {
        SchedulingCandidateGenerator.CandidateContext candidateContext =
                candidateGenerator.build(vertices, allRooms, slotsByDay, fixedLessons);

        diagnostics.logCandidateSummary(vertices, candidateContext);

        CpSatModel.SolveResult solveResult =
                modelFacade.solve(vertices, candidateContext, allRooms, fixedLessons);

        diagnostics.logSolveOutcome(vertices, candidateContext, solveResult);

        RoomMatchingAssigner.RoomAssignmentResult roomAssignment =
                roomAssigner.assign(
                        solveResult.selectedTimes(),
                        vertices,
                        allRooms
                );

        Map<Long, ScheduledSlot> placed = new LinkedHashMap<>(roomAssignment.placed());
        Set<Long> unplaced = new LinkedHashSet<>(solveResult.unplacedVertexIds());
        unplaced.addAll(roomAssignment.unplacedAfterRoomAssignment());

        for (LessonVertex vertex : vertices) {
            if (!placed.containsKey(vertex.getId()) && !unplaced.contains(vertex.getId())) {
                unplaced.add(vertex.getId());
            }
        }

        return new SchedulingResult(placed, unplaced);
    }
}
