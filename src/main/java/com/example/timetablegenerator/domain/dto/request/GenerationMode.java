package com.example.timetablegenerator.domain.dto.request;

public enum GenerationMode {
    NEW,    // очистить существующие уроки и сгенерировать заново
    APPEND  // добавить новые уроки к существующим (не удаляя старые)
}