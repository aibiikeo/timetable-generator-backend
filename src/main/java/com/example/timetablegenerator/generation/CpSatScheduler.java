package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import com.google.ortools.Loader;
import com.google.ortools.sat.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
public class CpSatScheduler {

    static {
        Loader.loadNativeLibraries();
    }

    public record ScheduledSlot(DayOfWeek day, LocalTime startTime, int durationHours, Room room) {}
    public record TimeSlotInfo(LocalTime startTime, LocalTime endTime) {}
    public record SchedulingResult(Map<Long, ScheduledSlot> placed, Set<Long> unplacedVertexIds) {}

    private record TimeVarKey(Long vertexId, DayOfWeek day, LocalTime startTime) {}
    private record ResourceTimeKey(Long resourceId, DayOfWeek day, LocalTime slotTime) {}
    private record TimeCandidate(
            DayOfWeek day,
            int startIndex,
            LocalTime startTime,
            List<LocalTime> coveredSlots,
            List<Room> allowedRooms
    ) {}

    private static final int PENALTY_UNPLACED = 10_000;
    private static final int PENALTY_NON_PREFERRED_DAY = 10;
    private static final int PENALTY_AFTERNOON = 15;
    private static final int PENALTY_LATE_EVENING = 40;
    private static final int PENALTY_SATURDAY = 200;

    private static final List<DayOfWeek> TEACHING_DAYS = List.of(
            DayOfWeek.MONDAY,
            DayOfWeek.TUESDAY,
            DayOfWeek.WEDNESDAY,
            DayOfWeek.THURSDAY,
            DayOfWeek.FRIDAY,
            DayOfWeek.SATURDAY
    );

    public SchedulingResult schedule(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<TimeSlotInfo>> slotsByDay
    ) {
        Map<DayOfWeek, List<TimeSlotInfo>> normalizedSlots = normalizeSlots(slotsByDay);

        Map<Long, List<TimeCandidate>> candidatesByVertex =
                precomputeCandidates(vertices, allRooms, normalizedSlots);

        CpModel model = new CpModel();

        Map<TimeVarKey, BoolVar> timeVars = new HashMap<>();
        Map<Long, BoolVar> unplacedVars = new HashMap<>();
        List<LinearExpr> objectiveTerms = new ArrayList<>();

        Map<ResourceTimeKey, List<Literal>> teacherOccupancy = new HashMap<>();
        Map<ResourceTimeKey, List<Literal>> groupOccupancy = new HashMap<>();

        int totalCandidateCount = 0;

        for (LessonVertex vertex : vertices) {
            BoolVar unplaced = model.newBoolVar("unplaced_v_" + vertex.getId());
            unplacedVars.put(vertex.getId(), unplaced);
            objectiveTerms.add(LinearExpr.term(unplaced, PENALTY_UNPLACED));

            List<Literal> chooseOne = new ArrayList<>();
            List<TimeCandidate> candidates = candidatesByVertex.getOrDefault(vertex.getId(), Collections.emptyList());
            totalCandidateCount += candidates.size();

            for (TimeCandidate candidate : candidates) {
                String varName = "y_v" + vertex.getId()
                        + "_d" + candidate.day()
                        + "_t" + candidate.startTime();

                BoolVar var = model.newBoolVar(varName);
                TimeVarKey key = new TimeVarKey(vertex.getId(), candidate.day(), candidate.startTime());
                timeVars.put(key, var);
                chooseOne.add(var);

                indexTeacherOccupancy(teacherOccupancy, vertex, candidate, var);
                indexGroupOccupancy(groupOccupancy, vertex, candidate, var);

                if (vertex.getPreferredDays() != null
                        && !vertex.getPreferredDays().isEmpty()
                        && !vertex.getPreferredDays().contains(candidate.day())) {
                    objectiveTerms.add(LinearExpr.term(var, PENALTY_NON_PREFERRED_DAY));
                }

                if (candidate.day() == DayOfWeek.SATURDAY) {
                    objectiveTerms.add(LinearExpr.term(var, PENALTY_SATURDAY));
                }

                if (!candidate.startTime().isBefore(LocalTime.of(16, 0))) {
                    objectiveTerms.add(LinearExpr.term(var, PENALTY_LATE_EVENING));
                } else if (!candidate.startTime().isBefore(LocalTime.NOON)) {
                    objectiveTerms.add(LinearExpr.term(var, PENALTY_AFTERNOON));
                }
            }

            chooseOne.add(unplaced);
            model.addExactlyOne(chooseOne);
        }

        addAtMostOneConstraints(model, teacherOccupancy);
        addAtMostOneConstraints(model, groupOccupancy);

        model.minimize(LinearExpr.sum(objectiveTerms.toArray(new LinearExpr[0])));

        log.info(
                "CP-SAT model stats: vertices={}, candidateTimes={}, timeVars={}, teacherBuckets={}, groupBuckets={}",
                vertices.size(),
                totalCandidateCount,
                timeVars.size(),
                teacherOccupancy.size(),
                groupOccupancy.size()
        );

        CpSolver solver = new CpSolver();
        solver.getParameters().setMaxTimeInSeconds(15.0);
        solver.getParameters().setNumSearchWorkers(4);

        long startedAt = System.currentTimeMillis();
        CpSolverStatus status = solver.solve(model);
        long elapsedMs = System.currentTimeMillis() - startedAt;

        log.info(
                "CP-SAT solve finished: status={}, wallTimeMs={}, objective={}",
                status,
                elapsedMs,
                (status == CpSolverStatus.OPTIMAL || status == CpSolverStatus.FEASIBLE) ? solver.objectiveValue() : null
        );

        if (status != CpSolverStatus.OPTIMAL && status != CpSolverStatus.FEASIBLE) {
            log.warn("CP-SAT did not produce a usable solution. status={}", status);
            Set<Long> allUnplaced = vertices.stream()
                    .map(LessonVertex::getId)
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            return new SchedulingResult(Collections.emptyMap(), allUnplaced);
        }

        Map<Long, TimeCandidate> selectedTimes = extractSelectedTimes(vertices, candidatesByVertex, timeVars, solver);
        Set<Long> unplaced = extractSolverUnplaced(vertices, unplacedVars, solver);

        RoomAssignmentResult roomAssignment = assignRoomsGreedy(selectedTimes, vertices, allRooms);

        Map<Long, ScheduledSlot> placed = new LinkedHashMap<>(roomAssignment.placed());

        unplaced.addAll(roomAssignment.unplacedAfterRoomAssignment());

        for (LessonVertex vertex : vertices) {
            if (!placed.containsKey(vertex.getId()) && !unplaced.contains(vertex.getId())) {
                unplaced.add(vertex.getId());
            }
        }

        return new SchedulingResult(placed, unplaced);
    }

    private Map<Long, List<TimeCandidate>> precomputeCandidates(
            List<LessonVertex> vertices,
            List<Room> allRooms,
            Map<DayOfWeek, List<TimeSlotInfo>> normalizedSlots
    ) {
        Map<Long, List<TimeCandidate>> result = new HashMap<>();

        for (LessonVertex vertex : vertices) {
            List<Room> allowedRooms = filterRoomsByConstraints(allRooms, vertex);
            List<TimeCandidate> candidates = new ArrayList<>();

            if (allowedRooms.isEmpty()) {
                result.put(vertex.getId(), candidates);
                continue;
            }

            for (DayOfWeek day : TEACHING_DAYS) {
                if (vertex.getExcludedDays() != null && vertex.getExcludedDays().contains(day)) {
                    continue;
                }

                List<TimeSlotInfo> daySlots = normalizedSlots.getOrDefault(day, Collections.emptyList());
                if (daySlots.isEmpty()) {
                    continue;
                }

                for (int startIdx = 0; startIdx < daySlots.size(); startIdx++) {
                    if (!isValidBlock(daySlots, startIdx, vertex.getDurationHours())) {
                        continue;
                    }

                    TimeSlotInfo startSlot = daySlots.get(startIdx);

                    if (!isShiftCompatible(vertex.getShift(), startSlot.startTime())) {
                        continue;
                    }

                    if (isExcludedByTimeRule(vertex, day, startSlot.startTime(), vertex.getDurationHours())) {
                        continue;
                    }

                    candidates.add(new TimeCandidate(
                            day,
                            startIdx,
                            startSlot.startTime(),
                            coveredSlots(daySlots, startIdx, vertex.getDurationHours()),
                            allowedRooms
                    ));
                }
            }

            result.put(vertex.getId(), candidates);
        }

        Map<Integer, Long> byDuration = vertices.stream()
                .collect(Collectors.groupingBy(LessonVertex::getDurationHours, Collectors.counting()));

        Map<Integer, Long> zeroCandidatesByDuration = new HashMap<>();
        for (LessonVertex vertex : vertices) {
            int duration = vertex.getDurationHours();
            long current = zeroCandidatesByDuration.getOrDefault(duration, 0L);
            if (result.get(vertex.getId()).isEmpty()) {
                zeroCandidatesByDuration.put(duration, current + 1);
            }
        }

        log.info("Vertices by duration={}", byDuration);
        log.info("Zero-candidate vertices by duration={}", zeroCandidatesByDuration);

        return result;
    }

    private void indexTeacherOccupancy(
            Map<ResourceTimeKey, List<Literal>> teacherOccupancy,
            LessonVertex vertex,
            TimeCandidate candidate,
            BoolVar var
    ) {
        if (vertex.getTeacherId() == null) return;

        for (LocalTime coveredSlot : candidate.coveredSlots()) {
            ResourceTimeKey key = new ResourceTimeKey(vertex.getTeacherId(), candidate.day(), coveredSlot);
            teacherOccupancy.computeIfAbsent(key, _k -> new ArrayList<>()).add(var);
        }
    }

    private void indexGroupOccupancy(
            Map<ResourceTimeKey, List<Literal>> groupOccupancy,
            LessonVertex vertex,
            TimeCandidate candidate,
            BoolVar var
    ) {
        if (vertex.getGroupIds() == null || vertex.getGroupIds().isEmpty()) return;

        for (Long groupId : vertex.getGroupIds()) {
            for (LocalTime coveredSlot : candidate.coveredSlots()) {
                ResourceTimeKey key = new ResourceTimeKey(groupId, candidate.day(), coveredSlot);
                groupOccupancy.computeIfAbsent(key, _k -> new ArrayList<>()).add(var);
            }
        }
    }

    private void addAtMostOneConstraints(
            CpModel model,
            Map<ResourceTimeKey, List<Literal>> occupancy
    ) {
        for (Map.Entry<ResourceTimeKey, List<Literal>> entry : occupancy.entrySet()) {
            List<Literal> vars = entry.getValue();
            if (vars.size() > 1) {
                model.addAtMostOne(vars);
            }
        }
    }

    private Map<Long, TimeCandidate> extractSelectedTimes(
            List<LessonVertex> vertices,
            Map<Long, List<TimeCandidate>> candidatesByVertex,
            Map<TimeVarKey, BoolVar> timeVars,
            CpSolver solver
    ) {
        Map<Long, TimeCandidate> selected = new HashMap<>();

        for (LessonVertex vertex : vertices) {
            for (TimeCandidate candidate : candidatesByVertex.getOrDefault(vertex.getId(), Collections.emptyList())) {
                TimeVarKey key = new TimeVarKey(vertex.getId(), candidate.day(), candidate.startTime());
                BoolVar var = timeVars.get(key);
                if (var != null && solver.booleanValue(var)) {
                    selected.put(vertex.getId(), candidate);
                    break;
                }
            }
        }

        return selected;
    }

    private Set<Long> extractSolverUnplaced(
            List<LessonVertex> vertices,
            Map<Long, BoolVar> unplacedVars,
            CpSolver solver
    ) {
        Set<Long> unplaced = new LinkedHashSet<>();

        for (LessonVertex vertex : vertices) {
            BoolVar unplacedVar = unplacedVars.get(vertex.getId());
            if (unplacedVar != null && solver.booleanValue(unplacedVar)) {
                unplaced.add(vertex.getId());
            }
        }

        return unplaced;
    }

    private record RoomAssignmentResult(
            Map<Long, ScheduledSlot> placed,
            Set<Long> unplacedAfterRoomAssignment
    ) {}

    private record TimeGroupKey(DayOfWeek day, LocalTime startTime, int durationHours) {}

    private RoomAssignmentResult assignRoomsGreedy(
            Map<Long, TimeCandidate> selectedTimes,
            List<LessonVertex> vertices,
            List<Room> allRooms
    ) {
        Map<Long, LessonVertex> vertexById = vertices.stream()
                .collect(Collectors.toMap(LessonVertex::getId, v -> v));

        Map<TimeGroupKey, List<Long>> grouped = new LinkedHashMap<>();
        for (Map.Entry<Long, TimeCandidate> entry : selectedTimes.entrySet()) {
            Long vertexId = entry.getKey();
            TimeCandidate candidate = entry.getValue();
            LessonVertex vertex = vertexById.get(vertexId);

            TimeGroupKey key = new TimeGroupKey(candidate.day(), candidate.startTime(), vertex.getDurationHours());
            grouped.computeIfAbsent(key, _k -> new ArrayList<>()).add(vertexId);
        }

        Map<Long, ScheduledSlot> placed = new LinkedHashMap<>();
        Set<Long> unplaced = new LinkedHashSet<>();

        for (Map.Entry<TimeGroupKey, List<Long>> entry : grouped.entrySet()) {
            TimeGroupKey key = entry.getKey();
            List<Long> vertexIds = new ArrayList<>(entry.getValue());

            vertexIds.sort(roomPriorityComparator(vertexById, allRooms));

            Set<Long> usedRoomIds = new HashSet<>();

            for (Long vertexId : vertexIds) {
                LessonVertex vertex = vertexById.get(vertexId);
                List<Room> allowedRooms = filterRoomsByConstraints(allRooms, vertex);

                Room chosen = null;
                for (Room room : allowedRooms) {
                    if (!usedRoomIds.contains(room.getId())) {
                        chosen = room;
                        break;
                    }
                }

                if (chosen == null) {
                    unplaced.add(vertexId);
                    continue;
                }

                usedRoomIds.add(chosen.getId());
                placed.put(vertexId, new ScheduledSlot(
                        key.day(),
                        key.startTime(),
                        key.durationHours(),
                        chosen
                ));
            }
        }

        return new RoomAssignmentResult(placed, unplaced);
    }

    private Comparator<Long> roomPriorityComparator(
            Map<Long, LessonVertex> vertexById,
            List<Room> allRooms
    ) {
        Map<RoomType, Long> roomTypeCounts = allRooms.stream()
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

    private List<LocalTime> coveredSlots(
            List<TimeSlotInfo> daySlots,
            int startIdx,
            int durationHours
    ) {
        List<LocalTime> result = new ArrayList<>(durationHours);
        for (int i = 0; i < durationHours; i++) {
            result.add(daySlots.get(startIdx + i).startTime());
        }
        return result;
    }

    private boolean isValidBlock(List<TimeSlotInfo> daySlots, int startIdx, int durationHours) {
        return startIdx + durationHours <= daySlots.size();
    }

    private boolean isExcludedByTimeRule(
            LessonVertex vertex,
            DayOfWeek day,
            LocalTime startTime,
            int durationHours
    ) {
        if (vertex.getExcludedTimeSlots() == null || vertex.getExcludedTimeSlots().isEmpty()) {
            return false;
        }

        LocalTime endTime = startTime.plusHours(durationHours);

        for (TimeSlotExclusion exclusion : vertex.getExcludedTimeSlots()) {
            if (exclusion.getDay() != day) {
                continue;
            }

            LocalTime excludedStart = LocalTime.parse(exclusion.getStartTime());
            LocalTime excludedEnd = LocalTime.parse(exclusion.getEndTime());

            boolean overlaps = startTime.isBefore(excludedEnd) && endTime.isAfter(excludedStart);
            if (overlaps) {
                return true;
            }
        }

        return false;
    }

    private boolean isShiftCompatible(Shift shift, LocalTime startTime) {
        if (shift == null || shift == Shift.ANY) {
            return true;
        }

        boolean isMorning = startTime.isBefore(LocalTime.NOON);

        return (shift == Shift.MORNING && isMorning)
                || (shift == Shift.AFTERNOON && !isMorning);
    }

    private List<Room> filterRoomsByConstraints(List<Room> allRooms, LessonVertex vertex) {
        List<Room> result = new ArrayList<>();

        for (Room room : allRooms) {
            if (vertex.getSpecificRoomId() != null
                    && !Objects.equals(room.getId(), vertex.getSpecificRoomId())) {
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

    private Map<DayOfWeek, List<TimeSlotInfo>> normalizeSlots(Map<DayOfWeek, List<TimeSlotInfo>> slotsByDay) {
        Map<DayOfWeek, List<TimeSlotInfo>> result = new EnumMap<>(DayOfWeek.class);

        for (DayOfWeek day : TEACHING_DAYS) {
            List<TimeSlotInfo> sorted = new ArrayList<>(slotsByDay.getOrDefault(day, Collections.emptyList()));
            sorted.sort(Comparator.comparing(TimeSlotInfo::startTime));
            result.put(day, sorted);
        }

        return result;
    }
}