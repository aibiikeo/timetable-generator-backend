package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class AssignmentLessonExpander {

    public List<LessonVertex> buildVertices(List<Assignment> assignments) {
        List<LessonVertex> vertices = new ArrayList<>();
        long vertexId = 1L;

        for (Assignment assignment : assignments) {
            List<Integer> parts = HoursSplittingUtils.parseSplitting(
                    assignment.getHoursSplitting(),
                    assignment.getHoursPerWeek()
            );

            Set<Long> groupIds = assignment.getGroups()
                    .stream()
                    .map(StudyGroup::getId)
                    .collect(Collectors.toSet());

            for (Integer duration : parts) {
                LessonVertex vertex = new LessonVertex();
                vertex.setId(vertexId++);
                vertex.setAssignmentId(assignment.getId());
                vertex.setGroupIds(groupIds);
                vertex.setTeacherId(assignment.getTeacher() != null ? assignment.getTeacher().getId() : null);
                vertex.setShift(assignment.getShift());
                vertex.setRoomTypeRequired(assignment.getRoomTypeRequired());
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
}