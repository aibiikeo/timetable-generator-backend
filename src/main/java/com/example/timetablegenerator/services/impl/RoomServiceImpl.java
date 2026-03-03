package com.example.timetablegenerator.services.impl;

import com.example.timetablegenerator.domain.dto.request.RoomRequest;
import com.example.timetablegenerator.domain.dto.response.RoomResponse;
import com.example.timetablegenerator.domain.entities.Room;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.mappers.RoomMapper;
import com.example.timetablegenerator.repositories.RoomRepository;
import com.example.timetablegenerator.services.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Validated
@Transactional(readOnly = true)
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final RoomMapper roomMapper;

    @Override
    public List<RoomResponse> getAllRooms() {
        return roomRepository.findAll().stream()
                .map(roomMapper::toResponse)
                .toList();
    }

    @Override
    public List<RoomResponse> getRoomsByType(RoomType type) {
        return roomRepository.findByType(type).stream()
                .map(roomMapper::toResponse)
                .toList();
    }

    @Override
    public Optional<RoomResponse> getRoom(Long roomId) {
        return roomRepository.findById(roomId)
                .map(roomMapper::toResponse);
    }

    @Transactional
    @Override
    public RoomResponse createRoom(RoomRequest request) {
        Room room = roomMapper.toEntity(request);
        Room saved = roomRepository.save(room);
        return roomMapper.toResponse(saved);
    }

    @Transactional
    @Override
    public RoomResponse updateRoom(Long roomId, RoomRequest request) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("Room not found with id: " + roomId));

        roomMapper.updateEntityFromRequest(request, room);

        Room updated = roomRepository.save(room);
        return roomMapper.toResponse(updated);
    }

    @Transactional
    @Override
    public void deleteRoom(Long roomId) {
        if (!roomRepository.existsById(roomId)) {
            throw new NotFoundException("Room not found with id: " + roomId);
        }
        roomRepository.deleteById(roomId);
    }
}