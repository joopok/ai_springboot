package com.example.pm7.service;

import com.example.pm7.mapper.UserMapper;
import com.example.pm7.model.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

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
            throw new BadCredentialsException("Invalid username or password");
        }

        log.info("=== 비밀번호 검증 시작 ===");
        log.info("입력된 비밀번호: {}", password);
        log.info("DB 저장 비밀번호: {}", user.getPassword());
        
        boolean isMatch = passwordEncoder.matches(password, user.getPassword());
        log.info("비밀번호 일치 여부: {}", isMatch);
        
        if (isMatch) {
            log.info("=== 비밀번호 검증 성공 ===");
            return user;
        }
        
        log.warn("=== 비밀번호 검증 실패 ===");
        throw new BadCredentialsException("Invalid username or password");
    }
} 