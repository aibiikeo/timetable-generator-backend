package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import org.springframework.stereotype.Component;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class ConflictGraphBuilder {

    public List<LessonVertex> buildVertices(List<Assignment> assignments) {
        List<LessonVertex> vertices = new ArrayList<>();
        long vertexId = 1L;

        for (Assignment a : assignments) {
            List<Integer> parts = HoursSplittingUtils.parseSplitting(a.getHoursSplitting(), a.getHoursPerWeek());
            Set<Long> groupIds = a.getGroups().stream()
                    .map(StudyGroup::getId)
                    .collect(Collectors.toSet());

            for (int hours : parts) {
                LessonVertex v = new LessonVertex();
                v.setId(vertexId++);
                v.setAssignmentId(a.getId());
                v.setGroupIds(groupIds);
                v.setTeacherId(a.getTeacher().getId());
                v.setShift(a.getShift());
                v.setRoomTypeRequired(a.getRoomTypeRequired());
                v.setSpecificRoomId(a.getSpecificRoomId());
                v.setDurationHours(hours);
                v.setExcludedDays(a.getExcludedDays());
                v.setExcludedTimeSlots(a.getExcludedTimeSlots());
                v.setPreferredDays(a.getPreferredDays());
                vertices.add(v);
            }
        }
        return vertices;
    }

    public void buildConflictGraph(List<LessonVertex> vertices) {
        for (LessonVertex v : vertices) {
            v.setNeighbors(new ArrayList<>());
        }
        for (int i = 0; i < vertices.size(); i++) {
            for (int j = i + 1; j < vertices.size(); j++) {
                LessonVertex v1 = vertices.get(i);
                LessonVertex v2 = vertices.get(j);
                boolean conflict = hasCommonGroup(v1, v2) || sameTeacher(v1, v2);
                if (conflict) {
                    v1.getNeighbors().add(v2);
                    v2.getNeighbors().add(v1);
                }
            }
        }
        for (LessonVertex v : vertices) {
            v.setDegree(v.getNeighbors().size());
        }
    }

    private boolean hasCommonGroup(LessonVertex v1, LessonVertex v2) {
        return v1.getGroupIds().stream().anyMatch(v2.getGroupIds()::contains);
    }

    private boolean sameTeacher(LessonVertex v1, LessonVertex v2) {
        return v1.getTeacherId().equals(v2.getTeacherId());
    }
}