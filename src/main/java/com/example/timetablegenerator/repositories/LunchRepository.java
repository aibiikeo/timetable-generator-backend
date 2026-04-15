package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Lunch;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.DayOfWeek;
import java.util.List;
import java.util.Optional;

public interface LunchRepository extends JpaRepository<Lunch, Long> {

    List<Lunch> findByTimetableId(Long timetableId);

    List<Lunch> findByTimetableIdAndGroupId(Long timetableId, Long groupId);

    List<Lunch> findByTimetableIdAndDayOfWeek(Long timetableId, DayOfWeek dayOfWeek);

    Optional<Lunch> findByTimetableIdAndGroupIdAndDayOfWeek(
            Long timetableId,
            Long groupId,
            DayOfWeek dayOfWeek
    );

    void deleteByTimetableId(Long timetableId);

    void deleteByTimetableIdAndGroupId(Long timetableId, Long groupId);
}