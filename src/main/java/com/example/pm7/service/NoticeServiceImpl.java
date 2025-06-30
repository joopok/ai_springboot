package com.example.pm7.service;

import com.example.pm7.mapper.NoticeMapper;
import com.example.pm7.model.Notice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;

@Service
@Slf4j
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public List<Notice> getMainNotices() {
        try {
            List<Notice> notices = noticeMapper.findMain();
            List<Notice> filteredNotices = notices.stream()
                    .filter(notice -> !notice.isLoginRequired())
                    .collect(Collectors.toList());
            return filteredNotices;
        } catch (Exception e) {
            throw e;
        }
    }

    @Override
    public List<Notice> getAllNotices() {
        try {
            log.info("=== getAllNotices 서비스 시작 ===");
            List<Notice> notices = noticeMapper.findAll();
            log.debug("조회된 전체 공지사항 수: {}", notices.size());

            List<Notice> filteredNotices = notices.stream()
                    .filter(notice -> !notice.isLoginRequired())
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
    public Notice findById(Long id) {
        Notice notice = noticeMapper.findById(id);
        if (notice != null) {
            noticeMapper.incrementReadCount(id);
        }
        return notice;
    }

    @Override
    @Transactional
    public void create(Notice notice) {
        noticeMapper.insert(notice);
    }

    // @Override
    // public List<Notice> findAll() {
    // return noticeMapper.findAll();
    // }

    @Override
    @Transactional
    public void update(Notice notice) {
        noticeMapper.update(notice);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        noticeMapper.delete(id);
    }

    @Override
    public void testDatabaseConnection() {
        noticeMapper.testConnection();
    }
}