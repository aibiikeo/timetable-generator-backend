package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.UserRequest;
import com.example.timetablegenerator.domain.dto.response.UserResponse;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.UserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Users")
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Slf4j
public class UserController {

    private final UserService userService;

    @GetMapping
    public List<UserResponse> getAllUsers() {
        log.debug("Fetching all users");
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public UserResponse getUser(@PathVariable Long id) {
        log.debug("Fetching user with ID: {}", id);
        return userService.getUser(id)
                .orElseThrow(() -> new NotFoundException("User with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse createUser(@Valid @RequestBody UserRequest request) {
        log.info("Creating new user with email: {}", request.email());
        return userService.createUser(request);
    }

    @PutMapping("/{id}")
    public UserResponse updateUser(@PathVariable Long id, @Valid @RequestBody UserRequest request) {
        log.info("Updating user ID: {}", id);
        return userService.updateUser(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable Long id) {
        log.info("Deleting user ID: {}", id);
        userService.deleteUser(id);
    }

    @GetMapping("/id-by-email")
    public Long getUserIdByEmail(@RequestParam String email) {
        return userService.getUserByEmail(email)
                .map(UserResponse::id)
                .orElseThrow(() -> new NotFoundException("User with email " + email + " not found"));
    }
}