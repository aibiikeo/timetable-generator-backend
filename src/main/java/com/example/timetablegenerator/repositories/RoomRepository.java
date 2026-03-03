package com.example.timetablegenerator.repositories;

import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    List<Room> findByType(RoomType type);

    List<Room> findByTypeAndCapacityGreaterThanEqual(RoomType type, int capacity);
}
