package com.example.timetablegenerator.generation;

import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.domain.entities.Shift;
import com.example.timetablegenerator.domain.entities.TimeSlotExclusion;
import lombok.Data;

import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Data
public class LessonVertex {
    private Long id;                      // временный ID для графа
    private Long assignmentId;             // ссылка на исходное назначение
    private Set<Long> groupIds;            // ID групп
    private Long teacherId;                // ID преподавателя
    private Shift shift;                   // смена
    private RoomType roomTypeRequired;      // требуемый тип комнаты
    private Long specificRoomId;            // конкретная комната (если задана)
    private int durationHours;              // длительность этого блока (2,3,4)
    private Set<DayOfWeek> excludedDays;    // запрещённые дни
    private List<TimeSlotExclusion> excludedTimeSlots; // запрещённые временные слоты
    private List<DayOfWeek> preferredDays;  // предпочтительные дни

    // Для алгоритма раскраски
    private int degree;
    private List<LessonVertex> neighbors = new ArrayList<>();
}