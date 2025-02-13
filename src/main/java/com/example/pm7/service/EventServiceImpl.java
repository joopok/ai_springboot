package com.example.pm7.service;

import com.example.pm7.mapper.EventMapper;
import com.example.pm7.model.Event;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EventServiceImpl implements EventService {

    private final EventMapper eventMapper;

    @Override
    @Transactional
    public void create(Event event) {
        eventMapper.insert(event);
    }

    @Override
    public List<Event> findAll() {
        return eventMapper.findAll();
    }

    @Override
    public Event findById(Long id) {
        return eventMapper.findById(id);
    }

    @Override
    public List<Event> findByStatus(String status) {
        return eventMapper.findByStatus(status);
    }

    @Override
    @Transactional
    public void update(Event event) {
        eventMapper.update(event);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        eventMapper.delete(id);
    }
} 