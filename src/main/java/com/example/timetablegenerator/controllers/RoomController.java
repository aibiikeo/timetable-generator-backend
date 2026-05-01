package com.example.timetablegenerator.controllers;

import com.example.timetablegenerator.domain.dto.request.DeleteMode;
import com.example.timetablegenerator.domain.dto.request.RoomRequest;
import com.example.timetablegenerator.domain.dto.response.RoomResponse;
import com.example.timetablegenerator.domain.entities.RoomType;
import com.example.timetablegenerator.exceptions.NotFoundException;
import com.example.timetablegenerator.services.RoomService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Tag(name = "Rooms")
@RequestMapping("/api/rooms")
@RequiredArgsConstructor
@Slf4j
public class RoomController {

    private final RoomService roomService;

    @GetMapping
    public List<RoomResponse> getAllRooms() {
        log.debug("Fetching all rooms");
        return roomService.getAllRooms();
    }

    @GetMapping("/type/{type}")
    public List<RoomResponse> getRoomsByType(@PathVariable RoomType type) {
        log.debug("Fetching rooms by type: {}", type);
        return roomService.getRoomsByType(type);
    }

    @GetMapping("/{id}")
    public RoomResponse getRoom(@PathVariable Long id) {
        log.debug("Fetching room with ID: {}", id);
        return roomService.getRoom(id)
                .orElseThrow(() -> new NotFoundException("Room with id " + id + " not found"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public RoomResponse createRoom(@Valid @RequestBody RoomRequest request) {
        log.info("Creating room: {} ({})", request.name(), request.type());
        return roomService.createRoom(request);
    }

    @PutMapping("/{id}")
    public RoomResponse updateRoom(@PathVariable Long id, @Valid @RequestBody RoomRequest request) {
        log.info("Updating room {}", id);
        return roomService.updateRoom(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteRoom(
            @PathVariable Long id,
            @RequestParam(defaultValue = "SIMPLE") DeleteMode mode
    ) {
        log.info("Deleting room with ID: {} using mode: {}", id, mode);
        roomService.deleteRoom(id, mode);
    }
}