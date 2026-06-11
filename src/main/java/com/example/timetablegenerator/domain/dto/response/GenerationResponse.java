package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.TimetableStatus;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class GenerationResponse {
    private Long timetableId;
    private String timetableName;
    private int totalVertices;
    private int placedLessonsCount;
    private int failedVerticesCount;
    private int totalLessonBlocks;
    private int placedLessonBlocksCount;
    private int failedLessonBlocksCount;
    private int totalLessonSlots;
    private int placedLessonSlotsCount;
    private int failedLessonSlotsCount;
    private TimetableStatus status;
    private List<UnplacedLesson> failedAssignments;
}
