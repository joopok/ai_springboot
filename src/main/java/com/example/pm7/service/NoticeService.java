package com.example.pm7.service;

import com.example.pm7.model.Notice;
import java.util.List;

public interface NoticeService {
    void create(Notice notice);

    List<Notice> getAllNotices();

    Notice findById(Long id);

    void update(Notice notice);

    void delete(Long id);

    void testDatabaseConnection();
}