package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.RoomRequest;
import com.example.timetablegenerator.domain.dto.response.RoomResponse;
import com.example.timetablegenerator.domain.entities.Lesson;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.RoomMapper;
import com.example.timetablegenerator.repositories.LessonRepository;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.services.RoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final LessonRepository lessonRepository;
    private final RoomMapper roomMapper;

    @Override
    public List<RoomResponse> getAllRooms() {
        return roomRepository.findAll()
                .stream()
                .map(roomMapper::toResponse)
                .toList();
    }

    @Override
    public List<RoomResponse> getRoomsByType(RoomType type) {
        return roomRepository.findByType(type)
                .stream()
                .map(roomMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<RoomResponse> getRoom(Long roomId) {
        return roomRepository.findById(roomId)
                .map(roomMapper::toResponse);
    }

    @Override
    @Transactional
    public RoomResponse createRoom(RoomRequest request) {
        String normalizedName = normalize(request.name());

        boolean exists = roomRepository.findAll().stream()
                .anyMatch(room -> room.getName() != null && room.getName().equalsIgnoreCase(normalizedName));

        if (exists) {
            throw new IllegalStateException("Room with name '" + normalizedName + "' already exists");
        }

        Room room = Room.builder()
                .name(normalizedName)
                .capacity(request.capacity())
                .type(request.type())
                .build();

        Room saved = roomRepository.save(room);
        log.info("app | Created room with id={}", saved.getId());

        return roomMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public RoomResponse updateRoom(Long roomId, RoomRequest request) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found with id: " + roomId));

        String normalizedName = normalize(request.name());

        boolean exists = roomRepository.findAll().stream()
                .anyMatch(existing ->
                        existing.getName() != null &&
                                existing.getName().equalsIgnoreCase(normalizedName) &&
                                !existing.getId().equals(roomId)
                );

        if (exists) {
            throw new IllegalStateException("Room with name '" + normalizedName + "' already exists");
        }

        room.setName(normalizedName);
        room.setCapacity(request.capacity());
        room.setType(request.type());

        Room updated = roomRepository.save(room);
        log.info("app | Updated room with id={}", updated.getId());

        return roomMapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteRoom(Long roomId, DeleteMode mode) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found with id: " + roomId));

        List<Lesson> lessons = lessonRepository.findAll()
                .stream()
                .filter(lesson -> lesson.getRoom() != null && lesson.getRoom().getId().equals(roomId))
                .toList();

        switch (mode) {
            case SIMPLE -> {
                if (!lessons.isEmpty()) {
                    throw new IllegalStateException(
                            "Cannot delete room with id " + roomId +
                                    " because it is used in " + lessons.size() + " lessons"
                    );
                }
            }

            case DETACH -> {
                for (Lesson lesson : lessons) {
                    lesson.setRoom(null);
                }
                lessonRepository.saveAll(lessons);
            }

            case WITH -> lessonRepository.deleteAll(lessons);
        }

        roomRepository.delete(room);
        log.info("app | Deleted room with id={} using mode={}", roomId, mode);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Room name must not be blank");
        }
        return value.trim();
    }
}