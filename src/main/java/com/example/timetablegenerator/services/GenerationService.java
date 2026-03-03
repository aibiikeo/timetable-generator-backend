package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.AssignmentRequest;
import com.example.timetablegenerator.domain.dto.request.GenerationMode;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.GenerationResponse;

import java.util.List;
import java.util.Map;

public interface GenerationService {

    // Создать назначение с автоматической генерацией вариантов разделения
    AssignmentResponse createAssignmentWithOptions(Long timetableId, AssignmentRequest request);

    // Сгенерировать все варианты разделения для заданного количества часов
    List<String> generateSplittingOptions(int hoursPerWeek);

    // Сгенерировать полное расписание
    GenerationResponse generateTimetable(Long timetableId, GenerationMode mode);

    // Попробовать расставить неудачные назначения с другими параметрами
    Map<String, Object> retryFailedAssignments(Long timetableId, Map<Long, String> manualSplittings);

    // Ручная расстановка конкретного урока
    boolean manualPlaceLesson(Long timetableId, Long assignmentId,
                              String dayOfWeek, String startTime,
                              Integer durationHours, Long roomId);
}