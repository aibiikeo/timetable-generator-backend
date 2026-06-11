package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface TimetableMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    Timetable toEntity(TimetableRequest request);

    @Mapping(target = "facultyId", source = "faculty.id")
    @Mapping(target = "facultyName", source = "faculty.name")
    @Mapping(target = "totalLessons", expression = "java(totalLessonBlocks(entity))")
    @Mapping(target = "totalRequiredLessons", expression = "java(totalRequiredLessonBlocks(entity))")
    @Mapping(target = "totalLessonBlocks", expression = "java(totalLessonBlocks(entity))")
    @Mapping(target = "totalRequiredLessonBlocks", expression = "java(totalRequiredLessonBlocks(entity))")
    @Mapping(target = "totalLessonSlots", expression = "java(totalLessonSlots(entity))")
    @Mapping(target = "totalRequiredLessonSlots", expression = "java(totalRequiredLessonSlots(entity))")
    TimetableResponse toResponse(Timetable entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "faculty", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    void updateEntityFromRequest(TimetableRequest request, @MappingTarget Timetable entity);

    default int totalLessonBlocks(Timetable timetable) {
        return timetable == null || timetable.getLessons() == null ? 0 : timetable.getLessons().size();
    }

    default int totalRequiredLessonBlocks(Timetable timetable) {
        if (timetable == null || timetable.getAssignments() == null) {
            return 0;
        }

        return timetable.getAssignments().stream()
                .mapToInt(this::requiredLessonBlocks)
                .sum();
    }

    default int totalLessonSlots(Timetable timetable) {
        if (timetable == null || timetable.getLessons() == null) {
            return 0;
        }

        return timetable.getLessons().stream()
                .map(Lesson::getDurationHours)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();
    }

    default int totalRequiredLessonSlots(Timetable timetable) {
        if (timetable == null || timetable.getAssignments() == null) {
            return 0;
        }

        return timetable.getAssignments().stream()
                .map(Assignment::getHoursPerWeek)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();
    }

    default int requiredLessonBlocks(Assignment assignment) {
        if (assignment == null) {
            return 0;
        }

        List<Integer> parts = HoursSplittingUtils.parseSplitting(
                assignment.getHoursSplitting(),
                assignment.getHoursPerWeek() == null ? 0 : assignment.getHoursPerWeek()
        );
        return parts.size();
    }
}
