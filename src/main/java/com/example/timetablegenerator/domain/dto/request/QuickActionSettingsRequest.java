package com.example.timetablegenerator.domain.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public record QuickActionSettingsRequest(
        @NotNull(message = "Auto mode flag is required")
        Boolean autoEnabled,

        @Size(max = 10, message = "You can select up to 10 quick actions")
        List<String> selectedActionIds
) {
}
