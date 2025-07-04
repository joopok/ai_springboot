package com.fid.job.controller;

import com.fid.job.model.Event;
import com.fid.job.service.EventService;
import com.fid.job.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    @PostMapping
    public ResponseEntity<ApiResponse<Event>> createEvent(@RequestBody Event event) {
        eventService.create(event);
        return ResponseEntity.ok(ApiResponse.success(event));
    }

    @PostMapping("list")
    public ResponseEntity<ApiResponse<List<Event>>> getAllEvents() {
        List<Event> events = eventService.findAll();
        return ResponseEntity.ok(ApiResponse.success(events));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Event>> getEvent(@PathVariable Long id) {
        Event event = eventService.findById(id);
        return ResponseEntity.ok(ApiResponse.success(event));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<Event>>> getEventsByStatus(@PathVariable String status) {
        List<Event> events = eventService.findByStatus(status);
        return ResponseEntity.ok(ApiResponse.success(events));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Event>> updateEvent(
            @PathVariable Long id,
            @RequestBody Event event) {
        event.setEventId(id);
        eventService.update(event);
        return ResponseEntity.ok(ApiResponse.success(event));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteEvent(@PathVariable Long id) {
        eventService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}