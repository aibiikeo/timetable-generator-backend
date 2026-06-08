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
    public record SchedulingResult(
            Map<Long, ScheduledSlot> placed,
            Set<Long> unplacedVertexIds,
            Map<Long, String> unplacedReasons
    ) {}

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
        Map<Long, String> unplacedReasons = buildUnplacedReasons(
                vertices,
                candidateContext,
                solveResult.unplacedVertexIds(),
                roomAssignment.unplacedAfterRoomAssignment()
        );

        for (LessonVertex vertex : vertices) {
            if (!placed.containsKey(vertex.getId()) && !unplaced.contains(vertex.getId())) {
                unplaced.add(vertex.getId());
                unplacedReasons.putIfAbsent(vertex.getId(), "No placement returned by scheduler");
            }
        }

        return new SchedulingResult(placed, unplaced, unplacedReasons);
    }

    private Map<Long, String> buildUnplacedReasons(
            List<LessonVertex> vertices,
            SchedulingCandidateGenerator.CandidateContext candidateContext,
            Set<Long> solverUnplaced,
            Set<Long> roomUnplaced
    ) {
        Map<Long, String> reasons = new LinkedHashMap<>();

        for (LessonVertex vertex : vertices) {
            List<SchedulingCandidateGenerator.TimeCandidate> candidates =
                    candidateContext.candidatesByVertex().getOrDefault(vertex.getId(), Collections.emptyList());

            if (candidates.isEmpty()) {
                reasons.put(vertex.getId(), "No feasible time/room candidates. Check shift, excluded days/time slots, room type/capacity, and existing lessons.");
            }
        }

        for (Long vertexId : solverUnplaced) {
            List<SchedulingCandidateGenerator.TimeCandidate> candidates =
                    candidateContext.candidatesByVertex().getOrDefault(vertexId, Collections.emptyList());
            reasons.putIfAbsent(vertexId, candidates.isEmpty()
                    ? "No feasible time/room candidates. Check shift, excluded days/time slots, room type/capacity, and existing lessons."
                    : "No conflict-free slot found after teacher, group, lunch, room, and same-day subject constraints.");
        }

        for (Long vertexId : roomUnplaced) {
            reasons.put(vertexId, "No available room matched the selected time after room assignment.");
        }

        return reasons;
    }
}
