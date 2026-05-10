package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.google.ortools.sat.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
public class CpSatModel {

    public record SolveResult(
            Map<Long, SchedulingCandidateGenerator.TimeCandidate> selectedTimes,
            Set<Long> unplacedVertexIds
    ) {}

    private record TimeVarKey(Long vertexId, DayOfWeek day, LocalTime startTime) {}
    private record ResourceTimeKey(Long resourceId, DayOfWeek day, LocalTime slotTime) {}
    private record ResourceDayKey(Long resourceId, DayOfWeek day) {}
    private record AssignmentDayKey(Long assignmentId, DayOfWeek day) {}
    private record RoomPoolTimeKey(
            RoomType roomType,
            int minCapacity,
            DayOfWeek day,
            LocalTime slotTime
    ) {}
    private record PhaseOneBuild(
            CpModel model,
            Map<TimeVarKey, BoolVar> timeVars,
            Map<Long, BoolVar> unplacedVars,
            Map<ResourceTimeKey, List<BoolVar>> teacherOccupancy,
            Map<ResourceTimeKey, List<BoolVar>> groupOccupancy,
            Map<RoomPoolTimeKey, List<BoolVar>> roomPoolOccupancy,
            Map<AssignmentDayKey, List<BoolVar>> assignmentDayOccupancy,
            List<LinearExpr> softTerms
    ) {}

    private static final int BASE_UNPLACED = 10_000;
    private static final int PENALTY_NON_PREFERRED_DAY = 10;
    private static final int PENALTY_AFTERNOON = 15;
    private static final int PENALTY_LATE_EVENING = 40;
    private static final int PENALTY_SATURDAY = 200;
    private static final int PENALTY_ASSIGNMENT_SAME_DAY_REPEAT = 90;

    private static final int PENALTY_GROUP_GAP = 18;
    private static final int PENALTY_TEACHER_GAP = 12;
    private static final int PENALTY_GROUP_STRETCHED_DAY = 20;
    private static final int PENALTY_TEACHER_STRETCHED_DAY = 14;
    private static final int PENALTY_GROUP_DAILY_OVERLOAD = 10;
    private static final int PENALTY_TEACHER_DAILY_OVERLOAD = 6;

    private static final int GROUP_DAILY_LOAD_LIMIT = 4;
    private static final int TEACHER_DAILY_LOAD_LIMIT = 5;

    public SolveResult solve(
            List<LessonVertex> vertices,
            SchedulingCandidateGenerator.CandidateContext context,
            List<Room> allRooms
    ) {
        PhaseOneBuild build = buildModel(vertices, context, allRooms);

        addAtMostOneConstraints(build.model(), build.teacherOccupancy());
        addAtMostOneConstraints(build.model(), build.groupOccupancy());
        addRoomPoolCapacityConstraints(
                build.model(),
                build.roomPoolOccupancy(),
                allRooms
        );

        Map<ResourceTimeKey, BoolVar> teacherBusyVars = createBusyVars(build.model(), build.teacherOccupancy(), "teacher");
        Map<ResourceTimeKey, BoolVar> groupBusyVars = createBusyVars(build.model(), build.groupOccupancy(), "group");

        addSoftSameDayAssignmentPenalties(build.model(), build.assignmentDayOccupancy(), build.softTerms());
        addGapAndLongDayPenalties(build.model(), teacherBusyVars, context.normalizedSlots(), build.softTerms(), PENALTY_TEACHER_GAP, PENALTY_TEACHER_STRETCHED_DAY, "teacher");
        addGapAndLongDayPenalties(build.model(), groupBusyVars, context.normalizedSlots(), build.softTerms(), PENALTY_GROUP_GAP, PENALTY_GROUP_STRETCHED_DAY, "group");
        addDailyLoadBalancePenalties(build.model(), teacherBusyVars, context.normalizedSlots(), build.softTerms(), TEACHER_DAILY_LOAD_LIMIT, PENALTY_TEACHER_DAILY_OVERLOAD, "teacher");
        addDailyLoadBalancePenalties(build.model(), groupBusyVars, context.normalizedSlots(), build.softTerms(), GROUP_DAILY_LOAD_LIMIT, PENALTY_GROUP_DAILY_OVERLOAD, "group");

        List<LinearExpr> phaseOneTerms = new ArrayList<>();
        for (LessonVertex vertex : vertices) {
            int penalty = dynamicUnplacedPenalty(vertex, context.candidatesByVertex().getOrDefault(vertex.getId(), Collections.emptyList()).size());
            phaseOneTerms.add(LinearExpr.term(build.unplacedVars().get(vertex.getId()), penalty));
        }
        build.model().minimize(LinearExpr.sum(phaseOneTerms.toArray(new LinearExpr[0])));

        CpSolver phaseOneSolver = new CpSolver();
        configureSolver(phaseOneSolver);
        CpSolverStatus phaseOneStatus = phaseOneSolver.solve(build.model());

        if (phaseOneStatus != CpSolverStatus.OPTIMAL && phaseOneStatus != CpSolverStatus.FEASIBLE) {
            log.warn("CP-SAT phase 1 failed. status={}", phaseOneStatus);
            Set<Long> allUnplaced = vertices.stream().map(LessonVertex::getId).collect(Collectors.toCollection(LinkedHashSet::new));
            return new SolveResult(Collections.emptyMap(), allUnplaced);
        }

        long bestUnplacedObjective = Math.round(phaseOneSolver.objectiveValue());

        CpModel phaseTwoModel = build.model();
        phaseTwoModel.addLessOrEqual(
                LinearExpr.sum(phaseOneTerms.toArray(new LinearExpr[0])),
                bestUnplacedObjective
        );
        phaseTwoModel.minimize(LinearExpr.sum(build.softTerms().toArray(new LinearExpr[0])));

        CpSolver phaseTwoSolver = new CpSolver();
        configureSolver(phaseTwoSolver);
        CpSolverStatus phaseTwoStatus = phaseTwoSolver.solve(phaseTwoModel);

        CpSolver finalSolver = (phaseTwoStatus == CpSolverStatus.OPTIMAL || phaseTwoStatus == CpSolverStatus.FEASIBLE)
                ? phaseTwoSolver
                : phaseOneSolver;

        log.info("CP-SAT solve finished: phase1={}, phase2={}, objective={}",
                phaseOneStatus, phaseTwoStatus,
                (finalSolver == phaseTwoSolver ? phaseTwoSolver.objectiveValue() : phaseOneSolver.objectiveValue()));

        Map<Long, SchedulingCandidateGenerator.TimeCandidate> selectedTimes =
                extractSelectedTimes(vertices, context.candidatesByVertex(), build.timeVars(), finalSolver);
        Set<Long> unplaced =
                extractSolverUnplaced(vertices, build.unplacedVars(), finalSolver);

        return new SolveResult(selectedTimes, unplaced);
    }

    private PhaseOneBuild buildModel(
            List<LessonVertex> vertices,
            SchedulingCandidateGenerator.CandidateContext context,
            List<Room> allRooms
    ) {
        CpModel model = new CpModel();

        Map<TimeVarKey, BoolVar> timeVars = new HashMap<>();
        Map<Long, BoolVar> unplacedVars = new HashMap<>();
        Map<ResourceTimeKey, List<BoolVar>> teacherOccupancy = new HashMap<>();
        Map<ResourceTimeKey, List<BoolVar>> groupOccupancy = new HashMap<>();
        Map<RoomPoolTimeKey, List<BoolVar>> roomPoolOccupancy = new HashMap<>();
        Map<AssignmentDayKey, List<BoolVar>> assignmentDayOccupancy = new HashMap<>();
        List<LinearExpr> softTerms = new ArrayList<>();

        Set<Integer> capacityThresholds = buildCapacityThresholds(vertices);

        for (LessonVertex vertex : vertices) {
            BoolVar unplaced = model.newBoolVar("unplaced_v_" + vertex.getId());
            unplacedVars.put(vertex.getId(), unplaced);

            List<Literal> chooseOne = new ArrayList<>();
            List<SchedulingCandidateGenerator.TimeCandidate> candidates =
                    context.candidatesByVertex().getOrDefault(vertex.getId(), Collections.emptyList());

            for (SchedulingCandidateGenerator.TimeCandidate candidate : candidates) {
                BoolVar var = model.newBoolVar("y_v" + vertex.getId() + "_d" + candidate.day() + "_t" + candidate.startTime());
                timeVars.put(new TimeVarKey(vertex.getId(), candidate.day(), candidate.startTime()), var);
                chooseOne.add(var);

                indexTeacherOccupancy(teacherOccupancy, vertex, candidate, var);
                indexGroupOccupancy(groupOccupancy, vertex, candidate, var);
                indexRoomPoolOccupancy(roomPoolOccupancy, vertex, candidate, var, capacityThresholds);
                indexAssignmentDayOccupancy(assignmentDayOccupancy, vertex, candidate, var);

                if (vertex.getPreferredDays() != null
                        && !vertex.getPreferredDays().isEmpty()
                        && !vertex.getPreferredDays().contains(candidate.day())) {
                    softTerms.add(LinearExpr.term(var, PENALTY_NON_PREFERRED_DAY));
                }

                if (candidate.day() == DayOfWeek.SATURDAY) {
                    softTerms.add(LinearExpr.term(var, PENALTY_SATURDAY));
                }

                if (!candidate.startTime().isBefore(LocalTime.of(16, 0))) {
                    softTerms.add(LinearExpr.term(var, PENALTY_LATE_EVENING));
                } else if (!candidate.startTime().isBefore(LocalTime.NOON)) {
                    softTerms.add(LinearExpr.term(var, PENALTY_AFTERNOON));
                }
            }

            chooseOne.add(unplaced);
            model.addExactlyOne(chooseOne.toArray(new Literal[0]));
        }

        log.info("CP-SAT model stats: vertices={}, candidateTimes={}, timeVars={}, teacherBuckets={}, groupBuckets={}, roomPoolBuckets={}",
                vertices.size(),
                context.candidatesByVertex().values().stream().mapToInt(List::size).sum(),
                timeVars.size(),
                teacherOccupancy.size(),
                groupOccupancy.size(),
                roomPoolOccupancy.size());

        return new PhaseOneBuild(
                model,
                timeVars,
                unplacedVars,
                teacherOccupancy,
                groupOccupancy,
                roomPoolOccupancy,
                assignmentDayOccupancy,
                softTerms
        );
    }

    private int dynamicUnplacedPenalty(LessonVertex vertex, int candidateCount) {
        int penalty = BASE_UNPLACED;

        if (vertex.getDurationHours() >= 4) penalty += 2_500;
        if (candidateCount <= 4) penalty += 4_000;
        else if (candidateCount <= 8) penalty += 2_000;
        else if (candidateCount <= 16) penalty += 1_000;

        return penalty;
    }

    private void configureSolver(CpSolver solver) {
        solver.getParameters().setMaxTimeInSeconds(30.0);
        solver.getParameters().setNumSearchWorkers(6);
//        solver.getParameters().setRandomSeed(42);
    }

    private void indexTeacherOccupancy(
            Map<ResourceTimeKey, List<BoolVar>> teacherOccupancy,
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            BoolVar var
    ) {
        if (vertex.getTeacherId() == null) return;
        for (LocalTime coveredSlot : candidate.coveredSlots()) {
            ResourceTimeKey key = new ResourceTimeKey(vertex.getTeacherId(), candidate.day(), coveredSlot);
            teacherOccupancy.computeIfAbsent(key, _k -> new ArrayList<>()).add(var);
        }
    }

    private void indexGroupOccupancy(
            Map<ResourceTimeKey, List<BoolVar>> groupOccupancy,
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
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

    private void indexRoomPoolOccupancy(
            Map<RoomPoolTimeKey, List<BoolVar>> roomPoolOccupancy,
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            BoolVar var,
            Set<Integer> capacityThresholds
    ) {
        int requiredCapacity = normalizeRequiredCapacity(vertex.getRoomCapacityRequired());

        for (LocalTime coveredSlot : candidate.coveredSlots()) {
            for (Integer threshold : capacityThresholds) {
                if (requiredCapacity >= threshold) {
                    RoomPoolTimeKey key = new RoomPoolTimeKey(
                            null,
                            threshold,
                            candidate.day(),
                            coveredSlot
                    );
                    roomPoolOccupancy
                            .computeIfAbsent(key, _k -> new ArrayList<>())
                            .add(var);
                }
            }

            if (vertex.getRoomTypeRequired() != null && vertex.getRoomTypeRequired() != RoomType.ANY) {
                for (Integer threshold : capacityThresholds) {
                    if (requiredCapacity >= threshold) {
                        RoomPoolTimeKey key = new RoomPoolTimeKey(
                                vertex.getRoomTypeRequired(),
                                threshold,
                                candidate.day(),
                                coveredSlot
                        );
                        roomPoolOccupancy
                                .computeIfAbsent(key, _k -> new ArrayList<>())
                                .add(var);
                    }
                }
            }
        }
    }

    private void indexAssignmentDayOccupancy(
            Map<AssignmentDayKey, List<BoolVar>> assignmentDayOccupancy,
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            BoolVar var
    ) {
        if (vertex.getAssignmentId() == null) return;
        AssignmentDayKey key = new AssignmentDayKey(vertex.getAssignmentId(), candidate.day());
        assignmentDayOccupancy.computeIfAbsent(key, _k -> new ArrayList<>()).add(var);
    }

    private void addSoftSameDayAssignmentPenalties(
            CpModel model,
            Map<AssignmentDayKey, List<BoolVar>> assignmentDayOccupancy,
            List<LinearExpr> softTerms
    ) {
        for (Map.Entry<AssignmentDayKey, List<BoolVar>> entry : assignmentDayOccupancy.entrySet()) {
            if (entry.getValue().size() <= 1) continue;

            IntVar dayLoad = model.newIntVar(0, entry.getValue().size(), "assignment_day_load_" + entry.getKey().assignmentId() + "_" + entry.getKey().day());
            model.addEquality(dayLoad, LinearExpr.sum(entry.getValue().toArray(new IntVar[0])));

            IntVar extra = model.newIntVar(0, entry.getValue().size(), "assignment_day_extra_" + entry.getKey().assignmentId() + "_" + entry.getKey().day());
            model.addGreaterOrEqual(extra, LinearExpr.newBuilder().add(dayLoad).add(-1).build());

            softTerms.add(LinearExpr.term(extra, PENALTY_ASSIGNMENT_SAME_DAY_REPEAT));
        }
    }

    private Map<ResourceTimeKey, BoolVar> createBusyVars(
            CpModel model,
            Map<ResourceTimeKey, List<BoolVar>> occupancy,
            String prefix
    ) {
        Map<ResourceTimeKey, BoolVar> busyVars = new HashMap<>();

        for (Map.Entry<ResourceTimeKey, List<BoolVar>> entry : occupancy.entrySet()) {
            if (entry.getValue().isEmpty()) continue;

            BoolVar busy = model.newBoolVar(prefix + "_busy_" + entry.getKey().resourceId() + "_" + entry.getKey().day() + "_" + entry.getKey().slotTime());
            model.addMaxEquality(busy, entry.getValue().toArray(new IntVar[0]));
            busyVars.put(entry.getKey(), busy);
        }

        return busyVars;
    }

    private void addGapAndLongDayPenalties(
            CpModel model,
            Map<ResourceTimeKey, BoolVar> busyVars,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots,
            List<LinearExpr> softTerms,
            int gapPenalty,
            int stretchedDayPenalty,
            String prefix
    ) {
        Map<ResourceDayKey, List<ResourceTimeKey>> byResourceDay = busyVars.keySet().stream()
                .collect(Collectors.groupingBy(key -> new ResourceDayKey(key.resourceId(), key.day())));

        for (Map.Entry<ResourceDayKey, List<ResourceTimeKey>> entry : byResourceDay.entrySet()) {
            ResourceDayKey dayKey = entry.getKey();
            List<CpSatScheduler.TimeSlotInfo> orderedSlots = normalizedSlots.getOrDefault(dayKey.day(), Collections.emptyList());
            if (orderedSlots.size() < 2) continue;

            List<BoolVar> orderedBusy = new ArrayList<>();
            for (CpSatScheduler.TimeSlotInfo slot : orderedSlots) {
                BoolVar busy = busyVars.get(new ResourceTimeKey(dayKey.resourceId(), dayKey.day(), slot.startTime()));
                orderedBusy.add(busy != null ? busy : newFalseVar(model, prefix + "_zero_" + dayKey.resourceId() + "_" + dayKey.day() + "_" + slot.startTime()));
            }

            for (int i = 1; i < orderedBusy.size() - 1; i++) {
                BoolVar gap = model.newBoolVar(prefix + "_gap_" + dayKey.resourceId() + "_" + dayKey.day() + "_" + i);
                model.addImplication(gap, orderedBusy.get(i - 1));
                model.addImplication(gap, orderedBusy.get(i + 1));
                model.addImplication(gap, orderedBusy.get(i).not());
                model.addBoolOr(new Literal[]{orderedBusy.get(i - 1).not(), orderedBusy.get(i + 1).not(), orderedBusy.get(i), gap});
                softTerms.add(LinearExpr.term(gap, gapPenalty));
            }

            IntVar load = model.newIntVar(0, orderedBusy.size(), prefix + "_load_" + dayKey.resourceId() + "_" + dayKey.day());
            model.addEquality(load, LinearExpr.sum(orderedBusy.toArray(new IntVar[0])));

            IntVar overload = model.newIntVar(0, orderedBusy.size(), prefix + "_stretch_" + dayKey.resourceId() + "_" + dayKey.day());
            model.addGreaterOrEqual(overload, LinearExpr.newBuilder().add(load).add(-3).build());
            softTerms.add(LinearExpr.term(overload, stretchedDayPenalty));
        }
    }

    private void addDailyLoadBalancePenalties(
            CpModel model,
            Map<ResourceTimeKey, BoolVar> busyVars,
            Map<DayOfWeek, List<CpSatScheduler.TimeSlotInfo>> normalizedSlots,
            List<LinearExpr> softTerms,
            int dailyLimit,
            int overloadPenalty,
            String prefix
    ) {
        Map<ResourceDayKey, List<ResourceTimeKey>> byResourceDay = busyVars.keySet().stream()
                .collect(Collectors.groupingBy(key -> new ResourceDayKey(key.resourceId(), key.day())));

        for (Map.Entry<ResourceDayKey, List<ResourceTimeKey>> entry : byResourceDay.entrySet()) {
            ResourceDayKey dayKey = entry.getKey();
            List<CpSatScheduler.TimeSlotInfo> orderedSlots = normalizedSlots.getOrDefault(dayKey.day(), Collections.emptyList());
            if (orderedSlots.isEmpty()) continue;

            List<BoolVar> dayBusy = new ArrayList<>();
            for (CpSatScheduler.TimeSlotInfo slot : orderedSlots) {
                BoolVar busy = busyVars.get(new ResourceTimeKey(dayKey.resourceId(), dayKey.day(), slot.startTime()));
                dayBusy.add(busy != null ? busy : newFalseVar(model, prefix + "_zero_load_" + dayKey.resourceId() + "_" + dayKey.day() + "_" + slot.startTime()));
            }

            IntVar dayLoad = model.newIntVar(0, orderedSlots.size(), prefix + "_load_" + dayKey.resourceId() + "_" + dayKey.day());
            model.addEquality(dayLoad, LinearExpr.sum(dayBusy.toArray(new IntVar[0])));

            IntVar overload = model.newIntVar(0, orderedSlots.size(), prefix + "_overload_" + dayKey.resourceId() + "_" + dayKey.day());
            model.addGreaterOrEqual(overload, LinearExpr.newBuilder().add(dayLoad).add(-dailyLimit).build());

            softTerms.add(LinearExpr.term(overload, overloadPenalty));
        }
    }

    private BoolVar newFalseVar(CpModel model, String name) {
        BoolVar zero = model.newBoolVar(name);
        model.addEquality(zero, 0);
        return zero;
    }

    private void addRoomPoolCapacityConstraints(
            CpModel model,
            Map<RoomPoolTimeKey, List<BoolVar>> roomPoolOccupancy,
            List<Room> allRooms
    ) {
        for (Map.Entry<RoomPoolTimeKey, List<BoolVar>> entry : roomPoolOccupancy.entrySet()) {
            List<BoolVar> vars = entry.getValue();
            if (vars.isEmpty()) continue;

            RoomPoolTimeKey key = entry.getKey();
            int availableRooms = countAvailableRoomsForPool(
                    allRooms,
                    key.roomType(),
                    key.minCapacity()
            );

            if (availableRooms <= 0) {
                model.addEquality(
                        LinearExpr.sum(vars.toArray(new IntVar[0])),
                        0
                );
                continue;
            }

            model.addLessOrEqual(
                    LinearExpr.sum(vars.toArray(new IntVar[0])),
                    availableRooms
            );
        }
    }

    private int countAvailableRoomsForPool(
            List<Room> allRooms,
            RoomType roomType,
            int minCapacity
    ) {
        int count = 0;

        for (Room room : allRooms) {
            if (roomType != null && room.getType() != roomType) {
                continue;
            }

            if (minCapacity > 0) {
                Integer roomCapacity = room.getCapacity();
                if (roomCapacity == null || roomCapacity < minCapacity) {
                    continue;
                }
            }

            count++;
        }

        return count;
    }

    private Set<Integer> buildCapacityThresholds(List<LessonVertex> vertices) {
        Set<Integer> thresholds = new TreeSet<>();
        thresholds.add(0);

        for (LessonVertex vertex : vertices) {
            int requiredCapacity = normalizeRequiredCapacity(vertex.getRoomCapacityRequired());
            if (requiredCapacity > 0) {
                thresholds.add(requiredCapacity);
            }
        }

        return thresholds;
    }

    private int normalizeRequiredCapacity(Integer requiredCapacity) {
        return requiredCapacity == null ? 0 : Math.max(requiredCapacity, 0);
    }

    private void addAtMostOneConstraints(
            CpModel model,
            Map<ResourceTimeKey, List<BoolVar>> occupancy
    ) {
        for (List<BoolVar> vars : occupancy.values()) {
            if (vars.size() > 1) {
                model.addAtMostOne(vars.toArray(new Literal[0]));
            }
        }
    }

    private Map<Long, SchedulingCandidateGenerator.TimeCandidate> extractSelectedTimes(
            List<LessonVertex> vertices,
            Map<Long, List<SchedulingCandidateGenerator.TimeCandidate>> candidatesByVertex,
            Map<TimeVarKey, BoolVar> timeVars,
            CpSolver solver
    ) {
        Map<Long, SchedulingCandidateGenerator.TimeCandidate> selected = new HashMap<>();

        for (LessonVertex vertex : vertices) {
            for (SchedulingCandidateGenerator.TimeCandidate candidate : candidatesByVertex.getOrDefault(vertex.getId(), Collections.emptyList())) {
                BoolVar var = timeVars.get(new TimeVarKey(vertex.getId(), candidate.day(), candidate.startTime()));
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
}