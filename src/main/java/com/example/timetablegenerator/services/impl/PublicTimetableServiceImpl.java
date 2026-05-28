package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.response.PublicFilterOptionResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableLessonResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableScheduleResponse;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.domain.entities.Teacher;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.domain.entities.TimetableStatus;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.TimetableMapper;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.TimetableRepository;
import com.example.timetablegenerator.services.PublicTimetableService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PublicTimetableServiceImpl implements PublicTimetableService {

    private final TimetableRepository timetableRepository;
    private final LessonRepository lessonRepository;
    private final TimetableMapper timetableMapper;

    @Override
    public PublicTimetableScheduleResponse getSchedule(
            Long facultyId,
            Long departmentId,
            Long majorId,
            Long groupId,
            Long teacherId,
            Long subjectId,
            Long roomId,
            DayOfWeek dayOfWeek
    ) {
        Timetable timetable = getPublishedTimetable();
        TimetableResponse timetableResponse = timetableMapper.toResponse(timetable);

        List<PublicTimetableLessonResponse> lessons = getPublishedLessons(timetable).stream()
                .filter(lesson -> matches(facultyId, faculty(lesson), Faculty::getId))
                .filter(lesson -> matches(departmentId, department(lesson), Department::getId))
                .filter(lesson -> matches(majorId, major(lesson), Major::getId))
                .filter(lesson -> matches(teacherId, lesson.getTeacher(), Teacher::getId))
                .filter(lesson -> matches(subjectId, lesson.getSubject(), Subject::getId))
                .filter(lesson -> matches(roomId, lesson.getRoom(), Room::getId))
                .filter(lesson -> dayOfWeek == null || dayOfWeek.equals(lesson.getDayOfWeek()))
                .filter(lesson -> groupId == null || lesson.getGroups().stream().anyMatch(group -> groupId.equals(group.getId())))
                .map(this::toPublicLesson)
                .toList();

        return new PublicTimetableScheduleResponse(timetableResponse, lessons.size(), lessons);
    }

    private Timetable getPublishedTimetable() {
        return timetableRepository.findFirstByStatusOrderByCreatedAtDesc(TimetableStatus.PUBLISHED)
                .orElseThrow(() -> new NotFoundException("No published timetable found"));
    }

    private List<Lesson> getPublishedLessons(Timetable timetable) {
        return lessonRepository.findByTimetableIdOrderByDayOfWeekAscStartTimeAsc(timetable.getId());
    }

    private PublicTimetableLessonResponse toPublicLesson(Lesson lesson) {
        Subject subject = lesson.getSubject();
        Major major = subject.getMajor();
        Department department = major.getDepartment();
        Faculty faculty = department.getFaculty();
        Teacher teacher = lesson.getTeacher();
        Room room = lesson.getRoom();

        return new PublicTimetableLessonResponse(
                lesson.getId(),
                lesson.getTimetable().getId(),
                lesson.getTimetable().getName(),
                lesson.getDayOfWeek(),
                lesson.getStartTime(),
                endTime(lesson),
                lesson.getDurationHours(),
                faculty.getId(),
                faculty.getName(),
                department.getId(),
                department.getName(),
                major.getId(),
                major.getName(),
                major.getDegree(),
                subject.getId(),
                subject.getName(),
                teacher.getId(),
                teacher.getFullName(),
                room != null ? room.getId() : null,
                room != null ? room.getName() : null,
                distinctOptions(lesson.getGroups().stream(), StudyGroup::getId, StudyGroup::getName)
        );
    }

    private LocalTime endTime(Lesson lesson) {
        return lesson.getStartTime().plusHours(lesson.getDurationHours());
    }

    private Faculty faculty(Lesson lesson) {
        return department(lesson).getFaculty();
    }

    private Department department(Lesson lesson) {
        return major(lesson).getDepartment();
    }

    private Major major(Lesson lesson) {
        return lesson.getSubject().getMajor();
    }

    private <T> boolean matches(Long expectedId, T entity, Function<T, Long> idGetter) {
        return expectedId == null || (entity != null && expectedId.equals(idGetter.apply(entity)));
    }

    private <T> List<PublicFilterOptionResponse> distinctOptions(
            Stream<T> entities,
            Function<T, Long> idGetter,
            Function<T, String> nameGetter
    ) {
        Map<Long, String> namesById = entities
                .filter(Objects::nonNull)
                .collect(Collectors.toMap(
                        idGetter,
                        nameGetter,
                        (existing, ignored) -> existing
                ));

        return namesById.entrySet().stream()
                .map(entry -> new PublicFilterOptionResponse(entry.getKey(), entry.getValue()))
                .sorted(Comparator.comparing(PublicFilterOptionResponse::name, String.CASE_INSENSITIVE_ORDER))
                .toList();
    }
}
