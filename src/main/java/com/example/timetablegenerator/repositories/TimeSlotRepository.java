package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.TimeSlot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.DayOfWeek;
import java.util.List;

@Repository
public interface TimeSlotRepository extends JpaRepository<TimeSlot, Long> {
    @Query("SELECT ts FROM TimeSlot ts WHERE (ts.dayOfWeek IS NULL OR ts.dayOfWeek = :day) ORDER BY ts.order")
    List<TimeSlot> findByDayOfWeek(@Param("day") DayOfWeek day);

    @Query("SELECT ts FROM TimeSlot ts WHERE (ts.dayOfWeek IS NULL OR ts.dayOfWeek = :day) AND ts.isLunch = false ORDER BY ts.order")
    List<TimeSlot> findLessonSlotsByDay(@Param("day") DayOfWeek day);
}