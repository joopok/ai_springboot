package com.fid.job.controller;

import com.fid.job.model.User;
import com.fid.job.service.UserService;
import com.fid.job.config.JwtTokenUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.http.HttpStatus;
import lombok.extern.slf4j.Slf4j;
import com.fid.job.dto.ApiResponse;
import com.fid.job.dto.LoginRequest;
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
                // role이 null인 경우 기본값 "freelancer" 설정 (DB enum 기본값과 일치)
                String role = (user.getRole() != null) ? user.getRole() : "freelancer";

                // DB에서 가져온 role 값 (freelancer, client, admin)을 그대로 사용
                String roleName = role;

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
                session.setAttribute("role", roleName);  // ROLE_ prefix 제거된 값 저장
                session.setAttribute("access_token", token);

                // 응답 데이터 구성
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("name", user.getFullName());
                responseData.put("username", user.getUsername());
                responseData.put("email", user.getEmail());
                responseData.put("role", roleName);  // ROLE_ prefix 제거된 값 응답
                responseData.put("access_token", token);
                responseData.put("status", "200");

                // 최종 응답 데이터 로그 출력
                log.info("=== 로그인 성공 최종 응답 데이터 ===");
                log.info("Username: {}", user.getUsername());
                log.info("Name: {}", responseData.get("name"));
                log.info("Email: {}", responseData.get("email"));
                log.info("Role: {}", responseData.get("role"));
                log.info("Status: {}", responseData.get("status"));
                log.info("Token: {}", responseData.get("access_token") != null ? "토큰 생성됨" : "토큰 없음");
                log.info("=== 로그인 응답 데이터 전체: {} ===", responseData);
                
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
            // 기본 role 설정 - DB enum에 맞춰 설정
            if (user.getRole() == null || user.getRole().isEmpty()) {
                user.setRole("freelancer");  // 기본값은 freelancer
            }
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
            // JWT 토큰 추출
            String authHeader = request.getHeader("Authorization");
            String jwtToken = null;
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                jwtToken = authHeader.substring(7);
            }

            // 현재 세션 가져오기
            HttpSession session = request.getSession(false);
            String username = null;
            if (session != null) {
                username = (String) session.getAttribute("username");
                // 세션에서 저장된 액세스 토큰도 가져오기
                if (jwtToken == null) {
                    jwtToken = (String) session.getAttribute("access_token");
                }
                // 세션 무효화
                session.invalidate();
            }

            // 로그인한 사용자의 정보가 있으면 로그아웃 처리
            if (username != null) {
                log.info("Processing logout for user: {}", username);
                userService.logout(username, jwtToken);
                log.info("User logged out successfully: {}", username);
            } else if (jwtToken != null) {
                // username이 없어도 토큰이 있으면 토큰에서 username 추출
                try {
                    username = jwtTokenUtil.getUsernameFromToken(jwtToken);
                    if (username != null) {
                        userService.logout(username, jwtToken);
                        log.info("User logged out successfully via token: {}", username);
                    }
                } catch (Exception e) {
                    log.warn("Failed to extract username from token during logout", e);
                }
            }

            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            log.error("Logout failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("로그아웃 처리 중 오류가 발생했습니다."));
        }
    }
}