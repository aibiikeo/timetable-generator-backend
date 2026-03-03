package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;

import java.util.List;
import java.util.Optional;

public interface TimetableService {

    List<TimetableResponse> getAllTimetables();

    Optional<TimetableResponse> getCurrentTimetable();

    Optional<TimetableResponse> getTimetable(Long versionId);

    TimetableResponse createTimetable(TimetableRequest request);

    TimetableResponse publishTimetable(Long versionId);

    void deleteTimetable(Long versionId);
}
