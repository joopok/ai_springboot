package com.example.pm7.controller;

import com.example.pm7.model.Notice;
import com.example.pm7.service.NoticeService;
import com.example.pm7.dto.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import com.example.pm7.model.User;
import lombok.RequiredArgsConstructor;

import java.util.List;

@RestController
@RequestMapping("/api/notices")
@Slf4j
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class NoticeController {

    private final NoticeService noticeService;

    @PostMapping
    public ResponseEntity<ApiResponse<List<Notice>>> getAllNotices(
            @RequestAttribute(required = false) User loginUser) {
        try {
            log.info("=== getAllNotices 호출 시작 ===");
            log.debug("User: {}", loginUser != null ? loginUser.getUsername() : "anonymous");

            List<Notice> notices = noticeService.getAllNotices(loginUser);
            log.info("=== getAllNotices 호출 완료. 조회된 공지사항 수: {} ===", notices.size());

            return ResponseEntity.ok(ApiResponse.success(notices));
        } catch (Exception e) {
            log.error("getAllNotices 처리 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/{id}")
    public ResponseEntity<ApiResponse<Notice>> getNoticeById(
            @PathVariable Long id,
            @RequestAttribute(required = false) User loginUser) {
        log.info("Getting notice by id: {}, User: {}", id,
                loginUser != null ? loginUser.getUsername() : "anonymous");
        Notice notice = noticeService.getNoticeById(id, loginUser);
        if (notice == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("Notice not found"));
        }
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Void>> createNotice(@RequestBody Notice notice) {
        log.info("Creating new notice");
        noticeService.createNotice(notice);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> updateNotice(@PathVariable Long id, @RequestBody Notice notice) {
        log.info("Updating notice with id: {}", id);
        notice.setId(id);
        noticeService.updateNotice(notice);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable Long id) {
        log.info("Deleting notice with id: {}", id);
        noticeService.deleteNotice(id);
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