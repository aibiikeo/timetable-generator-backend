package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
public class SchedulingCandidateGenerator {

    public record TimeCandidate(
            DayOfWeek day,
            int startIndex,
            LocalTime startTime,
            List<LocalTime> coveredSlots,
            List<Room> allowedRooms,
            int softScore
    ) {}

    public record CandidateContext(
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots,
            Map<Long, List<TimeCandidate>> candidatesByVertex
    ) {}

    private static final List<DayOfWeek> TEACHING_DAYS = List.of(
            DayOfWeek.MONDAY,
            DayOfWeek.TUESDAY,
            DayOfWeek.WEDNESDAY,
            DayOfWeek.THURSDAY,
            DayOfWeek.FRIDAY,
            DayOfWeek.SATURDAY
    );

    public CandidateContext build(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay
    ) {
        return build(vertices, allRooms, slotsByDay, Collections.emptyList());
    }

    public CandidateContext build(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay,
            List<Lesson> fixedLessons
    ) {
        Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots = normalizeSlots(slotsByDay);
        FixedOccupancy fixedOccupancy = FixedOccupancy.from(fixedLessons, normalizedSlots);
        Map<Long, List<TimeCandidate>> candidatesByVertex =
                precomputeCandidates(vertices, allRooms, normalizedSlots, fixedOccupancy);
        return new CandidateContext(normalizedSlots, candidatesByVertex);
    }

    private Map<Long, List<TimeCandidate>> precomputeCandidates(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots,
            FixedOccupancy fixedOccupancy
    ) {
        Map<Long, List<TimeCandidate>> result = new HashMap<>();

        for (LessonVertex vertex : vertices) {
            List<Room> allowedRooms = filterRoomsByConstraints(allRooms, vertex);
            if (allowedRooms.isEmpty()) {
                result.put(vertex.getId(), Collections.emptyList());
                continue;
            }

            List<TimeCandidate> candidates = new ArrayList<>();

            for (DayOfWeek day : TEACHING_DAYS) {
                if (vertex.getExcludedDays() != null && vertex.getExcludedDays().contains(day)) {
                    continue;
                }

                List<CpSatScheduler.TimeSlotInfo> daySlots = normalizedSlots.getOrDefault(day, Collections.emptyList());
                if (daySlots.isEmpty()) continue;

                for (int startIdx = 0; startIdx < daySlots.size(); startIdx++) {
                    if (!isValidBlock(daySlots, startIdx, vertex.getDurationHours())) continue;

                    CpSatScheduler.TimeSlotInfo startSlot = daySlots.get(startIdx);
                    if (!isShiftCompatible(vertex.getShift(), startSlot.startTime())) continue;
                    if (isExcludedByTimeRule(vertex, day, daySlots, startIdx, vertex.getDurationHours())) continue;

                    List<LocalTime> coveredSlots = coveredSlots(daySlots, startIdx, vertex.getDurationHours());
                    if (conflictsWithFixedLessons(vertex, day, coveredSlots, fixedOccupancy)) continue;

                    List<Room> roomsAvailableForTime = allowedRooms.stream()
                            .filter(room -> isRoomFreeForFixedLessons(room, day, coveredSlots, fixedOccupancy))
                            .toList();
                    if (roomsAvailableForTime.isEmpty()) continue;

                    int softScore = estimateCandidateSoftScore(vertex, day, startSlot.startTime());

                    candidates.add(new TimeCandidate(
                            day,
                            startIdx,
                            startSlot.startTime(),
                            coveredSlots,
                            roomsAvailableForTime,
                            softScore
                    ));
                }
            }

            candidates.sort(Comparator.comparingInt(TimeCandidate::softScore)
                    .thenComparing(TimeCandidate::day)
                    .thenComparing(TimeCandidate::startTime));

            result.put(vertex.getId(), candidates);
        }

        Map<Integer, Long> byDuration = vertices.stream()
                .collect(Collectors.groupingBy(LessonVertex::getDurationHours, Collectors.counting()));

        Map<Integer, Long> zeroCandidatesByDuration = new TreeMap<>();
        for (LessonVertex vertex : vertices) {
            if (result.getOrDefault(vertex.getId(), Collections.emptyList()).isEmpty()) {
                zeroCandidatesByDuration.merge(vertex.getDurationHours(), 1L, Long::sum);
            }
        }

        log.info("app | Vertices by duration={}", byDuration);
        log.info("app | Zero-candidate vertices by duration={}", zeroCandidatesByDuration);

        return result;
    }

    private int estimateCandidateSoftScore(LessonVertex vertex, DayOfWeek day, LocalTime startTime) {
        int score = 0;

        if (vertex.getPreferredDays() != null
                && !vertex.getPreferredDays().isEmpty()
                && !vertex.getPreferredDays().contains(day)) {
            score += 15;
        }

        if (day == DayOfWeek.SATURDAY) score += 9_500;
        if (!startTime.isBefore(LocalTime.of(16, 0))) score += 25;
        else if (!startTime.isBefore(LocalTime.NOON)) score += 10;

        return score;
    }

    public List<Room> filterRoomsByConstraints(List<Room> allRooms, LessonVertex vertex) {
        List<Room> typeCompatibleRooms = new ArrayList<>();

        for (Room room : allRooms) {
            if (vertex.getSpecificRoomId() != null && !Objects.equals(room.getId(), vertex.getSpecificRoomId())) {
                continue;
            }
            if (vertex.getRoomTypeRequired() != null
                    && vertex.getRoomTypeRequired() != RoomType.ANY
                    && room.getType() != vertex.getRoomTypeRequired()) {
                continue;
            }

            typeCompatibleRooms.add(room);
        }

        List<Room> capacityCompatibleRooms = typeCompatibleRooms.stream()
                .filter(room -> hasRequiredCapacity(room, vertex.getRoomCapacityRequired()))
                .toList();

        List<Room> result = capacityCompatibleRooms.isEmpty()
                ? new ArrayList<>(typeCompatibleRooms)
                : new ArrayList<>(capacityCompatibleRooms);

        result.sort(Comparator
                .comparing((Room room) -> !hasRequiredCapacity(room, vertex.getRoomCapacityRequired()))
                .thenComparing(Room::getId));
        return result;
    }

    private boolean hasRequiredCapacity(Room room, Integer requiredCapacity) {
        if (requiredCapacity == null || requiredCapacity <= 0) {
            return true;
        }

        return room.getCapacity() != null && room.getCapacity() >= requiredCapacity;
    }

    private Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizeSlots(
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay
    ) {
        Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> result = new EnumMap<>(DayOfWeek.class);
        for (DayOfWeek day : TEACHING_DAYS) {
            List<CpSatScheduler.TimeSlotInfo> sorted = new ArrayList<>(slotsByDay.getOrDefault(day, Collections.emptyList()));
            sorted.sort(Comparator.comparing(CpSatScheduler.TimeSlotInfo::startTime));
            result.put(day, sorted);
        }
        return result;
    }

    private List<LocalTime> coveredSlots(
            List<CpSatScheduler.TimeSlotInfo> daySlots,
            int startIdx,
            int durationHours
    ) {
        List<LocalTime> result = new ArrayList<>(durationHours);
        for (int i = 0; i < durationHours; i++) {
            result.add(daySlots.get(startIdx + i).startTime());
        }
        return result;
    }

    private boolean isValidBlock(List<CpSatScheduler.TimeSlotInfo> daySlots, int startIdx, int durationHours) {
        return startIdx + durationHours <= daySlots.size();
    }

    private boolean isExcludedByTimeRule(
            LessonVertex vertex,
            DayOfWeek day,
            List<CpSatScheduler.TimeSlotInfo> daySlots,
            int startIdx,
            int durationSlots
    ) {
        if (vertex.getExcludedTimeSlots() == null || vertex.getExcludedTimeSlots().isEmpty()) {
            return false;
        }

        LocalTime blockStart = daySlots.get(startIdx).startTime();
        LocalTime blockEnd = daySlots.get(startIdx + durationSlots - 1).endTime();

        for (TimeSlotExclusion exclusion : vertex.getExcludedTimeSlots()) {
            if (exclusion.getDay() != day) continue;

            LocalTime excludedStart = LocalTime.parse(exclusion.getStartTime());
            LocalTime excludedEnd = LocalTime.parse(exclusion.getEndTime());

            boolean overlaps = blockStart.isBefore(excludedEnd) && blockEnd.isAfter(excludedStart);
            if (overlaps) return true;
        }

        return false;
    }

    private boolean isShiftCompatible(Shift shift, LocalTime startTime) {
        if (shift == null || shift == Shift.ANY) return true;
        boolean isMorning = startTime.isBefore(LocalTime.NOON);
        return (shift == Shift.MORNING && isMorning)
                || (shift == Shift.AFTERNOON && !isMorning);
    }

    private boolean conflictsWithFixedLessons(
            LessonVertex vertex,
            DayOfWeek day,
            List<LocalTime> coveredSlots,
            FixedOccupancy fixedOccupancy
    ) {
        for (LocalTime slot : coveredSlots) {
            if (vertex.getTeacherId() != null
                    && fixedOccupancy.teacherBusy.contains(new ResourceTimeKey(vertex.getTeacherId(), day, slot))) {
                return true;
            }

            if (vertex.getGroupIds() != null) {
                for (Long groupId : vertex.getGroupIds()) {
                    if (fixedOccupancy.groupBusy.contains(new ResourceTimeKey(groupId, day, slot))) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    private boolean isRoomFreeForFixedLessons(
            Room room,
            DayOfWeek day,
            List<LocalTime> coveredSlots,
            FixedOccupancy fixedOccupancy
    ) {
        if (room == null || room.getId() == null) {
            return true;
        }

        for (LocalTime slot : coveredSlots) {
            if (fixedOccupancy.roomBusy.contains(new ResourceTimeKey(room.getId(), day, slot))) {
                return false;
            }
        }

        return true;
    }

    private record ResourceTimeKey(Long resourceId, DayOfWeek day, LocalTime slotTime) {}

    private record FixedOccupancy(
            Set<ResourceTimeKey> teacherBusy,
            Set<ResourceTimeKey> groupBusy,
            Set<ResourceTimeKey> roomBusy
    ) {
        static FixedOccupancy from(
                List<Lesson> lessons,
                Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots
        ) {
            Set<ResourceTimeKey> teacherBusy = new HashSet<>();
            Set<ResourceTimeKey> groupBusy = new HashSet<>();
            Set<ResourceTimeKey> roomBusy = new HashSet<>();

            for (Lesson lesson : lessons) {
                for (LocalTime slot : coveredSlotsForFixedLesson(lesson, normalizedSlots)) {

                    if (lesson.getTeacher() != null && lesson.getTeacher().getId() != null) {
                        teacherBusy.add(new ResourceTimeKey(lesson.getTeacher().getId(), lesson.getDayOfWeek(), slot));
                    }

                    if (lesson.getRoom() != null && lesson.getRoom().getId() != null) {
                        roomBusy.add(new ResourceTimeKey(lesson.getRoom().getId(), lesson.getDayOfWeek(), slot));
                    }

                    if (lesson.getGroups() != null) {
                        for (StudyGroup group : lesson.getGroups()) {
                            if (group.getId() != null) {
                                groupBusy.add(new ResourceTimeKey(group.getId(), lesson.getDayOfWeek(), slot));
                            }
                        }
                    }
                }
            }

            return new FixedOccupancy(teacherBusy, groupBusy, roomBusy);
        }

        private static List<LocalTime> coveredSlotsForFixedLesson(
                Lesson lesson,
                Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots
        ) {
            List<CpSatScheduler.TimeSlotInfo> daySlots =
                    normalizedSlots.getOrDefault(lesson.getDayOfWeek(), Collections.emptyList());

            for (int i = 0; i < daySlots.size(); i++) {
                if (!daySlots.get(i).startTime().equals(lesson.getStartTime())) {
                    continue;
                }

                int endExclusive = Math.min(i + lesson.getDurationHours(), daySlots.size());
                List<LocalTime> result = new ArrayList<>();
                for (int j = i; j < endExclusive; j++) {
                    result.add(daySlots.get(j).startTime());
                }
                return result;
            }

            List<LocalTime> fallback = new ArrayList<>();
            for (int h = 0; h < lesson.getDurationHours(); h++) {
                fallback.add(lesson.getStartTime().plusHours(h));
            }
            return fallback;
        }
    }
}
