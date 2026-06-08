package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class AssignmentLessonExpander {

    public List<LessonVertex> buildVertices(List<Assignment> assignments) {
        return buildVertices(assignments, Collections.emptyMap());
    }

    public List<LessonVertex> buildVertices(List<Assignment> assignments, Map<Long, Integer> assignedHoursByAssignment) {
        List<LessonVertex> vertices = new ArrayList<>();
        long vertexId = 1L;

        for (Assignment assignment : assignments) {
            List<Integer> parts = HoursSplittingUtils.parseSplitting(
                    assignment.getHoursSplitting(),
                    assignment.getHoursPerWeek()
            );
            parts = remainingParts(parts, assignedHoursByAssignment.getOrDefault(assignment.getId(), 0));
            if (parts.isEmpty()) {
                continue;
            }

            Set<Long> groupIds = assignment.getGroups()
                    .stream()
                    .map(StudyGroup::getId)
                    .collect(Collectors.toSet());

            int roomCapacity = assignment.getGroups().stream()
                    .mapToInt(group -> group.getStudentCount() == null ? 0 : group.getStudentCount())
                    .sum();

            for (Integer duration : parts) {
                LessonVertex vertex = new LessonVertex();
                vertex.setId(vertexId++);
                vertex.setAssignmentId(assignment.getId());
                vertex.setGroupIds(groupIds);
                vertex.setSubjectId(assignment.getSubject() != null ? assignment.getSubject().getId() : null);
                vertex.setTeacherId(assignment.getTeacher() != null ? assignment.getTeacher().getId() : null);
                vertex.setShift(assignment.getShift());
                vertex.setRoomTypeRequired(assignment.getRoomTypeRequired());
                vertex.setRoomCapacityRequired(roomCapacity);
                vertex.setSpecificRoomId(assignment.getSpecificRoomId());
                vertex.setDurationHours(duration);
                vertex.setExcludedDays(
                        assignment.getExcludedDays() != null
                                ? assignment.getExcludedDays()
                                : Collections.emptySet()
                );
                vertex.setExcludedTimeSlots(
                        assignment.getExcludedTimeSlots() != null
                                ? assignment.getExcludedTimeSlots()
                                : Collections.emptyList()
                );
                vertex.setPreferredDays(
                        assignment.getPreferredDays() != null
                                ? assignment.getPreferredDays()
                                : Collections.emptyList()
                );
                vertices.add(vertex);
            }
        }

        return vertices;
    }

    private List<Integer> remainingParts(List<Integer> parts, int alreadyAssignedHours) {
        if (alreadyAssignedHours <= 0) {
            return parts;
        }

        List<Integer> remaining = new ArrayList<>();
        int hoursToConsume = alreadyAssignedHours;

        for (Integer part : parts) {
            if (hoursToConsume >= part) {
                hoursToConsume -= part;
                continue;
            }

            if (hoursToConsume > 0) {
                remaining.add(part - hoursToConsume);
                hoursToConsume = 0;
            } else {
                remaining.add(part);
            }
        }

        return remaining;
    }
}
