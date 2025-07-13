package com.fid.job.service;

import com.fid.job.mapper.UserMapper;
import com.fid.job.model.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import com.fid.job.config.JwtTokenUtil;
import java.util.Date;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    
    @Autowired
    private TokenBlacklistService tokenBlacklistService;
    
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    @Transactional
    public void register(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userMapper.insert(user);
    }

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public User findById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    @Transactional
    public void update(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            user.setPassword(null);
        }
        userMapper.update(user);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        userMapper.delete(id);
    }

    @Override
    public User authenticate(String username, String password) {
        User user = userMapper.findByUsername(username);

        if (user == null) {
            log.warn("User not found: {}", username);
            throw new BadCredentialsException("아아디 또는 비밀번호가 일치하지 않습니다.....");
        }

        log.info("=== 비밀번호 검증 시작 ===");
        log.info("입력된 비밀번호: {}", password);
        log.info("DB 저장 비밀번호: {}", user.getPassword());
        log.info("사용자 정보 - ID: {}, Username: {}, Name: {}", user.getId(), user.getUsername(), user.getFullName());

        // 입력된 비밀번호를 BCrypt로 암호화해서 로그 출력
        String encodedInputPassword = passwordEncoder.encode(password);
        log.info("입력된 비밀번호의 BCrypt 암호화 결과: {}", encodedInputPassword);
        log.info("입력 비밀번호 암호화 후 검증: {}", passwordEncoder.matches(password, encodedInputPassword));
        
        // 비밀번호 검증이 안되는 이유:
        // 1. 저장된 비밀번호가 BCrypt로 인코딩되지 않았을 수 있음
        // 2. 입력된 비밀번호와 저장된 비밀번호 형식이 다를 수 있음
        // 3. passwordEncoder 빈이 제대로 주입되지 않았을 수 있음

        boolean isMatch = false;
        try {
            // 디버그를 위한 추가 로깅
            log.info("PasswordEncoder 클래스: {}", passwordEncoder.getClass().getName());
            log.info("입력 비밀번호 길이: {}", password.length());
            log.info("DB 비밀번호 해시 길이: {}", user.getPassword().length());
            log.info("DB 비밀번호 해시 시작: {}", user.getPassword().substring(0, 10));
            
            isMatch = passwordEncoder.matches(password, user.getPassword());
            log.info("비밀번호 검증 시도 결과: {}", isMatch);
            
            // 추가 검증 테스트
            log.info("=== 추가 검증 테스트 ===");
            log.info("테스트: '1234'와 DB 해시 매칭 = {}", passwordEncoder.matches("1234", user.getPassword()));
            log.info("테스트: 'password123'과 DB 해시 매칭 = {}", passwordEncoder.matches("password123", user.getPassword()));
            log.info("테스트: 'admin123'과 DB 해시 매칭 = {}", passwordEncoder.matches("admin123", user.getPassword()));
            log.info("테스트: 'admin'과 DB 해시 매칭 = {}", passwordEncoder.matches("admin", user.getPassword()));
            log.info("테스트: 'test'와 DB 해시 매칭 = {}", passwordEncoder.matches("test", user.getPassword()));
            log.info("테스트: 'password'와 DB 해시 매칭 = {}", passwordEncoder.matches("password", user.getPassword()));
            
            // DB 해시가 올바른 BCrypt 형식인지 확인
            if (user.getPassword().startsWith("$2a$") || user.getPassword().startsWith("$2b$")) {
                log.info("DB 해시는 올바른 BCrypt 형식입니다.");
            } else {
                log.error("DB 해시가 BCrypt 형식이 아닙니다!");
            }
        } catch (Exception e) {
            log.error("비밀번호 검증 중 오류 발생: {}", e.getMessage(), e);
        }

        if (isMatch) {
            log.info("=== 비밀번호 검증 성공 ===");
            return user;
        }

        log.warn("=== 비밀번호 검증 실패 ===");
        throw new BadCredentialsException("로그인 실패:::::: 아이디 또는 비밀번호를 확인해주세요.");
    }

    @Override
    @Transactional
    public void logout(String username, String jwtToken) {
        log.info("사용자 로그아웃 처리 시작: {}", username);
        
        // JWT 토큰이 있으면 블랙리스트에 추가
        if (jwtToken != null && !jwtToken.isEmpty()) {
            try {
                // 토큰의 만료 시간 계산
                Date expiration = jwtTokenUtil.getExpirationDateFromToken(jwtToken);
                long expirationTime = (expiration.getTime() - System.currentTimeMillis()) / 1000;
                
                if (expirationTime > 0) {
                    // 토큰을 블랙리스트에 추가
                    tokenBlacklistService.addToBlacklist(jwtToken, expirationTime);
                    log.info("JWT 토큰이 블랙리스트에 추가되었습니다.");
                }
            } catch (Exception e) {
                log.error("JWT 토큰 블랙리스트 추가 중 오류 발생", e);
            }
        }
        
        // 사용자의 마지막 활동 시간 업데이트 (updated_at) - DB 서버 시간 사용
        try {
            userMapper.updateLogoutTime(username);
            log.info("사용자 로그아웃 완료: {}", username);
        } catch (Exception e) {
            log.error("사용자 로그아웃 시간 업데이트 중 오류 발생", e);
        }
    }
}