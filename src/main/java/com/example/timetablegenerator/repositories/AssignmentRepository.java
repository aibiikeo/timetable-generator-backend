package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {
    List<Assignment> findByTimetableId(Long versionId);
    Optional<Assignment> findByIdAndTimetableId(Long id, Long versionId);

    // Удалить группу из всех assignments
    @Modifying
    @Query(value = "DELETE FROM assignment_groups WHERE group_id = :groupId", nativeQuery = true)
    void removeGroupFromAllAssignments(@Param("groupId") Long groupId);

    // Найти assignments по groupId (для проверки)
    @Query("SELECT a FROM Assignment a JOIN a.groups g WHERE g.id = :groupId")
    List<Assignment> findByGroupId(@Param("groupId") Long groupId);

    List<Assignment> findByTeacherId(Long teacherId);

    List<Assignment> findBySubjectId(Long subjectId);
}
