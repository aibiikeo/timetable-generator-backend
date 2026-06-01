package com.example.timetablegenerator.domain.quickactions;

import java.util.Arrays;
import java.util.List;

public enum QuickAction {
    OPEN_TIMETABLES("Open timetables", "GET", "/api/timetables", "Timetables", true),
    NEW_TIMETABLE("New timetable", "POST", "/api/timetables", "Timetables", true),
    ADD_ASSIGNMENT("Add assignment", "POST", "/api/timetables/{timetableId}/assignments", "Assignments", true),
    OPEN_ASSIGNMENTS("Open assignments", "GET", "/api/timetables/{timetableId}/assignments", "Assignments", true),
    OPEN_TEACHERS("Open teachers", "GET", "/api/teachers", "Teachers", true),
    ADD_TEACHER("Add teacher", "POST", "/api/teachers", "Teachers", true),
    OPEN_ROOMS("Open rooms", "GET", "/api/rooms", "Rooms", true),
    ADD_ROOM("Add room", "POST", "/api/rooms", "Rooms", true),
    OPEN_SUBJECTS("Open subjects", "GET", "/api/subjects", "Subjects", true),
    ADD_SUBJECT("Add subject", "POST", "/api/subjects", "Subjects", true),
    OPEN_GROUPS("Open groups", "GET", "/api/groups", "Groups", true),
    ADD_GROUP("Add group", "POST", "/api/groups", "Groups", true),
    OPEN_MAJORS("Open majors", "GET", "/api/majors", "Majors", true),
    ADD_MAJOR("Add major", "POST", "/api/majors", "Majors", true),
    OPEN_FACULTIES("Open faculties", "GET", "/api/faculties", "Faculties", true),
    ADD_FACULTY("Add faculty", "POST", "/api/faculties", "Faculties", true),
    OPEN_DEPARTMENTS("Open departments", "GET", "/api/departments", "Departments", true),
    ADD_DEPARTMENT("Add department", "POST", "/api/departments", "Departments", true);

    public static final int MAX_SELECTED = 10;

    private final String label;
    private final String method;
    private final String pathTemplate;
    private final String group;
    private final boolean configurable;

    QuickAction(String label, String method, String pathTemplate, String group, boolean configurable) {
        this.label = label;
        this.method = method;
        this.pathTemplate = pathTemplate;
        this.group = group;
        this.configurable = configurable;
    }

    public String id() {
        return name();
    }

    public String label() {
        return label;
    }

    public String method() {
        return method;
    }

    public String pathTemplate() {
        return pathTemplate;
    }

    public String group() {
        return group;
    }

    public boolean configurable() {
        return configurable;
    }

    public static List<QuickAction> configurableActions() {
        return Arrays.stream(values())
                .filter(QuickAction::configurable)
                .toList();
    }

    public static List<QuickAction> defaultAutoActions() {
        return List.of(
                OPEN_TIMETABLES,
                NEW_TIMETABLE,
                ADD_ASSIGNMENT,
                OPEN_TEACHERS,
                OPEN_ROOMS,
                OPEN_SUBJECTS,
                OPEN_GROUPS,
                OPEN_MAJORS,
                OPEN_FACULTIES,
                OPEN_DEPARTMENTS,
                ADD_TEACHER
        );
    }
}
