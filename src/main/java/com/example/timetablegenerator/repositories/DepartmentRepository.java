package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Department;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface DepartmentRepository extends JpaRepository<Department, Long> {

    List<Department> findByFacultyId(Long facultyId);

    Optional<Department> findByNameIgnoreCaseAndFacultyId(String name, Long facultyId);

}