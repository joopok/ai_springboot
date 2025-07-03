package com.example.pm7.service;

import org.springframework.stereotype.Service;
import org.springframework.scheduling.annotation.Scheduled;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TokenBlacklistService {
    
    // 메모리 기반 블랙리스트 저장소
    private final Map<String, Long> blacklistedTokens = new ConcurrentHashMap<>();
    
    /**
     * JWT 토큰을 블랙리스트에 추가
     * @param token JWT 토큰
     * @param expirationTime 토큰 만료 시간 (초)
     */
    public void addToBlacklist(String token, long expirationTime) {
        if (token == null || token.isEmpty()) {
            return;
        }
        
        // 현재 시간 + 만료 시간을 계산하여 저장
        long expirationTimestamp = System.currentTimeMillis() + (expirationTime * 1000);
        blacklistedTokens.put(token, expirationTimestamp);
        log.info("Token added to blacklist: {}", token.substring(0, Math.min(token.length(), 20)) + "...");
    }
    
    /**
     * 토큰이 블랙리스트에 있는지 확인
     * @param token JWT 토큰
     * @return 블랙리스트에 있으면 true
     */
    public boolean isBlacklisted(String token) {
        if (token == null || token.isEmpty()) {
            return false;
        }
        
        Long expirationTime = blacklistedTokens.get(token);
        if (expirationTime == null) {
            return false;
        }
        
        // 만료 시간이 지났으면 제거하고 false 반환
        if (System.currentTimeMillis() > expirationTime) {
            blacklistedTokens.remove(token);
            return false;
        }
        
        return true;
    }
    
    /**
     * 만료된 토큰들을 주기적으로 정리
     * 1시간마다 실행
     */
    @Scheduled(fixedDelay = 3600000) // 1시간
    public void cleanupExpiredTokens() {
        long currentTime = System.currentTimeMillis();
        blacklistedTokens.entrySet().removeIf(entry -> currentTime > entry.getValue());
        log.info("Cleaned up expired tokens from blacklist. Current size: {}", blacklistedTokens.size());
    }
}