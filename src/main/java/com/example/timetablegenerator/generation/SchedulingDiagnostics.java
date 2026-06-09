package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
public class SchedulingDiagnostics {

    private record ResourceTimeKey(Long resourceId, DayOfWeek day, LocalTime slotTime) {}

    private record CandidateConflictSummary(
            int totalCandidates,
            int teacherConflictCandidates,
            int groupConflictCandidates,
            int bothConflictCandidates,
            int splitConflictCandidates,
            int trulyFreeCandidates,
            List<String> sampleBlockedCandidates,
            List<String> sampleFreeCandidates
    ) {}

    private record OccupancySnapshot(
            Map<Long, Set<ResourceTimeKey>> teacherOccupied,
            Map<Long, Set<ResourceTimeKey>> groupOccupied,
            Map<Long, Set<DayOfWeek>> assignmentDays
    ) {}

    public void logCandidateSummary(
            List<LessonVertex> vertices,
            SchedulingCandidateGenerator.CandidateContext context
    ) {
        Map<Integer, Long> byDuration = vertices.stream()
                .collect(Collectors.groupingBy(LessonVertex::getDurationHours, TreeMap::new, Collectors.counting()));

        long zeroCandidateVertices = vertices.stream()
                .filter(v -> context.candidatesByVertex().getOrDefault(v.getId(), Collections.emptyList()).isEmpty())
                .count();

        log.info("app | Candidate summary: vertices={}, byDuration={}, zeroCandidateVertices={}",
                vertices.size(), byDuration, zeroCandidateVertices);

        if (!log.isDebugEnabled()) return;

        List<LessonVertex> mostConstrained = vertices.stream()
                .sorted(Comparator
                        .comparingInt((LessonVertex v) -> context.candidatesByVertex()
                                .getOrDefault(v.getId(), Collections.emptyList()).size())
                        .thenComparing(LessonVertex::getAssignmentId)
                        .thenComparing(LessonVertex::getId))
                .limit(12)
                .toList();

        for (LessonVertex v : mostConstrained) {
            List<SchedulingCandidateGenerator.TimeCandidate> candidates =
                    context.candidatesByVertex().getOrDefault(v.getId(), Collections.emptyList());

            log.debug("app | CONSTRAINED vertexId={}, assignmentId={}, teacherId={}, groups={}, duration={}, candidates={}",
                    v.getId(), v.getAssignmentId(), v.getTeacherId(), v.getGroupIds(), v.getDurationHours(), candidates.size());
        }
    }

    public void logSolveOutcome(
            List<LessonVertex> vertices,
            SchedulingCandidateGenerator.CandidateContext context,
            CpSatModel.SolveResult solveResult
    ) {
        log.info("app | After CP-SAT only: selectedTimes={}, solverUnplaced={}",
                solveResult.selectedTimes().size(),
                solveResult.unplacedVertexIds().size());

        if (!log.isDebugEnabled() || solveResult.unplacedVertexIds().isEmpty()) return;

        Map<Long, LessonVertex> vertexById = vertices.stream()
                .collect(Collectors.toMap(LessonVertex::getId, v -> v));

        OccupancySnapshot snapshot = buildOccupancySnapshot(vertices, solveResult.selectedTimes());

        for (Long vertexId : solveResult.unplacedVertexIds().stream().sorted().toList()) {
            LessonVertex vertex = vertexById.get(vertexId);
            if (vertex == null) continue;

            List<SchedulingCandidateGenerator.TimeCandidate> candidates =
                    context.candidatesByVertex().getOrDefault(vertexId, Collections.emptyList());

            CandidateConflictSummary summary = analyze(vertex, candidates, snapshot);

            log.debug(
                    "UNPLACED vertexId={}, assignmentId={}, teacherId={}, groups={}, duration={}, candidates={}, conflicts={teacher={}, group={}, both={}, split={}, free={}}, excludedSlots={}, samplesBlocked={}, samplesFree={}",
                    vertex.getId(),
                    vertex.getAssignmentId(),
                    vertex.getTeacherId(),
                    vertex.getGroupIds(),
                    vertex.getDurationHours(),
                    summary.totalCandidates(),
                    summary.teacherConflictCandidates(),
                    summary.groupConflictCandidates(),
                    summary.bothConflictCandidates(),
                    summary.splitConflictCandidates(),
                    summary.trulyFreeCandidates(),
                    formatExclusions(vertex.getExcludedTimeSlots()),
                    summary.sampleBlockedCandidates(),
                    summary.sampleFreeCandidates()
            );
        }

        Map<Long, Long> byTeacher = solveResult.unplacedVertexIds().stream()
                .map(vertexById::get)
                .filter(Objects::nonNull)
                .filter(v -> v.getTeacherId() != null)
                .collect(Collectors.groupingBy(LessonVertex::getTeacherId, TreeMap::new, Collectors.counting()));

        Map<Long, Long> byGroup = solveResult.unplacedVertexIds().stream()
                .map(vertexById::get)
                .filter(Objects::nonNull)
                .flatMap(v -> v.getGroupIds() == null ? java.util.stream.Stream.empty() : v.getGroupIds().stream())
                .collect(Collectors.groupingBy(g -> g, TreeMap::new, Collectors.counting()));

        log.debug("app | UNPLACED_SUMMARY byTeacher={}", byTeacher);
        log.debug("app | UNPLACED_SUMMARY byGroup={}", byGroup);
    }

    private CandidateConflictSummary analyze(
            LessonVertex vertex,
            List<SchedulingCandidateGenerator.TimeCandidate> candidates,
            OccupancySnapshot snapshot
    ) {
        int teacherConflict = 0;
        int groupConflict = 0;
        int bothConflict = 0;
        int splitConflict = 0;
        int trulyFree = 0;

        List<String> blocked = new ArrayList<>();
        List<String> free = new ArrayList<>();

        for (SchedulingCandidateGenerator.TimeCandidate candidate : candidates) {
            boolean teacher = hasTeacherConflict(vertex, candidate, snapshot.teacherOccupied());
            boolean group = hasGroupConflict(vertex, candidate, snapshot.groupOccupied());
            boolean split = hasSplitConflict(vertex, candidate, snapshot.assignmentDays());

            if (teacher) teacherConflict++;
            if (group) groupConflict++;
            if (teacher && group) bothConflict++;
            if (split) splitConflict++;

            boolean ok = !teacher && !group && !split;
            if (ok) {
                trulyFree++;
                if (free.size() < 3) free.add(formatCandidate(candidate) + " => FREE");
            } else if (blocked.size() < 4) {
                List<String> reasons = new ArrayList<>();
                if (teacher) reasons.add("teacher");
                if (group) reasons.add("group");
                if (split) reasons.add("split");
                blocked.add(formatCandidate(candidate) + " => " + String.join("+", reasons));
            }
        }

        return new CandidateConflictSummary(
                candidates.size(),
                teacherConflict,
                groupConflict,
                bothConflict,
                splitConflict,
                trulyFree,
                blocked,
                free
        );
    }

    private OccupancySnapshot buildOccupancySnapshot(
            List<LessonVertex> vertices,
            Map<Long, SchedulingCandidateGenerator.TimeCandidate> selectedTimes
    ) {
        Map<Long, LessonVertex> vertexById = vertices.stream()
                .collect(Collectors.toMap(LessonVertex::getId, v -> v));

        Map<Long, Set<ResourceTimeKey>> teacherOccupied = new HashMap<>();
        Map<Long, Set<ResourceTimeKey>> groupOccupied = new HashMap<>();
        Map<Long, Set<DayOfWeek>> assignmentDays = new HashMap<>();

        for (Map.Entry<Long, SchedulingCandidateGenerator.TimeCandidate> entry : selectedTimes.entrySet()) {
            LessonVertex vertex = vertexById.get(entry.getKey());
            SchedulingCandidateGenerator.TimeCandidate candidate = entry.getValue();
            if (vertex == null) continue;

            if (vertex.getTeacherId() != null) {
                Set<ResourceTimeKey> slots = teacherOccupied.computeIfAbsent(vertex.getTeacherId(), _k -> new HashSet<>());
                for (LocalTime slotTime : candidate.coveredSlots()) {
                    slots.add(new ResourceTimeKey(vertex.getTeacherId(), candidate.day(), slotTime));
                }
            }

            if (vertex.getGroupIds() != null) {
                for (Long groupId : vertex.getGroupIds()) {
                    Set<ResourceTimeKey> slots = groupOccupied.computeIfAbsent(groupId, _k -> new HashSet<>());
                    for (LocalTime slotTime : candidate.coveredSlots()) {
                        slots.add(new ResourceTimeKey(groupId, candidate.day(), slotTime));
                    }
                }
            }

            if (vertex.getAssignmentId() != null) {
                assignmentDays.computeIfAbsent(vertex.getAssignmentId(), _k -> new HashSet<>()).add(candidate.day());
            }
        }

        return new OccupancySnapshot(teacherOccupied, groupOccupied, assignmentDays);
    }

    private boolean hasTeacherConflict(
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            Map<Long, Set<ResourceTimeKey>> teacherOccupied
    ) {
        if (vertex.getTeacherId() == null) return false;
        Set<ResourceTimeKey> occupied = teacherOccupied.getOrDefault(vertex.getTeacherId(), Collections.emptySet());
        for (LocalTime slot : candidate.coveredSlots()) {
            if (occupied.contains(new ResourceTimeKey(vertex.getTeacherId(), candidate.day(), slot))) return true;
        }
        return false;
    }

    private boolean hasGroupConflict(
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            Map<Long, Set<ResourceTimeKey>> groupOccupied
    ) {
        if (vertex.getGroupIds() == null || vertex.getGroupIds().isEmpty()) return false;
        for (Long groupId : vertex.getGroupIds()) {
            Set<ResourceTimeKey> occupied = groupOccupied.getOrDefault(groupId, Collections.emptySet());
            for (LocalTime slot : candidate.coveredSlots()) {
                if (occupied.contains(new ResourceTimeKey(groupId, candidate.day(), slot))) return true;
            }
        }
        return false;
    }

    private boolean hasSplitConflict(
            LessonVertex vertex,
            SchedulingCandidateGenerator.TimeCandidate candidate,
            Map<Long, Set<DayOfWeek>> assignmentDays
    ) {
        if (vertex.getAssignmentId() == null) return false;
        return assignmentDays.getOrDefault(vertex.getAssignmentId(), Collections.emptySet()).contains(candidate.day());
    }

    private String formatCandidate(SchedulingCandidateGenerator.TimeCandidate candidate) {
        return candidate.day() + " " + candidate.startTime();
    }

    private List<String> formatExclusions(List<TimeSlotExclusion> exclusions) {
        if (exclusions == null) return Collections.emptyList();
        return exclusions.stream()
                .map(e -> e.getDay() + " " + e.getStartTime() + "-" + e.getEndTime())
                .toList();
    }
}