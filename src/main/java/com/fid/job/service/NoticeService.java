package com.fid.job.service;

import com.fid.job.model.Notice;
import java.util.List;

public interface NoticeService {
    void create(Notice notice);

    List<Notice> getMainNotices();

    List<Notice> getAllNotices();

    Notice findById(Long id);

    void update(Notice notice);

    void delete(Long id);

    void testDatabaseConnection();
}