package com.example.pm7.controller;

import com.example.pm7.model.Notice;
import com.example.pm7.service.NoticeService;
import com.example.pm7.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeService noticeService;

    // POST 메서드로 공지사항 생성
    @PostMapping
    public ResponseEntity<ApiResponse<Notice>> createNotice(@RequestBody Notice notice) {
        noticeService.create(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    // GET 메서드로 모든 공지사항 조회
    @GetMapping
    public ResponseEntity<ApiResponse<List<Notice>>> getAllNotices() {
        List<Notice> notices = noticeService.findAll();
        return ResponseEntity.ok(ApiResponse.success(notices));
    }

    // GET 메서드로 특정 ID의 공지사항 조회
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Notice>> getNotice(@PathVariable Long id) {
        Notice notice = noticeService.findById(id);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    // PUT 메서드로 공지사항 수정
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Notice>> updateNotice(
            @PathVariable Long id,
            @RequestBody Notice notice) {
        notice.setNoticeId(id);
        noticeService.update(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    // DELETE 메서드로 공지사항 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable Long id) {
        noticeService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/test-db")
    public String testDatabase() {
        try {
            log.info("Received request to test database connection");
            noticeService.testDatabaseConnection();
            return "Database connection successful";
        } catch (Exception e) {
            log.error("Database test failed", e);
            return "Database connection failed: " + e.getMessage();
        }
    }
}