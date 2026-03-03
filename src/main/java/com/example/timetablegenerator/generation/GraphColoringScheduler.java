package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class GraphColoringScheduler {

    public record ScheduledSlot(DayOfWeek day, LocalTime startTime, int durationHours, Room room) {}

    public record TimeSlotInfo(LocalTime startTime, LocalTime endTime) {}

    public Map<Long, ScheduledSlot> schedule(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<TimeSlotInfo>> slotsByDay) {

        Map<Long, ScheduledSlot> result = new HashMap<>();
        List<LessonVertex> uncolored = new ArrayList<>(vertices);
        uncolored.sort((v1, v2) -> Integer.compare(v2.getDegree(), v1.getDegree()));

        Set<String> occupied = new HashSet<>();

        for (LessonVertex vertex : uncolored) {
            boolean placed = false;

            // Дни, в которые можно проводить (исключая запрещённые)
            List<DayOfWeek> possibleDays = Arrays.stream(DayOfWeek.values())
                    .filter(d -> !vertex.getExcludedDays().contains(d))
                    .toList();

            for (DayOfWeek day : possibleDays) {
                List<TimeSlotInfo> daySlots = slotsByDay.getOrDefault(day, Collections.emptyList());
                if (daySlots.isEmpty()) continue;

                // Находим все возможные начальные индексы для последовательности нужной длины
                List<Integer> possibleStartIndices = findPossibleStartIndices(daySlots, vertex.getDurationHours(), vertex, day);
                if (possibleStartIndices.isEmpty()) continue;

                for (int startIdx : possibleStartIndices) {
                    // Проверяем доступность преподавателя и групп во всех слотах последовательности
                    boolean teacherFree = true;
                    boolean groupsFree = true;

                    for (int j = 0; j < vertex.getDurationHours(); j++) {
                        TimeSlotInfo slot = daySlots.get(startIdx + j);
                        LocalTime time = slot.startTime();

                        if (occupied.contains(resourceKey("teacher", vertex.getTeacherId(), day, time))) {
                            teacherFree = false;
                            break;
                        }

                        for (Long gid : vertex.getGroupIds()) {
                            if (occupied.contains(resourceKey("group", gid, day, time))) {
                                groupsFree = false;
                                break;
                            }
                        }
                        if (!groupsFree) break;
                    }
                    if (!teacherFree || !groupsFree) continue;

                    // Перебираем комнаты
                    List<Room> possibleRooms = filterRoomsByConstraints(allRooms, vertex);
                    for (Room room : possibleRooms) {
                        boolean roomFree = true;
                        for (int j = 0; j < vertex.getDurationHours(); j++) {
                            TimeSlotInfo slot = daySlots.get(startIdx + j);
                            LocalTime time = slot.startTime();
                            if (occupied.contains(resourceKey("room", room.getId(), day, time))) {
                                roomFree = false;
                                break;
                            }
                        }
                        if (!roomFree) continue;

                        // Нашли подходящий слот
                        ScheduledSlot scheduled = new ScheduledSlot(day, daySlots.get(startIdx).startTime(),
                                vertex.getDurationHours(), room);
                        result.put(vertex.getId(), scheduled);

                        // Помечаем ресурсы занятыми
                        for (int j = 0; j < vertex.getDurationHours(); j++) {
                            TimeSlotInfo slot = daySlots.get(startIdx + j);
                            LocalTime time = slot.startTime();
                            occupied.add(resourceKey("teacher", vertex.getTeacherId(), day, time));
                            for (Long gid : vertex.getGroupIds()) {
                                occupied.add(resourceKey("group", gid, day, time));
                            }
                            occupied.add(resourceKey("room", room.getId(), day, time));
                        }

                        placed = true;
                        break;
                    }
                    if (placed) break;
                }
                if (placed) break;
            }

            if (!placed) {
                log.warn("Не удалось разместить вершину assignmentId={}, teacherId={}, groups={}",
                        vertex.getAssignmentId(), vertex.getTeacherId(), vertex.getGroupIds());
                result.put(vertex.getId(), null);
            }
        }

        return result;
    }

    /**
     * Находит все возможные начальные индексы для последовательности слотов заданной длины,
     * удовлетворяющие ограничениям по исключённым временам и смене.
     */
    private List<Integer> findPossibleStartIndices(List<TimeSlotInfo> daySlots, int durationHours,
                                                   LessonVertex vertex, DayOfWeek day) {
        List<Integer> result = new ArrayList<>();
        int n = daySlots.size();

        for (int i = 0; i <= n - durationHours; i++) {
            // Проверяем, что ни один из слотов последовательности не попадает в исключённое время
            boolean excluded = false;
            for (int j = 0; j < durationHours; j++) {
                TimeSlotInfo slot = daySlots.get(i + j);
                if (isExcludedByTime(vertex, day, slot.startTime(), slot.endTime())) {
                    excluded = true;
                    break;
                }
            }
            if (excluded) continue;

            // Проверка совместимости со сменой (достаточно по первому слоту)
            if (!isShiftCompatible(vertex.getShift(), daySlots.get(i).startTime())) {
                continue;
            }

            result.add(i);
        }
        return result;
    }

    private boolean isExcludedByTime(LessonVertex vertex, DayOfWeek day, LocalTime start, LocalTime end) {
        if (vertex.getExcludedTimeSlots() == null) return false;
        for (TimeSlotExclusion excl : vertex.getExcludedTimeSlots()) {
            if (excl.getDay() == day) {
                LocalTime exclStart = LocalTime.parse(excl.getStartTime());
                LocalTime exclEnd = LocalTime.parse(excl.getEndTime());
                // Проверяем пересечение интервалов [start, end) и [exclStart, exclEnd)
                if (start.isBefore(exclEnd) && end.isAfter(exclStart)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean isShiftCompatible(Shift shift, LocalTime startTime) {
        if (shift == null || shift == Shift.ANY) return true;
        boolean isMorning = startTime.isBefore(LocalTime.NOON);
        return (shift == Shift.MORNING && isMorning) ||
                (shift == Shift.AFTERNOON && !isMorning);
    }

    private String resourceKey(String type, Long id, DayOfWeek day, LocalTime time) {
        return type + ":" + id + ":" + day + ":" + time;
    }

    private List<Room> filterRoomsByConstraints(List<Room> allRooms, LessonVertex vertex) {
        if (vertex.getSpecificRoomId() != null) {
            return allRooms.stream()
                    .filter(r -> r.getId().equals(vertex.getSpecificRoomId()))
                    .filter(r -> vertex.getRoomTypeRequired() == RoomType.ANY || r.getType() == vertex.getRoomTypeRequired())
                    .collect(Collectors.toList());
        }
        return allRooms.stream()
                .filter(r -> vertex.getRoomTypeRequired() == RoomType.ANY || r.getType() == vertex.getRoomTypeRequired())
                .collect(Collectors.toList());
    }
}