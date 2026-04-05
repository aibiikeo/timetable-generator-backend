package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Timetable;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class TimetableMapper {

    private final AssignmentMapper assignmentMapper;

    public Timetable toEntity(TimetableRequest request) {
        Timetable timetable = Timetable.builder()
                .name(request.name())
                .academicYearStart(request.academicYearStart())
                .semester(request.semester())
                .generationSettings(request.generationSettings())
                .build();

        if (request.assignments() != null) {
            List<Assignment> assignments = request.assignments().stream()
                    .map(assignmentMapper::toEntity)
                    .toList();

            assignments.forEach(a -> a.setTimetable(timetable));
            timetable.setAssignments(assignments);
        }

        timetable.syncDerivedFields();
        return timetable;
    }

    public TimetableResponse toResponse(Timetable timetable) {
        List<AssignmentResponse> assignmentResponses = timetable.getAssignments() == null
                ? List.of()
                : timetable.getAssignments().stream()
                .map(assignmentMapper::toResponse)
                .toList();

        int totalLessons = timetable.getLessons() == null ? 0 : timetable.getLessons().size();
        int totalRequiredLessons = countTotalRequiredLessons(timetable);

        return new TimetableResponse(
                timetable.getId(),
                timetable.getName(),
                timetable.getAcademicYearStart(),
                timetable.getAcademicYearEnd(),
                timetable.getSemester(),
                timetable.getVersion(),
                timetable.getCreatedAt(),
                timetable.getStatus(),
                timetable.getGenerationSettings(),
                timetable.getConflictReport(),
                assignmentResponses,
                totalLessons,
                totalRequiredLessons
        );
    }

    private int countTotalRequiredLessons(Timetable timetable) {
        if (timetable.getAssignments() == null) {
            return 0;
        }

        return timetable.getAssignments().stream()
                .mapToInt(this::extractRequiredLessons)
                .sum();
    }

    private int extractRequiredLessons(Assignment assignment) {
        if (assignment.getHoursPerWeek() != null) {
            return assignment.getHoursPerWeek();
        }
        return 0;
    }
}