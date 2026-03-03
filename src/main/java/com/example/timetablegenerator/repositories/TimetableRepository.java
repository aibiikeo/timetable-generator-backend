package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Timetable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TimetableRepository extends JpaRepository<Timetable, Long> {
}
