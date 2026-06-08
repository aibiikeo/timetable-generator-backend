package com.example.timetablegenerator.mappers;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.entities.Assignment;
import com.example.timetablegenerator.domain.entities.Degree;
import com.example.timetablegenerator.domain.entities.PlacementStatus;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import com.example.timetablegenerator.utils.HoursSplittingUtils;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.Comparator;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring")
public interface AssignmentMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    @Mapping(target = "generatedLessonsCount", ignore = true)
    @Mapping(target = "placementStatus", ignore = true)
    @Mapping(target = "failureReason", ignore = true)
    @Mapping(target = "requiresManualInput", ignore = true)
    @Mapping(target = "excludedTimeSlots", source = "excludedTimeSlots", qualifiedByName = "mapExcludedTimeSlots")
    Assignment toEntity(AssignmentRequest request);

    @Mapping(target = "subjectId", source = "subject.id")
    @Mapping(target = "subjectName", source = "subject.name")
    @Mapping(target = "teacherId", source = "teacher.id")
    @Mapping(target = "teacherName", source = "teacher.fullName")
    @Mapping(target = "groupIds", source = "groups", qualifiedByName = "mapGroupIds")
    @Mapping(target = "groupNames", source = "groups", qualifiedByName = "mapGroupNames")
    @Mapping(target = "requiredLessonsCount", source = "hoursPerWeek", qualifiedByName = "requiredLessonsCount")
    @Mapping(target = "placementStatus", source = "placementStatus", qualifiedByName = "mapPlacementStatus")
    @Mapping(target = "splittingOptions", source = "hoursPerWeek", qualifiedByName = "buildSplittingOptions")
    @Mapping(target = "selectedSplitting", source = "hoursSplitting")
    @Mapping(target = "requiresManualInput", source = "requiresManualInput")

    @Mapping(target = "majorId", source = "subject.major.id")
    @Mapping(target = "majorName", source = "subject.major.name")
    @Mapping(target = "degree", source = "groups", qualifiedByName = "mapDegree")
    @Mapping(target = "departmentId", source = "subject.major.department.id")
    @Mapping(target = "departmentName", source = "subject.major.department.name")
    @Mapping(target = "facultyId", source = "subject.major.department.faculty.id")
    @Mapping(target = "facultyName", source = "subject.major.department.faculty.name")
    AssignmentResponse toResponse(Assignment entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subject", ignore = true)
    @Mapping(target = "teacher", ignore = true)
    @Mapping(target = "groups", ignore = true)
    @Mapping(target = "timetable", ignore = true)
    @Mapping(target = "lessons", ignore = true)
    @Mapping(target = "generatedLessonsCount", ignore = true)
    @Mapping(target = "placementStatus", ignore = true)
    @Mapping(target = "failureReason", ignore = true)
    @Mapping(target = "requiresManualInput", ignore = true)
    @Mapping(target = "excludedTimeSlots", source = "excludedTimeSlots", qualifiedByName = "mapExcludedTimeSlots")
    void updateEntityFromRequest(AssignmentRequest request, @MappingTarget Assignment entity);

    @Named("mapGroupIds")
    default List<Long> mapGroupIds(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) {
            return List.of();
        }
        return groups.stream()
                .map(StudyGroup::getId)
                .sorted()
                .toList();
    }

    @Named("mapGroupNames")
    default List<String> mapGroupNames(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) {
            return List.of();
        }
        return groups.stream()
                .map(StudyGroup::getName)
                .sorted()
                .toList();
    }

    @Named("mapDegree")
    default Degree mapDegree(Set<StudyGroup> groups) {
        if (groups == null || groups.isEmpty()) {
            return null;
        }

        return groups.stream()
                .map(StudyGroup::getDegree)
                .filter(java.util.Objects::nonNull).min(Comparator.comparing(Enum::name))
                .orElse(null);
    }

    @Named("requiredLessonsCount")
    default int requiredLessonsCount(Integer hoursPerWeek) {
        return hoursPerWeek != null ? hoursPerWeek : 0;
    }

    @Named("mapPlacementStatus")
    default String mapPlacementStatus(PlacementStatus placementStatus) {
        return placementStatus != null ? placementStatus.name() : PlacementStatus.PENDING.name();
    }

    @Named("buildSplittingOptions")
    default List<String> buildSplittingOptions(Integer hoursPerWeek) {
        if (hoursPerWeek == null || hoursPerWeek <= 0) {
            return List.of();
        }

        return HoursSplittingUtils.generateSplittingOptionsForUI(hoursPerWeek);
    }

    @Named("mapExcludedTimeSlots")
    default List<TimeSlotExclusion> mapExcludedTimeSlots(List<AssignmentRequest.TimeSlotExclusion> dtos) {
        if (dtos == null) {
            return null;
        }

        return dtos.stream()
                .map(dto -> new TimeSlotExclusion(dto.day(), dto.startTime(), dto.endTime()))
                .toList();
    }
}
