package com.fid.job.interceptor;

import lombok.extern.slf4j.Slf4j;
import com.fid.job.config.JwtTokenUtil;
import com.fid.job.service.TokenBlacklistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.lang.NonNull;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Slf4j
@Component
public class LoginCheckInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    
    @Autowired
    private TokenBlacklistService tokenBlacklistService;

    @Override
    public boolean preHandle(
            @NonNull HttpServletRequest request, 
            @NonNull HttpServletResponse response, 
            @NonNull Object handler) throws Exception {
        log.info("=== getAllNotices 호출 시작 ===");
        String token = request.getHeader("Authorization");
        log.info("=== getAllNotices 호출 시작 ==="+ token);

        if (token == null || !token.startsWith("Bearer ")) {
            log.info("=== 토큰 없음 또는 잘못된 형식 ===");
            return true;  // 토큰이 없어도 일단 통과
        }

        try {
            String jwt = token.substring(7);
            
            // 블랙리스트 확인
            if (tokenBlacklistService.isBlacklisted(jwt)) {
                log.warn("=== 블랙리스트에 등록된 토큰 ===");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Token has been revoked\"}");
                return false;
            }
            
            String username = jwtTokenUtil.getUsernameFromToken(jwt);
            request.setAttribute("username", username);
            log.info("=== 토큰 검증 성공: {} ===", username);
            return true;
        } catch (Exception e) {
            log.warn("=== 토큰 검증 실패 ===", e);
            return true;  // 토큰이 잘못되어도 일단 통과
        }
    }
} 