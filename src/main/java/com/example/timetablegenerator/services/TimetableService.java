package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TimetableRequest;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;

import java.util.List;
import java.util.Optional;

public interface TimetableService {

    List<TimetableResponse> getAllTimetables();

    Optional<TimetableResponse> getPublishedTimetable();

    Optional<TimetableResponse> getTimetable(Long timetableId);

    TimetableResponse createTimetable(TimetableRequest request);

    TimetableResponse updateTimetable(Long timetableId, TimetableRequest request);

    TimetableResponse publishTimetable(Long timetableId);

    void deleteTimetable(Long timetableId, DeleteMode mode);
}