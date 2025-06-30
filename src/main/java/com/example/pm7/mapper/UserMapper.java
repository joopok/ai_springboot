package com.example.pm7.mapper;

import com.example.pm7.model.User;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserMapper {
    User findByUsername(String username1);
    void insert(User user);
    List<User> findAll();  // 전체 사용자 조회
    User findById(Long id);  // ID로 사용자 조회
    void update(User user);  // 사용자 정보 수정
    void delete(Long id);  // 사용자 삭제
    void updateLastLogout(String username);
} 