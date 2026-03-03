package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Long> {
}
