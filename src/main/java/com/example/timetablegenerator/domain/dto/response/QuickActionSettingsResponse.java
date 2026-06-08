package com.example.timetablegenerator.domain.dto.response;

import java.util.List;

public record QuickActionSettingsResponse(
        boolean autoEnabled,
        int maxSelected,
        List<QuickActionOptionResponse> selectedActions,
        List<QuickActionOptionResponse> availableActions
) {
}
