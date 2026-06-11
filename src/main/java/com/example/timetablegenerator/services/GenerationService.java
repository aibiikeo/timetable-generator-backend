package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;
import com.example.timetablegenerator.domain.dto.response.ManualPlacementSuggestionResponse;

import java.util.List;
import java.util.Map;

public interface GenerationService {

    AssignmentResponse createAssignmentWithOptions(Long timetableId, AssignmentRequest request);

    List<String> generateSplittingOptions(int hoursPerWeek);

    GenerationResponse generateTimetable(Long timetableId, GenerationMode mode);

    GenerationResponse retryFailedAssignments(Long timetableId, Map<Long, String> manualSplittings);

    List<ManualPlacementSuggestionResponse> suggestManualPlacements(
            Long timetableId,
            Long assignmentId,
            Integer durationHours,
            int limit);

    boolean manualPlaceLesson(Long timetableId, Long assignmentId,
                              String dayOfWeek, String startTime,
                              Integer durationHours, Long roomId);
}
