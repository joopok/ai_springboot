package com.fid.job.mapper;

import com.fid.job.model.Event;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EventMapper {
    void insert(Event event);
    List<Event> findAll();
    Event findById(Long id);
    List<Event> findByStatus(String status);
    void update(Event event);
    void delete(Long id);
} 