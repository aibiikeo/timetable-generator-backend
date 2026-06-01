package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.QuickActionSettingsRequest;
import com.example.timetablegenerator.domain.dto.response.QuickActionOptionResponse;
import com.example.timetablegenerator.domain.dto.response.QuickActionSettingsResponse;

import java.util.List;

public interface QuickActionService {
    List<QuickActionOptionResponse> getAvailableActions();

    QuickActionSettingsResponse getSettings(String email);

    QuickActionSettingsResponse updateSettings(String email, QuickActionSettingsRequest request);

    QuickActionSettingsResponse recordUsage(String email, String actionId);
}
