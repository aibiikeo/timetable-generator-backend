package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    List<Lesson> findByTimetableId(Long timetableId);
    Optional<Lesson> findByTimetableIdAndId(Long timetableId, Long id);

    List<Lesson> findByAssignmentId(Long assignmentId);

    List<Lesson> findByTeacher_IdAndTimetableId(Long teacherId, Long timetableId);
    List<Lesson> findByRoom_IdAndTimetableId(Long roomId, Long timetableId);

    @Query("SELECT l FROM Lesson l JOIN l.groups g WHERE g.id = :groupId AND l.timetable.id = :timetableId")
    List<Lesson> findByGroupIdAndTimetableId(@Param("groupId") Long groupId, @Param("timetableId") Long timetableId);

    @Query("SELECT l FROM Lesson l JOIN l.groups g WHERE g.id = :groupId")
    List<Lesson> findByGroupId(@Param("groupId") Long groupId);

    @Modifying
    @Query("UPDATE Lesson l SET l.teacher = null WHERE l.teacher.id = :teacherId")
    void detachTeacher(@Param("teacherId") Long teacherId);

    @Modifying
    @Query("UPDATE Lesson l SET l.assignment = null WHERE l.assignment.id IN :assignmentIds")
    void detachAssignments(@Param("assignmentIds") List<Long> assignmentIds);

    List<Lesson> findBySubjectId(Long subjectId);

    boolean existsByTimetableIdAndTeacherIdAndDayOfWeekAndStartTime(
            Long timetableId, Long teacherId, DayOfWeek dayOfWeek, LocalTime startTime);

    @Query("SELECT COUNT(l) > 0 FROM Lesson l JOIN l.groups g WHERE l.timetable.id = :timetableId AND g.id = :groupId AND l.dayOfWeek = :dayOfWeek AND l.startTime = :startTime")
    boolean existsByTimetableIdAndGroupIdAndDayOfWeekAndStartTime(
            @Param("timetableId") Long timetableId,
            @Param("groupId") Long groupId,
            @Param("dayOfWeek") DayOfWeek dayOfWeek,
            @Param("startTime") LocalTime startTime);

    boolean existsByTimetableIdAndRoomIdAndDayOfWeekAndStartTime(
            Long timetableId, Long roomId, DayOfWeek dayOfWeek, LocalTime startTime);
}