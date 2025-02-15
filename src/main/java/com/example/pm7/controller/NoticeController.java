package com.example.pm7.controller;

import com.example.pm7.model.Notice;
import com.example.pm7.service.NoticeService;
import com.example.pm7.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class NoticeController {

    private final NoticeService noticeService;

    @PostMapping("/list")
    public ResponseEntity<ApiResponse<List<Notice>>> getAllNotices() {
        try {
            log.info("=== getAllNotices 호출 시작 ===");
            List<Notice> notices = noticeService.getAllNotices();
            log.info("=== getAllNotices 호출 완료. 조회된 공지사항 수: {} ===", notices.size());
            return ResponseEntity.ok(ApiResponse.success(notices));
        } catch (Exception e) {
            log.error("getAllNotices 처리 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/detail/{id}")
    public ResponseEntity<ApiResponse<Notice>> getNotice(@PathVariable Long id) {
        Notice notice = noticeService.findById(id);
        if (notice == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("Notice not found"));
        }
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @PostMapping("/create")
    public ResponseEntity<ApiResponse<Notice>> createNotice(@RequestBody Notice notice) {
        noticeService.create(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @PostMapping("/update/{id}")
    public ResponseEntity<ApiResponse<Notice>> updateNotice(
            @PathVariable Long id,
            @RequestBody Notice notice) {
        notice.setNoticeId(id);
        noticeService.update(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable Long id) {
        noticeService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/test")
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