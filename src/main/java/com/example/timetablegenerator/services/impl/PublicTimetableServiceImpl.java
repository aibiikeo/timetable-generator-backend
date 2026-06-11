package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.response.PublicFilterOptionResponse;
import com.example.timetablegenerator.domain.dto.response.LunchResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableFilterOptionsResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableLessonResponse;
import com.example.timetablegenerator.domain.dto.response.PublicTimetableScheduleResponse;
import com.example.timetablegenerator.domain.dto.response.TimetableResponse;
import com.example.timetablegenerator.domain.entities.Department;
import com.example.timetablegenerator.domain.entities.Degree;
import com.example.timetablegenerator.domain.entities.Faculty;
import com.example.timetablegenerator.domain.entities.Lunch;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Major;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.StudyGroup;
import com.example.timetablegenerator.domain.entities.Subject;
import com.example.timetablegenerator.domain.entities.Teacher;
import com.example.timetablegenerator.domain.entities.Timetable;
import com.example.timetablegenerator.domain.entities.TimetableStatus;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.DepartmentRepository;
import com.example.timetablegenerator.repositories.FacultyRepository;
import com.example.timetablegenerator.repositories.LunchRepository;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.repositories.StudyGroupRepository;
import com.example.timetablegenerator.repositories.TeacherRepository;
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
    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final StudyGroupRepository studyGroupRepository;
    private final TeacherRepository teacherRepository;
    private final RoomRepository roomRepository;
    private final LunchRepository lunchRepository;

    @Override
    public PublicTimetableFilterOptionsResponse getFilterOptions(Long facultyId, Long departmentId) {
        List<Department> departments = facultyId != null
                ? departmentRepository.findByFacultyId(facultyId)
                : departmentRepository.findAll();

        List<StudyGroup> groups;
        if (departmentId != null) {
            groups = studyGroupRepository.findByMajorDepartmentId(departmentId);
        } else if (facultyId != null) {
            groups = studyGroupRepository.findByMajorDepartmentFacultyId(facultyId);
        } else {
            groups = studyGroupRepository.findAll();
        }

        return new PublicTimetableFilterOptionsResponse(
                distinctOptions(facultyRepository.findAll().stream(), Faculty::getId, Faculty::getName),
                distinctOptions(departments.stream(), Department::getId, Department::getName),
                distinctOptions(groups.stream(), StudyGroup::getId, StudyGroup::getName),
                distinctOptions(teacherRepository.findAll().stream(), Teacher::getId, Teacher::getFullName),
                distinctOptions(roomRepository.findAll().stream(), Room::getId, Room::getName)
        );
    }

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
        List<Timetable> publishedTimetables = getPublishedTimetables();
        TimetableResponse timetableResponse = publishedTimetables.stream()
                .max(Comparator.comparing(Timetable::getCreatedAt))
                .map(this::toTimetableSummary)
                .orElse(null);

        List<PublicTimetableLessonResponse> lessons = publishedTimetables.stream()
                .flatMap(timetable -> getPublishedLessons(timetable).stream())
                .filter(this::hasScheduleTime)
                .filter(lesson -> matches(facultyId, faculty(lesson), Faculty::getId))
                .filter(lesson -> matches(departmentId, department(lesson), Department::getId))
                .filter(lesson -> matches(majorId, major(lesson), Major::getId))
                .filter(lesson -> matches(teacherId, lesson.getTeacher(), Teacher::getId))
                .filter(lesson -> matches(subjectId, lesson.getSubject(), Subject::getId))
                .filter(lesson -> matches(roomId, lesson.getRoom(), Room::getId))
                .filter(lesson -> dayOfWeek == null || dayOfWeek.equals(lesson.getDayOfWeek()))
                .filter(lesson -> groupId == null || lesson.getGroups().stream().anyMatch(group -> groupId.equals(group.getId())))
                .map(this::toPublicLesson)
                .filter(Objects::nonNull)
                .toList();

        Map<Long, StudyGroup> groupsById = studyGroupRepository.findAll().stream()
                .collect(Collectors.toMap(StudyGroup::getId, Function.identity(), (existing, ignored) -> existing));

        List<LunchResponse> lunches = publishedTimetables.stream()
                .flatMap(timetable -> lunchRepository.findByTimetableId(timetable.getId()).stream())
                .filter(lunch -> matches(facultyId, faculty(groupsById.get(lunch.getGroupId())), Faculty::getId))
                .filter(lunch -> matches(departmentId, department(groupsById.get(lunch.getGroupId())), Department::getId))
                .filter(lunch -> matches(majorId, major(groupsById.get(lunch.getGroupId())), Major::getId))
                .filter(lunch -> groupId == null || groupId.equals(lunch.getGroupId()))
                .filter(lunch -> dayOfWeek == null || dayOfWeek.equals(lunch.getDayOfWeek()))
                .map(this::toLunchResponse)
                .sorted(Comparator
                        .comparing(LunchResponse::getDayOfWeek)
                        .thenComparing(LunchResponse::getStartTime)
                        .thenComparing(LunchResponse::getGroupId))
                .toList();

        return new PublicTimetableScheduleResponse(timetableResponse, lessons.size(), lessons, lunches);
    }

    private TimetableResponse toTimetableSummary(Timetable timetable) {
        Faculty faculty = timetable.getFaculty();
        return new TimetableResponse(
                timetable.getId(),
                timetable.getName(),
                timetable.getAcademicYearStart(),
                timetable.getAcademicYearEnd(),
                timetable.getSemester(),
                faculty != null ? faculty.getId() : null,
                faculty != null ? faculty.getName() : null,
                timetable.getVersion(),
                timetable.getCreatedAt(),
                timetable.getStatus(),
                timetable.getConflictReport(),
                List.of(),
                0,
                0,
                0,
                0,
                0,
                0
        );
    }

    private boolean hasScheduleTime(Lesson lesson) {
        return lesson.getDayOfWeek() != null
                && lesson.getStartTime() != null
                && lesson.getDurationHours() != null;
    }

    private List<Timetable> getPublishedTimetables() {
        List<Timetable> timetables = timetableRepository.findAllByStatus(TimetableStatus.PUBLISHED);
        if (timetables.isEmpty()) {
            throw new NotFoundException("No published timetable found");
        }
        return timetables;
    }

    private List<Lesson> getPublishedLessons(Timetable timetable) {
        return lessonRepository.findByTimetableIdOrderByDayOfWeekAscStartTimeAsc(timetable.getId());
    }

    private PublicTimetableLessonResponse toPublicLesson(Lesson lesson) {
        Subject subject = lesson.getSubject();
        Major major = major(lesson);
        Department department = department(lesson);
        Faculty faculty = faculty(lesson);
        Teacher teacher = lesson.getTeacher();
        Room room = lesson.getRoom();

        if (subject == null || major == null || department == null || faculty == null) {
            return null;
        }

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
                degree(lesson),
                subject.getId(),
                subject.getName(),
                teacher != null ? teacher.getId() : null,
                teacher != null ? teacher.getFullName() : null,
                room != null ? room.getId() : null,
                room != null ? room.getName() : null,
                distinctOptions(lesson.getGroups().stream(), StudyGroup::getId, StudyGroup::getName)
        );
    }

    private LocalTime endTime(Lesson lesson) {
        return lesson.getStartTime().plusHours(lesson.getDurationHours());
    }

    private Faculty faculty(Lesson lesson) {
        Department department = department(lesson);
        return department != null ? department.getFaculty() : null;
    }

    private Department department(Lesson lesson) {
        Major major = major(lesson);
        return major != null ? major.getDepartment() : null;
    }

    private Major major(Lesson lesson) {
        Subject subject = lesson.getSubject();
        return subject != null ? subject.getMajor() : null;
    }

    private Degree degree(Lesson lesson) {
        return lesson.getGroups().stream()
                .map(StudyGroup::getDegree)
                .filter(Objects::nonNull).min(Comparator.comparing(Enum::name))
                .orElse(null);
    }

    private LunchResponse toLunchResponse(Lunch lunch) {
        return LunchResponse.builder()
                .id(lunch.getId())
                .timetableId(lunch.getTimetableId())
                .groupId(lunch.getGroupId())
                .dayOfWeek(lunch.getDayOfWeek())
                .startTime(lunch.getStartTime())
                .endTime(lunch.getEndTime())
                .manual(lunch.isManual())
                .build();
    }

    private Faculty faculty(StudyGroup group) {
        Department department = department(group);
        return department != null ? department.getFaculty() : null;
    }

    private Department department(StudyGroup group) {
        Major major = major(group);
        return major != null ? major.getDepartment() : null;
    }

    private Major major(StudyGroup group) {
        return group != null ? group.getMajor() : null;
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
