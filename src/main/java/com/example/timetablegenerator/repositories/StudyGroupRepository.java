package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.StudyGroup;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface StudyGroupRepository extends JpaRepository<StudyGroup, Long> {

    Optional<StudyGroup> findByName(String name);

    boolean existsByName(String name);

    List<StudyGroup> findByMajorId(Long majorId);

    List<StudyGroup> findByMajorDepartmentId(Long departmentId);

    List<StudyGroup> findByMajorDepartmentFacultyId(Long facultyId);
}