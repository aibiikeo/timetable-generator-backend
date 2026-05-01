package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.SuperAdminRequest;
import com.example.timetablegenerator.domain.dto.request.UserRequest;
import com.example.timetablegenerator.domain.dto.response.UserResponse;
import com.example.timetablegenerator.domain.entities.User;
import com.example.timetablegenerator.domain.entities.UserRole;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.UserMapper;
import com.example.timetablegenerator.repositories.UserRepository;
import com.example.timetablegenerator.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void createFirstSuperAdmin(SuperAdminRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            log.warn("Attempt to create super admin with existing email: {}", request.email());
            throw new IllegalArgumentException("Email is already in use: " + request.email());
        }

        User superAdmin = User.builder()
                .email(request.email())
                .password(passwordEncoder.encode(request.password()))
                .role(UserRole.SUPER_ADMIN)
                .build();

        userRepository.save(superAdmin);
        log.info("Super admin created successfully: {}", request.email());
    }

    @Override
    @Transactional
    public UserResponse createUser(UserRequest request) {
        validateEmailUniqueness(request.email(), null);

        User user = userMapper.toEntity(request);
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setRole(request.role());

        User saved = userRepository.save(user);
        log.info("User created with ID: {}", saved.getId());

        return userMapper.toResponse(saved);
    }

    @Override
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(userMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<UserResponse> getUser(Long userId) {
        return userRepository.findById(userId)
                .map(userMapper::toResponse);
    }

    @Override
    @Transactional
    public UserResponse updateUser(Long userId, UserRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        validateEmailUniqueness(request.email(), userId);

        user.setEmail(request.email());
        user.setRole(request.role());

        if (request.password() != null && !request.password().isBlank()) {
            user.setPassword(passwordEncoder.encode(request.password()));
            log.debug("Password updated for user ID: {}", userId);
        }

        User updated = userRepository.save(user);
        log.info("User updated with ID: {}", userId);

        return userMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found with id: " + userId));

        if (user.getRole() == UserRole.SUPER_ADMIN) {
            long superAdminCount = userRepository.countByRole(UserRole.SUPER_ADMIN);

            if (superAdminCount <= 1) {
                throw new IllegalStateException("Cannot delete the last SUPER_ADMIN user");
            }
        }

        userRepository.delete(user);

        log.info("User deleted with ID: {}", userId);
    }

    @Override
    public Optional<UserResponse> getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(user -> new UserResponse(
                        user.getId(),
                        user.getEmail(),
                        user.getRole()
                ));
    }

    private void validateEmailUniqueness(String email, Long excludeUserId) {
        if (userRepository.existsByEmail(email)) {
            if (excludeUserId != null) {
                userRepository.findByEmail(email).ifPresent(user -> {
                    if (!user.getId().equals(excludeUserId)) {
                        throw new IllegalArgumentException("Email is already in use: " + email);
                    }
                });
            } else {
                throw new IllegalArgumentException("Email is already in use: " + email);
            }
        }
    }
}