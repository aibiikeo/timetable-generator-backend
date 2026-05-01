package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.User;
import com.example.timetablegenerator.domain.entities.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByEmail(String email);
    Optional<User> findByEmail(String email);
    boolean existsByRole(UserRole role);
    long countByRole(UserRole role);
}
