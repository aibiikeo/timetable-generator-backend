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
    private int totalVertices;           // общее количество вершин (блоков занятий)
    private int placedLessonsCount;       // сколько успешно размещено
    private int failedVerticesCount;      // сколько не удалось разместить
    private TimetableStatus status;       // итоговый статус расписания
    private List<UnplacedLesson> failedAssignments; // детализация по неудачным назначениям
}