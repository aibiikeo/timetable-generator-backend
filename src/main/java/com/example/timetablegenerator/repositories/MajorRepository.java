package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Major;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MajorRepository extends JpaRepository<Major, Long> {

    List<Major> findByDepartmentId(Long departmentId);

    List<Major> findByDepartment_Faculty_Id(Long facultyId);

    Optional<Major> findByNameIgnoreCaseAndDepartmentId(String name, Long departmentId);
}