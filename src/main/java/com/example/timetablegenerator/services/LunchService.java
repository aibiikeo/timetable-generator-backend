package com.example.timetablegenerator.services;


import com.example.timetablegenerator.domain.dto.request.LunchRequest;
import com.example.timetablegenerator.domain.dto.response.LunchResponse;

import java.util.List;

public interface LunchService {

    LunchResponse create(LunchRequest request);

    LunchResponse update(Long id, LunchRequest request);

    void delete(Long id);

    LunchResponse getById(Long id);

    List<LunchResponse> getByTimetable(Long timetableId);

    List<LunchResponse> getByTimetableAndGroup(Long timetableId, Long groupId);

    void deleteByTimetable(Long timetableId);
}