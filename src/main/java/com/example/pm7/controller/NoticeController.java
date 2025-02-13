package com.example.pm7.controller;

import com.example.pm7.model.Notice;
import com.example.pm7.service.NoticeService;
import com.example.pm7.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import com.example.pm7.model.User;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class NoticeController {

    private final NoticeService noticeService;

    @PostMapping("/list")
    public ResponseEntity<?> getAllNotices(
            @RequestAttribute(required = false) User user) {
        try {
            log.info("=== getAllNotices 호출 시작 ===");
            log.debug("User: {}", user != null ? user.getUsername() : "anonymous");
            List<Notice> notices = noticeService.getAllNotices(user);
            log.info("=== getAllNotices 호출 완료. 조회된 공지사항 수: {} ===", notices.size());
            return ResponseEntity.ok(ApiResponse.success(notices));
        } catch (Exception e) {
            log.error("getAllNotices 처리 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/detail/{id}")
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

    @PostMapping("/create")
    public ResponseEntity<?> createNotice(
            @RequestBody Notice notice,
            @RequestAttribute(required = false) User user) {
        log.info("Creating new notice by user: {}", user != null ? user.getUsername() : "anonymous");
        noticeService.createNotice(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Notice>> updateNotice(
            @PathVariable Long id,
            @RequestBody Notice notice) {
        log.info("Updating notice with id: {}", id);
        notice.setId(id);
        noticeService.updateNotice(notice);
        return ResponseEntity.ok(ApiResponse.success(notice));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable Long id) {
        log.info("Deleting notice with id: {}", id);
        noticeService.deleteNotice(id);
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