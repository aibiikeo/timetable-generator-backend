package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class RoomMatchingAssigner {

    public record RoomAssignmentResult(
            Map<Long, CpSatScheduler.ScheduledSlot> placed,
            Set<Long> unplacedAfterRoomAssignment
    ) {}

    private record RoomOccupancyKey(Long roomId, DayOfWeek day, LocalTime slotTime) {}

    public RoomAssignmentResult assign(
            Map<Long, SchedulingCandidateGenerator.TimeCandidate> selectedTimes,
            List<LessonVertex> vertices,
            List<Room> allRooms
    ) {
        Map<Long, LessonVertex> vertexById = vertices.stream()
                .collect(Collectors.toMap(LessonVertex::getId, v -> v));

        Map<DayOfWeek, Map<LocalTime, List<Long>>> byDayAndStart = new EnumMap<>(DayOfWeek.class);
        for (Map.Entry<Long, SchedulingCandidateGenerator.TimeCandidate> entry : selectedTimes.entrySet()) {
            byDayAndStart
                    .computeIfAbsent(entry.getValue().day(), _d -> new TreeMap<>())
                    .computeIfAbsent(entry.getValue().startTime(), _t -> new ArrayList<>())
                    .add(entry.getKey());
        }

        Map<Long, CpSatScheduler.ScheduledSlot> placed = new LinkedHashMap<>();
        Set<Long> unplaced = new LinkedHashSet<>();
        Set<RoomOccupancyKey> occupied = new HashSet<>();

        for (DayOfWeek day : byDayAndStart.keySet()) {
            for (Map.Entry<LocalTime, List<Long>> startEntry : byDayAndStart.get(day).entrySet()) {
                List<Long> vertexIds = new ArrayList<>(startEntry.getValue());
                vertexIds.sort(roomPriorityComparator(vertexById, allRooms));

                Map<Long, List<Long>> adjacency = new LinkedHashMap<>();
                for (Long vertexId : vertexIds) {
                    LessonVertex vertex = vertexById.get(vertexId);
                    SchedulingCandidateGenerator.TimeCandidate candidate = selectedTimes.get(vertexId);

                    List<Long> roomIds = candidate.allowedRooms().stream()
                            .map(Room::getId)
                            .filter(id -> isRoomFree(id, candidate, occupied))
                            .toList();

                    adjacency.put(vertexId, roomIds);
                }

                Map<Long, Long> roomToVertex = new HashMap<>();
                for (Long vertexId : vertexIds) {
                    tryAugment(vertexId, adjacency, roomToVertex, new HashSet<>());
                }

                for (Long vertexId : vertexIds) {
                    Long matchedRoomId = findRoomForVertex(roomToVertex, vertexId);
                    if (matchedRoomId == null) {
                        unplaced.add(vertexId);
                        continue;
                    }

                    SchedulingCandidateGenerator.TimeCandidate candidate = selectedTimes.get(vertexId);
                    occupyRoom(matchedRoomId, candidate, occupied);
                    Room room = findRoomById(allRooms, matchedRoomId);

                    placed.put(vertexId, new CpSatScheduler.ScheduledSlot(
                            candidate.day(),
                            candidate.startTime(),
                            vertexById.get(vertexId).getDurationHours(),
                            room
                    ));
                }
            }
        }

        return new RoomAssignmentResult(placed, unplaced);
    }

    private boolean tryAugment(
            Long vertexId,
            Map<Long, List<Long>> adjacency,
            Map<Long, Long> roomToVertex,
            Set<Long> visitedRooms
    ) {
        for (Long roomId : adjacency.getOrDefault(vertexId, Collections.emptyList())) {
            if (!visitedRooms.add(roomId)) continue;

            Long currentVertex = roomToVertex.get(roomId);
            if (currentVertex == null || tryAugment(currentVertex, adjacency, roomToVertex, visitedRooms)) {
                roomToVertex.put(roomId, vertexId);
                return true;
            }
        }
        return false;
    }

    private Long findRoomForVertex(Map<Long, Long> roomToVertex, Long vertexId) {
        for (Map.Entry<Long, Long> entry : roomToVertex.entrySet()) {
            if (Objects.equals(entry.getValue(), vertexId)) return entry.getKey();
        }
        return null;
    }

    private boolean isRoomFree(Long roomId, SchedulingCandidateGenerator.TimeCandidate candidate, Set<RoomOccupancyKey> occupied) {
        for (LocalTime slotTime : candidate.coveredSlots()) {
            if (occupied.contains(new RoomOccupancyKey(roomId, candidate.day(), slotTime))) return false;
        }
        return true;
    }

    private void occupyRoom(Long roomId, SchedulingCandidateGenerator.TimeCandidate candidate, Set<RoomOccupancyKey> occupied) {
        for (LocalTime slotTime : candidate.coveredSlots()) {
            occupied.add(new RoomOccupancyKey(roomId, candidate.day(), slotTime));
        }
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
