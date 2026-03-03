package com.example.timetablegenerator.services;

import com.example.timetablegenerator.domain.dto.request.RoomRequest;
import com.example.timetablegenerator.domain.dto.response.RoomResponse;
import com.example.timetablegenerator.domain.entities.RoomType;

import java.util.List;
import java.util.Optional;

public interface RoomService {

    List<RoomResponse> getAllRooms();

    List<RoomResponse> getRoomsByType(RoomType type);

    Optional<RoomResponse> getRoom(Long roomId);

    RoomResponse createRoom(RoomRequest request);

    RoomResponse updateRoom(Long roomId, RoomRequest request);

    void deleteRoom(Long roomId);
}
