package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Major;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MajorRepository extends JpaRepository<Major, Long> {

    List<Major> findByDepartmentId(Long departmentId);

    List<Major> findByDepartmentFacultyId(Long facultyId);
}