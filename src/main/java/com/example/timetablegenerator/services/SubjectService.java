package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.SubjectRequest;
import com.example.timetablegenerator.domain.dto.response.SubjectResponse;
import com.example.timetablegenerator.domain.dto.response.TeacherResponse;

import java.util.List;
import java.util.Optional;

public interface SubjectService {

    List<SubjectResponse> getAllSubjects();

    List<SubjectResponse> getSubjectsByFaculty(Long facultyId);

    List<SubjectResponse> getSubjectsByDepartment(Long departmentId);

    List<SubjectResponse> getSubjectsByMajor(Long majorId);

    Optional<SubjectResponse> getSubjectById(Long subjectId);

    Optional<SubjectResponse> getSubjectByCode(String code);

    SubjectResponse createSubject(SubjectRequest request);

    SubjectResponse updateSubject(Long subjectId, SubjectRequest request);

    void deleteSubject(Long subjectId);

    List<TeacherResponse> getTeachersBySubject(Long subjectId);
}