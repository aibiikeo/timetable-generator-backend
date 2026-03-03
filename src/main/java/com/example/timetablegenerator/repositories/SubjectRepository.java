package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Subject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, Long> {
    Optional<Subject> findByCode(String code);
    List<Subject> findByFacultyId(Long facultyId);
}
