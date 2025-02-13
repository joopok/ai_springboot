package com.example.pm7.service;

import com.example.pm7.model.Event;
import java.util.List;

public interface EventService {
    void create(Event event);
    List<Event> findAll();
    Event findById(Long id);
    List<Event> findByStatus(String status);
    void update(Event event);
    void delete(Long id);
} 