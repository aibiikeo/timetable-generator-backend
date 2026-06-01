package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.QuickActionUsage;
import com.example.timetablegenerator.domain.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface QuickActionUsageRepository extends JpaRepository<QuickActionUsage, Long> {
    Optional<QuickActionUsage> findByUserAndActionId(User user, String actionId);

    List<QuickActionUsage> findTop10ByUserOrderByUseCountDescLastUsedAtDesc(User user);
}
