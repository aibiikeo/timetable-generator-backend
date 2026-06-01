package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.QuickActionSettingsRequest;
import com.example.timetablegenerator.domain.dto.response.QuickActionOptionResponse;
import com.example.timetablegenerator.domain.dto.response.QuickActionSettingsResponse;
import com.example.timetablegenerator.domain.entities.QuickActionUsage;
import com.example.timetablegenerator.domain.entities.User;
import com.example.timetablegenerator.domain.quickactions.QuickAction;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.repositories.QuickActionUsageRepository;
import com.example.timetablegenerator.repositories.UserRepository;
import com.example.timetablegenerator.services.QuickActionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class QuickActionServiceImpl implements QuickActionService {

    private final UserRepository userRepository;
    private final QuickActionUsageRepository usageRepository;

    @Override
    public List<QuickActionOptionResponse> getAvailableActions() {
        return QuickAction.configurableActions().stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public QuickActionSettingsResponse getSettings(String email) {
        User user = getUser(email);
        return toSettingsResponse(user);
    }

    @Override
    @Transactional
    public QuickActionSettingsResponse updateSettings(String email, QuickActionSettingsRequest request) {
        User user = getUser(email);
        List<String> selectedActionIds = sanitizeSelectedActions(request.selectedActionIds());

        user.setQuickActionsAutoEnabled(request.autoEnabled());
        user.getQuickActionIds().clear();
        user.getQuickActionIds().addAll(selectedActionIds);

        return toSettingsResponse(user);
    }

    @Override
    @Transactional
    public QuickActionSettingsResponse recordUsage(String email, String actionId) {
        User user = getUser(email);
        QuickAction action = parseAction(actionId);

        QuickActionUsage usage = usageRepository.findByUserAndActionId(user, action.id())
                .orElseGet(() -> QuickActionUsage.builder()
                        .user(user)
                        .actionId(action.id())
                        .useCount(0)
                        .lastUsedAt(LocalDateTime.now())
                        .build());

        usage.setUseCount(usage.getUseCount() + 1);
        usage.setLastUsedAt(LocalDateTime.now());
        usageRepository.save(usage);

        return toSettingsResponse(user);
    }

    private QuickActionSettingsResponse toSettingsResponse(User user) {
        List<QuickActionOptionResponse> selectedActions = user.isQuickActionsAutoEnabled()
                ? getAutoSelectedActions(user)
                : user.getQuickActionIds().stream()
                        .map(this::parseAction)
                        .map(this::toResponse)
                        .toList();

        return new QuickActionSettingsResponse(
                user.isQuickActionsAutoEnabled(),
                QuickAction.MAX_SELECTED,
                selectedActions,
                getAvailableActions()
        );
    }

    private List<QuickActionOptionResponse> getAutoSelectedActions(User user) {
        List<QuickAction> usedActions = usageRepository.findTop10ByUserOrderByUseCountDescLastUsedAtDesc(user).stream()
                .map(QuickActionUsage::getActionId)
                .map(this::parseAction)
                .toList();

        if (usedActions.isEmpty()) {
            usedActions = QuickAction.defaultAutoActions();
        }

        return usedActions.stream()
                .limit(QuickAction.MAX_SELECTED)
                .map(this::toResponse)
                .toList();
    }

    private List<String> sanitizeSelectedActions(List<String> selectedActionIds) {
        if (selectedActionIds == null) {
            return List.of();
        }

        if (selectedActionIds.size() > QuickAction.MAX_SELECTED) {
            throw new IllegalArgumentException("You can select up to " + QuickAction.MAX_SELECTED + " quick actions");
        }

        Set<String> uniqueIds = new LinkedHashSet<>();
        for (String actionId : selectedActionIds) {
            uniqueIds.add(parseAction(actionId).id());
        }
        return List.copyOf(uniqueIds);
    }

    private QuickAction parseAction(String actionId) {
        try {
            QuickAction action = QuickAction.valueOf(actionId);
            if (!action.configurable()) {
                throw new IllegalArgumentException("Action is not available for quick actions: " + actionId);
            }
            return action;
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("Unknown quick action: " + actionId);
        }
    }

    private QuickActionOptionResponse toResponse(QuickAction action) {
        return new QuickActionOptionResponse(
                action.id(),
                action.label(),
                action.method(),
                action.pathTemplate(),
                action.group()
        );
    }

    private User getUser(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User with email " + email + " not found"));
    }
}
