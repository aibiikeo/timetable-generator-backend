package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.google.ortools.Loader;
import com.google.ortools.sat.BoolVar;
import com.google.ortools.sat.CpModel;
import com.google.ortools.sat.CpSolver;
import com.google.ortools.sat.CpSolverStatus;
import com.google.ortools.sat.IntVar;
import com.google.ortools.sat.LinearExpr;
import com.google.ortools.sat.Literal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class RoomMatchingAssigner {

    static {
        Loader.loadNativeLibraries();
    }

    public record RoomAssignmentResult(
            Map<Long, CpSatScheduler.ScheduledSlot> placed,
            Set<Long> unplacedAfterRoomAssignment
    ) {}

    private record RoomOccupancyKey(Long roomId, DayOfWeek day, LocalTime slotTime) {}
    private record VertexRoomKey(Long vertexId, Long roomId) {}

    public RoomAssignmentResult assign(
            Map<Long, SchedulingCandidateGenerator.TimeCandidate> selectedTimes,
            List<LessonVertex> vertices,
            List<Room> allRooms
    ) {
        Map<Long, LessonVertex> vertexById = vertices.stream()
                .collect(Collectors.toMap(LessonVertex::getId, v -> v));

        CpModel model = new CpModel();
        Map<VertexRoomKey, BoolVar> roomVars = new HashMap<>();
        Map<Long, BoolVar> unplacedVars = new HashMap<>();
        Map<RoomOccupancyKey, List<BoolVar>> roomOccupancy = new HashMap<>();

        for (Map.Entry<Long, SchedulingCandidateGenerator.TimeCandidate> entry : selectedTimes.entrySet()) {
            Long vertexId = entry.getKey();
            SchedulingCandidateGenerator.TimeCandidate candidate = entry.getValue();

            List<Literal> chooseOne = new ArrayList<>();
            for (Room room : candidate.allowedRooms()) {
                if (room.getId() == null) {
                    continue;
                }

                BoolVar var = model.newBoolVar("room_v" + vertexId + "_r" + room.getId());
                roomVars.put(new VertexRoomKey(vertexId, room.getId()), var);
                chooseOne.add(var);

                for (LocalTime slotTime : candidate.coveredSlots()) {
                    RoomOccupancyKey occupancyKey = new RoomOccupancyKey(room.getId(), candidate.day(), slotTime);
                    roomOccupancy.computeIfAbsent(occupancyKey, _key -> new ArrayList<>()).add(var);
                }
            }

            BoolVar unplaced = model.newBoolVar("room_unplaced_v" + vertexId);
            unplacedVars.put(vertexId, unplaced);
            chooseOne.add(unplaced);

            model.addExactlyOne(chooseOne.toArray(new Literal[0]));
        }

        for (List<BoolVar> vars : roomOccupancy.values()) {
            if (vars.size() > 1) {
                model.addAtMostOne(vars.toArray(new Literal[0]));
            }
        }

        model.minimize(LinearExpr.sum(unplacedVars.values().toArray(new IntVar[0])));

        CpSolver solver = new CpSolver();
        solver.getParameters().setMaxTimeInSeconds(30.0);
        solver.getParameters().setNumSearchWorkers(6);
        CpSolverStatus status = solver.solve(model);

        if (status != CpSolverStatus.OPTIMAL && status != CpSolverStatus.FEASIBLE) {
            return new RoomAssignmentResult(
                    Collections.emptyMap(),
                    new LinkedHashSet<>(selectedTimes.keySet())
            );
        }

        Map<Long, CpSatScheduler.ScheduledSlot> placed = new LinkedHashMap<>();
        Set<Long> unplaced = new LinkedHashSet<>();

        for (Long vertexId : selectedTimes.keySet()) {
            BoolVar unplacedVar = unplacedVars.get(vertexId);
            if (unplacedVar != null && solver.booleanValue(unplacedVar)) {
                unplaced.add(vertexId);
                continue;
            }

            SchedulingCandidateGenerator.TimeCandidate candidate = selectedTimes.get(vertexId);
            Room room = findSelectedRoom(candidate, vertexId, roomVars, solver, allRooms);
            if (room == null) {
                unplaced.add(vertexId);
                continue;
            }

            placed.put(vertexId, new CpSatScheduler.ScheduledSlot(
                    candidate.day(),
                    candidate.startTime(),
                    vertexById.get(vertexId).getDurationHours(),
                    room
            ));
        }

        return new RoomAssignmentResult(placed, unplaced);
    }

    private Room findSelectedRoom(
            SchedulingCandidateGenerator.TimeCandidate candidate,
            Long vertexId,
            Map<VertexRoomKey, BoolVar> roomVars,
            CpSolver solver,
            List<Room> allRooms
    ) {
        for (Room room : candidate.allowedRooms()) {
            if (room.getId() == null) {
                continue;
            }

            BoolVar var = roomVars.get(new VertexRoomKey(vertexId, room.getId()));
            if (var != null && solver.booleanValue(var)) {
                return findRoomById(allRooms, room.getId());
            }
        }
        return null;
    }

    private Room findRoomById(List<Room> rooms, Long roomId) {
        for (Room room : rooms) {
            if (Objects.equals(room.getId(), roomId)) return room;
        }
        return null;
    }

    private Comparator<Long> roomPriorityComparator(
            Map<Long, LessonVertex> vertexById,
            List<Room> allRooms
    ) {
        Map<RoomType, Long> roomTypeCounts = allRooms.stream()
                .filter(room -> room.getType() != null)
                .collect(Collectors.groupingBy(Room::getType, Collectors.counting()));

        return Comparator
                .comparing((Long vertexId) -> vertexById.get(vertexId).getSpecificRoomId() == null ? 1 : 0)
                .thenComparingLong(vertexId -> {
                    LessonVertex v = vertexById.get(vertexId);
                    if (v.getRoomTypeRequired() == null || v.getRoomTypeRequired() == RoomType.ANY) {
                        return Long.MAX_VALUE;
                    }
                    return roomTypeCounts.getOrDefault(v.getRoomTypeRequired(), 0L);
                })
                .thenComparing((Long vertexId) -> vertexById.get(vertexId).getDurationHours(), Comparator.reverseOrder())
                .thenComparingLong(Long::longValue);
    }
}
