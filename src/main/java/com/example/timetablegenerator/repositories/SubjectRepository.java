package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Subject;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SubjectRepository extends JpaRepository<Subject, Long> {

    Optional<Subject> findByCode(String code);

    boolean existsByCode(String code);

    List<Subject> findByMajorId(Long majorId);

    List<Subject> findByMajorDepartmentId(Long departmentId);

    List<Subject> findByMajorDepartmentFacultyId(Long facultyId);
}