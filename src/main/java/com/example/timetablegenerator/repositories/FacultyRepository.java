package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Faculty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {

    Optional<Faculty> findByNameIgnoreCase(String name);

    boolean existsByNameIgnoreCase(String name);
}
