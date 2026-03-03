package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Faculty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {
}
