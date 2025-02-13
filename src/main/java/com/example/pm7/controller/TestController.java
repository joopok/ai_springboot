package com.example.pm7.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import lombok.extern.slf4j.Slf4j;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import com.example.pm7.model.User;
import com.example.pm7.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.example.pm7.dto.LoginRequest;
import com.example.pm7.dto.ApiResponse;
import com.example.pm7.exception.CustomException;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestController {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    private UserService userService;

    @GetMapping("/db")
    public String testDb() {
        try {
            log.info("Testing database connection...");
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            log.info("Database test result: {}", result);
            return "Database connection successful. Result: " + result;
        } catch (Exception e) {
            log.error("Database connection test failed", e);
            return "Database connection failed: " + e.getMessage();
        }
    }

    @GetMapping("/insert-test-data")
    public String insertTestData() {
        try {
            jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS userss ("
                    + "id BIGINT AUTO_INCREMENT PRIMARY KEY,"
                    + "username VARCHAR(50) NOT NULL UNIQUE,"
                    + "password VARCHAR(100) NOT NULL,"
                    + "name VARCHAR(100),"
                    + "email VARCHAR(100),"
                    + "role VARCHAR(20),"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
                    + ")");

            // 기존 데이터 삭제
            jdbcTemplate.execute("DELETE FROM userss");

            // 테스트 데이터 삽입
            jdbcTemplate.update(
                    "INSERT INTO userss (username, password, name, email, role) VALUES (?, ?, ?, ?, ?)",
                    "admin", "admin123", "관리자", "admin@example.com", "ADMIN");

            jdbcTemplate.update(
                    "INSERT INTO userss (username, password, name, email, role) VALUES (?, ?, ?, ?, ?)",
                    "user1", "user123", "홍길동", "hong@example.com", "USER");

            jdbcTemplate.update(
                    "INSERT INTO userss (username, password, name, email, role) VALUES (?, ?, ?, ?, ?)",
                    "user2", "user456", "김철수", "kim@example.com", "USER");

            return "Test data inserted successfully";
        } catch (Exception e) {
            log.error("Error inserting test data: ", e);
            return "Error inserting test data: " + e.getMessage();
        }
    }

    @GetMapping("/users")
    public List<Map<String, Object>> getUsers() {
        log.info("=== Starting /api/users request ===");
        try {
            log.info("Executing SQL: SELECT * FROM userss");
            List<Map<String, Object>> users = jdbcTemplate.queryForList("SELECT * FROM userss");
            log.info("Found {} users in database", users.size());
            users.forEach(user -> {
                log.debug("User data: {}", user);
            });
            log.info("=== Completed /api/users request successfully ===");
            return users;
        } catch (Exception e) {
            log.error("=== Error in /api/users request ===");
            log.error("Error message: {}", e.getMessage());
            log.error("Stack trace: ", e);
            return Collections.emptyList();
        }
    }

    @GetMapping("/users/all")
    public List<User> getAllUsers() {
        log.info("=== Starting getAllUsers request ===");
        try {
            List<User> users = userService.findAll();
            log.info("Found {} users", users.size());
            return users;
        } catch (Exception e) {
            log.error("Error getting all users: ", e);
            return Collections.emptyList();
        }
    }

    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        log.info("=== Starting getUser request for id: {} ===", id);
        try {
            return userService.findById(id);
        } catch (Exception e) {
            log.error("Error getting user: ", e);
            return null;
        }
    }

    @GetMapping("/test/exception")
    public void testException() {
        throw new CustomException("테스트 예외 발생", HttpStatus.BAD_REQUEST);
    }

    @PostMapping("/test/validation")
    public ResponseEntity<ApiResponse<LoginRequest>> testValidation(
            @Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(ApiResponse.success(request));
    }

    @GetMapping("/test/error")
    public void testError() {
        throw new RuntimeException("예상치 못한 에러 발생");
    }
}