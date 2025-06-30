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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.Enumeration;

@SuppressWarnings("unused")
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
            User user = userService.authenticate(loginRequest.getUsername(), loginRequest.getPassword());

            try {
                // User를 UserDetails로 변환
                // role이 null인 경우 기본값 "USER" 설정
                String role = (user.getRole() != null) ? user.getRole() : "USER";

                // "ROLE_" 접두사 처리 - Spring Security roles 메서드는 접두사가 없는 역할 이름 기대
                String roleName = role;
                if (role.startsWith("ROLE_")) {
                    roleName = role.substring(5); // "ROLE_" 제거
                }

                log.debug("사용자 역할: 원본={}, 처리 후={}", role, roleName);

                UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                        .username(user.getUsername())
                        .password(user.getPassword())
                        .roles(roleName)
                        .build();

                // JWT 토큰 생성
                String token = jwtTokenUtil.generateToken(userDetails);

                // 세션 정보 저장
                HttpSession session = request.getSession();
                session.setAttribute("name", user.getFullName());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("role", role);
                session.setAttribute("access_token", token);

                // 응답 데이터 구성
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("name", user.getFullName());
                responseData.put("username", user.getUsername());
                responseData.put("email", user.getEmail());
                responseData.put("role", role);
                responseData.put("access_token", token);
                responseData.put("status", "200");

                log.info("Login successful for user: {}", user.getUsername());
                return ResponseEntity.ok(ApiResponse.success(responseData, "로그인 정상 처리 되었습니다."));
            } catch (Exception e) {
                log.error("로그인 처리 중 오류 발생: {}", e.getMessage(), e);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(ApiResponse.error("로그인 처리 중 오류 발생 하였습니다."));
            }

        } catch (BadCredentialsException e) {
            log.warn("Login failed - Username: {}, Password: {}",
                    loginRequest.getUsername(),
                    loginRequest.getPassword());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("로그인 처리 중 오류 발생 하였습니다."));
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

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(
            HttpServletRequest request,
            @RequestAttribute(required = false) User loginUser) {
        try {
            // 현재 세션 가져오기
            HttpSession session = request.getSession(false);
            String username = null;
            if (session != null) {
                username = (String) session.getAttribute("username");
                // 세션 무효화
                session.invalidate();
            }

            // 로그인한 사용자의 정보가 있으면 updated_at 업데이트
            if (username != null) {
                log.error("로그인한 사용자의 정보가 있으면==========>");
                userService.logout(username);
                log.info("User logged out successfully: {}", username);
            }

            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            log.error("Logout failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("로그아웃 처리 중 오류가 발생했습니다."));
        }
    }
}