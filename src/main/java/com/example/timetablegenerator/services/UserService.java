package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.SuperAdminRequest;
import com.example.timetablegenerator.domain.dto.request.UserRequest;
import com.example.timetablegenerator.domain.dto.response.UserResponse;

import java.util.List;
import java.util.Optional;

public interface UserService {

    void createFirstSuperAdmin(SuperAdminRequest request);

    UserResponse createUser(UserRequest request);

    List<UserResponse> getAllUsers();

    Optional<UserResponse> getUser(Long userId);

    UserResponse updateUser(Long userId, UserRequest request);

    void deleteUser(Long userId);

    Optional<UserResponse> getUserByEmail(String email);
}
