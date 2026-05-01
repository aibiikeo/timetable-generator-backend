package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;

import java.util.List;
import java.util.Optional;

public interface StudyGroupService {

    List<StudyGroupResponse> getAllGroups();

    List<StudyGroupResponse> getGroupsByFaculty(Long facultyId);

    List<StudyGroupResponse> getGroupsByDepartment(Long departmentId);

    List<StudyGroupResponse> getGroupsByMajor(Long majorId);

    Optional<StudyGroupResponse> getGroup(Long groupId);

    StudyGroupResponse createGroup(StudyGroupRequest request);

    StudyGroupResponse updateGroup(Long groupId, StudyGroupRequest request);

    void deleteGroup(Long groupId, DeleteMode mode);
}