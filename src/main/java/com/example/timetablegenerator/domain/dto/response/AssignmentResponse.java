package com.example.timetablegenerator.domain.dto.response;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;

import java.util.List;

public record AssignmentResponse(
        Long id,
        Long subjectId,
        String subjectName,
        Long teacherId,
        String teacherName,
        List<Long> groupIds,
        List<String> groupNames,
        Integer hoursPerWeek,
        Shift shift,
        RoomType roomTypeRequired,
        String hoursSplitting,
        int generatedLessonsCount,
        int requiredLessonsCount,

        // Новые поля для отображения статуса
        String placementStatus,      // "PENDING", "SCHEDULED", "FAILED"
        String failureReason,        // Почему не удалось расставить
        List<String> splittingOptions, // Варианты разделения для UI
        String selectedSplitting,    // Выбранный вариант
        boolean requiresManualInput  // Нужно ли ручное вмешательство
) {}