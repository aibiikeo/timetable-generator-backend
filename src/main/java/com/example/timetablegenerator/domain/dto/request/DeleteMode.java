package com.example.timetablegenerator.domain.dto.request;

public enum DeleteMode {
    SIMPLE,      // Просто удалить (если нет связи)
    DETACH,      // Отвязать и удалить
    WITH // Удалить вместе со связями
}
