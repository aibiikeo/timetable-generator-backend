package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.TeacherRequest;
import com.example.timetablegenerator.domain.dto.response.AssignmentResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;

import java.util.List;
import java.util.Optional;

public interface TeacherService {

    List<TeacherResponse> getAllTeachers();

    Optional<TeacherResponse> getTeacher(Long teacherId);

    TeacherResponse createTeacher(TeacherRequest request);

    TeacherResponse updateTeacher(Long teacherId, TeacherRequest request);

    List<AssignmentResponse> getAssignmentsByTeacherId(Long teacherId);  // новый метод

    void deleteTeacher(Long teacherId, DeleteMode mode);
}
