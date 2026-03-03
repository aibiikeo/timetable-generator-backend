package com.example.timetablegenerator.domain.entities;

public enum PlacementStatus {
    PENDING,           // Ожидает расстановки
    SCHEDULED,         // Успешно расставлено
    PARTIAL,           // Частично расставлено
    FAILED,            // Не удалось расставить
    MANUAL_REQUIRED    // Требуется ручная расстановка
}