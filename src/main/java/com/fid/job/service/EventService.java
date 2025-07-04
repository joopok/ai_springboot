package com.fid.job.service;

import com.fid.job.model.Event;
import java.util.List;

public interface EventService {
    void create(Event event);
    List<Event> findAll();
    Event findById(Long id);
    List<Event> findByStatus(String status);
    void update(Event event);
    void delete(Long id);
} 