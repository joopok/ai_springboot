package com.example.pm7.controller;

import com.example.pm7.model.User;
import com.example.pm7.service.UserService;
import com.example.pm7.config.JwtTokenUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.http.HttpStatus;
import lombok.extern.slf4j.Slf4j;
import com.example.pm7.dto.ApiResponse;
import com.example.pm7.dto.LoginRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.HashMap;
import java.util.Map;
import java.util.Enumeration;

@RestController
@RequestMapping("/api/auth")
@Slf4j
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final JwtTokenUtil jwtTokenUtil;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Map<String, Object>>> login(@RequestBody LoginRequest loginRequest,
            HttpServletRequest request) {
        try {
            log.info("Login attempt - Username: {}", loginRequest.getUsername());
            User user = userService.authenticate(
                    loginRequest.getUsername(),
                    loginRequest.getPassword());

            // User를 UserDetails로 변환
            UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                    .username(user.getUsername())
                    .password(user.getPassword())
                    .roles(user.getRole())
                    .build();

            // JWT 토큰 생성
            String token = jwtTokenUtil.generateToken(userDetails);

            // 세션 정보 저장
            HttpSession session = request.getSession();
            // name 필드가 없으므로 username을 대신 사용
            session.setAttribute("name", user.getName());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setAttribute("access_token", token);

            // 응답 데이터 구성
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("name", user.getName());
            responseData.put("username", user.getUsername());
            responseData.put("email", user.getEmail());
            responseData.put("role", user.getRole());
            responseData.put("access_token", token);

            log.info("Login successful for user: {}", user.getUsername());
            return ResponseEntity.ok(ApiResponse.success(responseData));

        } catch (BadCredentialsException e) {
            log.warn("Login failed - Username: {}, Password: {}",
                    loginRequest.getUsername(),
                    loginRequest.getPassword());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("로그인 실패: 아이디 또는 비밀번호를 확인해주세요"));
        }
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<Void>> register(@RequestBody User user) {
        try {
            // 기본 role 설정
            user.setRole("ROLE_USER");
            userService.register(user);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            log.error("Registration failed", e);
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Registration failed: " + e.getMessage()));
        }
    }

    @GetMapping("/session-info")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getSessionInfo(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Map<String, Object> sessionInfo = new HashMap<>();
            sessionInfo.put("name", session.getAttribute("name"));
            sessionInfo.put("username", session.getAttribute("username"));
            sessionInfo.put("email", session.getAttribute("email"));
            sessionInfo.put("role", session.getAttribute("role"));
            sessionInfo.put("token", session.getAttribute("token"));

            return ResponseEntity.ok(ApiResponse.success(sessionInfo));
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error("세션 정보가 없습니다."));
    }

    @GetMapping("/sessionDetails")
    public String getSessionDetails(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            StringBuilder sessionDetails = new StringBuilder();
            sessionDetails.append("Session ID: ").append(session.getId()).append("\n");

            Enumeration<String> attributeNames = session.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String attributeName = attributeNames.nextElement();
                Object attributeValue = session.getAttribute(attributeName);
                sessionDetails.append(attributeName).append(": ").append(attributeValue).append("\n");
            }

            return sessionDetails.toString();
        } else {
            return "No session found";
        }
    }
}