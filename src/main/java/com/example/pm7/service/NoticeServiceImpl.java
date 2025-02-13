package com.example.pm7.service;

import com.example.pm7.mapper.NoticeMapper;
import com.example.pm7.model.Notice;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import com.example.pm7.model.User;
import com.example.pm7.exception.CustomException;
import lombok.RequiredArgsConstructor;

@Service
@Slf4j
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public List<Notice> getAllNotices(User loginUser) {
        try {
            log.info("=== getAllNotices 서비스 시작 ===");
            List<Notice> notices = noticeMapper.findAll();
            log.debug("조회된 전체 공지사항 수: {}", notices.size());
            
            List<Notice> filteredNotices = notices.stream()
                    .filter(notice -> !notice.isLoginRequired() || loginUser != null)
                    .collect(Collectors.toList());
            
            log.info("=== getAllNotices 서비스 완료. 필터링된 공지사항 수: {} ===", 
                    filteredNotices.size());
            return filteredNotices;
        } catch (Exception e) {
            log.error("getAllNotices 서비스 처리 중 오류 발생", e);
            throw e;
        }
    }

    @Override
    public Notice getNoticeById(Long id, User loginUser) {
        Notice notice = noticeMapper.findById(id);
        if (notice != null && notice.isLoginRequired() && loginUser == null) {
            throw new CustomException("Login required to view this notice", 
                    HttpStatus.UNAUTHORIZED);
        }
        if (notice != null) {
            noticeMapper.incrementReadCount(id);
        }
        return notice;
    }

    @Override
    @Transactional
    public void createNotice(Notice notice) {
        noticeMapper.insert(notice);
    }

    @Override
    @Transactional
    public void updateNotice(Notice notice) {
        noticeMapper.update(notice);
    }

    @Override
    @Transactional
    public void deleteNotice(Long id) {
        noticeMapper.delete(id);
    }

    public void testDatabaseConnection() {
        try {
            log.info("Testing database connection...");
            int result = noticeMapper.testConnection();
            log.info("Database connection test result: {}", result);
        } catch (Exception e) {
            log.error("Database connection test failed", e);
            throw e;
        }
    }
} 