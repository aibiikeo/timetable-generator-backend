package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.QuickActionSettingsRequest;
import com.example.timetablegenerator.domain.dto.response.QuickActionOptionResponse;
import com.example.timetablegenerator.domain.dto.response.QuickActionSettingsResponse;
import com.example.timetablegenerator.services.QuickActionService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Quick Actions")
@RequestMapping("/api/quick-actions")
@RequiredArgsConstructor
public class QuickActionController {

    private final QuickActionService quickActionService;

    @GetMapping("/options")
    public List<QuickActionOptionResponse> getAvailableActions() {
        return quickActionService.getAvailableActions();
    }

    @GetMapping("/settings")
    public QuickActionSettingsResponse getSettings(Authentication authentication) {
        return quickActionService.getSettings(authentication.getName());
    }

    @PutMapping("/settings")
    public QuickActionSettingsResponse updateSettings(
            Authentication authentication,
            @Valid @RequestBody QuickActionSettingsRequest request) {
        return quickActionService.updateSettings(authentication.getName(), request);
    }

    @PostMapping("/{actionId}/usage")
    public QuickActionSettingsResponse recordUsage(
            Authentication authentication,
            @PathVariable String actionId) {
        return quickActionService.recordUsage(authentication.getName(), actionId);
    }
}
