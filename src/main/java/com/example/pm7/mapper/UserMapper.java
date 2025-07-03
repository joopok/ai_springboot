package com.example.pm7.mapper;

import com.example.pm7.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    // 로그인을 위한 사용자 조회 (username 또는 email로)
    User findByUsernameOrEmail(@Param("usernameOrEmail") String usernameOrEmail);
    
    // 기존 호환성을 위한 메소드
    User findByUsername(@Param("username") String username);
    
    // ID로 사용자 조회
    User findById(@Param("id") Long id);
    
    // 새 사용자 등록
    void insert(User user);
    
    // 마지막 로그인 시간 업데이트
    void updateLastLogin(@Param("userId") Long userId);
    
    // 로그아웃 시간 업데이트 (updated_at 필드 사용)
    void updateLogoutTime(@Param("username") String username);
    
    // 사용자 정보 업데이트
    void update(User user);
    
    // 전체 사용자 조회
    List<User> findAll();
    
    // 사용자 삭제 (소프트 삭제)
    void delete(@Param("id") Long id);
} 