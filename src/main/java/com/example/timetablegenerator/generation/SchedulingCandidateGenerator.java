package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
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

    private static final LocalTime LUNCH_BAND_START = LocalTime.of(12, 0);
    private static final LocalTime LUNCH_BAND_END = LocalTime.of(14, 0);

    public CandidateContext build(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> slotsByDay
    ) {
        Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots = normalizeSlots(slotsByDay);
        Map<Long, List<TimeCandidate>> candidatesByVertex = precomputeCandidates(vertices, allRooms, normalizedSlots);
        return new CandidateContext(normalizedSlots, candidatesByVertex);
    }

    private Map<Long, List<TimeCandidate>> precomputeCandidates(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots
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

                Set<Integer> lunchSlotIndexes = deriveLunchSlotIndexes(daySlots);

                for (int startIdx = 0; startIdx < daySlots.size(); startIdx++) {
                    if (!isValidBlock(daySlots, startIdx, vertex.getDurationHours())) continue;
                    if (blocksEntireLunchWindow(daySlots, startIdx, vertex.getDurationHours(), lunchSlotIndexes)) continue;

                    CpSatScheduler.TimeSlotInfo startSlot = daySlots.get(startIdx);
                    if (!isShiftCompatible(vertex.getShift(), startSlot.startTime())) continue;
                    if (isExcludedByTimeRule(vertex, day, daySlots, startIdx, vertex.getDurationHours())) continue;

                    int softScore = estimateCandidateSoftScore(vertex, day, startSlot.startTime());

                    candidates.add(new TimeCandidate(
                            day,
                            startIdx,
                            startSlot.startTime(),
                            coveredSlots(daySlots, startIdx, vertex.getDurationHours()),
                            allowedRooms,
                            softScore
                    ));
                }
            }

            candidates.sort(Comparator.comparingInt(TimeCandidate::softScore)
                    .thenComparing(TimeCandidate::day)
                    .thenComparing(TimeCandidate::startTime));

            int limit = candidateLimitFor(vertex);
            if (candidates.size() > limit) {
                candidates = new ArrayList<>(candidates.subList(0, limit));
            }

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

        log.info("Vertices by duration={}", byDuration);
        log.info("Zero-candidate vertices by duration={}", zeroCandidatesByDuration);

        return result;
    }

    private int candidateLimitFor(LessonVertex vertex) {
        if (vertex.getDurationHours() >= 4) return 42;
        if (vertex.getDurationHours() == 2) return 66;
        return 30;
    }

    private int estimateCandidateSoftScore(LessonVertex vertex, DayOfWeek day, LocalTime startTime) {
        int score = 0;

        if (vertex.getPreferredDays() != null
                && !vertex.getPreferredDays().isEmpty()
                && !vertex.getPreferredDays().contains(day)) {
            score += 15;
        }

        if (day == DayOfWeek.SATURDAY) score += 40;
        if (!startTime.isBefore(LocalTime.of(16, 0))) score += 25;
        else if (!startTime.isBefore(LocalTime.NOON)) score += 10;

        return score;
    }

    public List<Room> filterRoomsByConstraints(List<Room> allRooms, LessonVertex vertex) {
        List<Room> result = new ArrayList<>();

        for (Room room : allRooms) {
            if (vertex.getSpecificRoomId() != null && !Objects.equals(room.getId(), vertex.getSpecificRoomId())) {
                continue;
            }
            if (vertex.getRoomTypeRequired() != null
                    && vertex.getRoomTypeRequired() != RoomType.ANY
                    && room.getType() != vertex.getRoomTypeRequired()) {
                continue;
            }
            result.add(room);
        }

        result.sort(Comparator.comparing(Room::getId));
        return result;
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

    private Set<Integer> deriveLunchSlotIndexes(List<CpSatScheduler.TimeSlotInfo> daySlots) {
        Set<Integer> result = new LinkedHashSet<>();

        for (int i = 0; i < daySlots.size(); i++) {
            CpSatScheduler.TimeSlotInfo slot = daySlots.get(i);

            boolean insideLunchBand =
                    !slot.startTime().isBefore(LUNCH_BAND_START) &&
                            !slot.endTime().isAfter(LUNCH_BAND_END);

            if (insideLunchBand) {
                result.add(i);
            }
        }

        if (result.isEmpty()) {
            for (int i = 0; i < daySlots.size(); i++) {
                CpSatScheduler.TimeSlotInfo slot = daySlots.get(i);

                boolean overlapsLunchBand =
                        slot.startTime().isBefore(LUNCH_BAND_END) &&
                                slot.endTime().isAfter(LUNCH_BAND_START);

                if (overlapsLunchBand) {
                    result.add(i);
                }
            }
        }

        return result;
    }

    private boolean blocksEntireLunchWindow(
            List<CpSatScheduler.TimeSlotInfo> daySlots,
            int startIdx,
            int durationSlots,
            Set<Integer> lunchSlotIndexes
    ) {
        if (lunchSlotIndexes.isEmpty()) {
            return false;
        }

        Set<Integer> coveredIndexes = new HashSet<>();
        for (int i = 0; i < durationSlots; i++) {
            coveredIndexes.add(startIdx + i);
        }

        return coveredIndexes.containsAll(lunchSlotIndexes);
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
}