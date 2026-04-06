package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.StudyGroupRequest;
import com.example.timetablegenerator.domain.dto.response.StudyGroupResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.StudyGroupService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/groups")
@RequiredArgsConstructor
@Slf4j
public class StudyGroupController {

    private final StudyGroupService studyGroupService;

    @GetMapping
    public List<StudyGroupResponse> getAllGroups() {
        log.debug("Fetching all study groups");
        return studyGroupService.getAllGroups();
    }

    @GetMapping("/faculty/{facultyId}")
    public List<StudyGroupResponse> getGroupsByFaculty(@PathVariable Long facultyId) {
        log.debug("Fetching study groups for faculty ID: {}", facultyId);
        return studyGroupService.getGroupsByFaculty(facultyId);
    }

    @GetMapping("/department/{departmentId}")
    public List<StudyGroupResponse> getGroupsByDepartment(@PathVariable Long departmentId) {
        log.debug("Fetching study groups for department ID: {}", departmentId);
        return studyGroupService.getGroupsByDepartment(departmentId);
    }

    @GetMapping("/major/{majorId}")
    public List<StudyGroupResponse> getGroupsByMajor(@PathVariable Long majorId) {
        log.debug("Fetching study groups for major ID: {}", majorId);
        return studyGroupService.getGroupsByMajor(majorId);
    }

    @GetMapping("/{id}")
    public StudyGroupResponse getGroup(@PathVariable Long id) {
        log.debug("Fetching study group with ID: {}", id);
        return studyGroupService.getGroup(id)
                .orElseThrow(() -> new NotFoundException("Study group with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public StudyGroupResponse createGroup(@Valid @RequestBody StudyGroupRequest request) {
        log.info("Creating new study group: {} (majorId: {}, course: {}, studentCount: {})",
                request.name(), request.majorId(), request.course(), request.studentCount());
        return studyGroupService.createGroup(request);
    }

    @PutMapping("/{id}")
    public StudyGroupResponse updateGroup(
            @PathVariable Long id,
            @Valid @RequestBody StudyGroupRequest request
    ) {
        log.info("Updating study group ID: {} -> new name: {}, majorId: {}",
                id, request.name(), request.majorId());
        return studyGroupService.updateGroup(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteGroup(@PathVariable Long id) {
        log.info("Deleting study group with ID: {}", id);
        studyGroupService.deleteGroup(id);
    }
}