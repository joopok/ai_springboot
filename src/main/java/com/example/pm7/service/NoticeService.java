package com.example.pm7.service;

import com.example.pm7.model.Notice;
import com.example.pm7.model.User;
import java.util.List;

public interface NoticeService {
    List<Notice> getAllNotices(User loginUser);
    Notice getNoticeById(Long id, User loginUser);
    void createNotice(Notice notice);
    void updateNotice(Notice notice);
    void deleteNotice(Long id);
    void testDatabaseConnection();
} 