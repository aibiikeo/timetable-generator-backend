package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.StudyGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface StudyGroupRepository extends JpaRepository<StudyGroup, Long> {
    List<StudyGroup> findByFacultyId(Long facultyId);

    @Query("SELECT SUM(g.studentCount) FROM StudyGroup g WHERE g.id IN :groupIds")
    Integer sumStudentsByIds(@Param("groupIds") Set<Long> groupIds);
}
