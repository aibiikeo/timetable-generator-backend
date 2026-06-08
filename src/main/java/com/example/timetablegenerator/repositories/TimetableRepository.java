package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Semester;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.domain.entities.TimetableStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TimetableRepository extends JpaRepository<Timetable, Long> {

    @Query("""
            SELECT MAX(t.version) FROM Timetable t
            WHERE t.academicYearStart = :yearStart
              AND t.semester = :semester
              AND t.faculty.id = :facultyId
            """)
    Integer findMaxVersion(Integer yearStart, Semester semester, Long facultyId);

    List<Timetable> findAllByOrderByCreatedAtDesc();

    Optional<Timetable> findFirstByStatusOrderByCreatedAtDesc(TimetableStatus status);

    Optional<Timetable> findFirstByStatusAndFacultyIdOrderByCreatedAtDesc(TimetableStatus status, Long facultyId);

    List<Timetable> findAllByStatus(TimetableStatus status);

    List<Timetable> findAllByStatusAndFacultyId(TimetableStatus status, Long facultyId);

    List<Timetable> findAllByAcademicYearStartAndSemesterOrderByVersionDesc(
            Integer academicYearStart,
            Semester semester
    );

    Optional<Timetable> findFirstByAcademicYearStartAndSemesterOrderByVersionDesc(
            Integer academicYearStart,
            Semester semester
    );
}
