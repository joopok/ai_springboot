package com.fid.job.service;

import com.fid.job.dto.RemoteProjectDTO;
import com.fid.job.model.Project;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface ProjectService {
    
    // 프로젝트 목록 조회
    Map<String, Object> getAllProjects(Map<String, Object> params);
    
    // 프로젝트 상세 조회
    Project getProjectById(Long id, Long userId);
    
    // 프로젝트 지원하기
    void applyToProject(Long projectId, Long userId, String coverLetter, BigDecimal proposedBudget);
    
    // 북마크 토글
    boolean toggleBookmark(Long projectId, Long userId);
    
    // 북마크 추가
    void addBookmark(Long projectId, Long userId);
    
    // 북마크 제거
    void removeBookmark(Long projectId, Long userId);
    
    // 북마크 여부 확인
    boolean isBookmarked(Long projectId, Long userId);
    
    // 북마크한 프로젝트 목록
    Map<String, Object> getBookmarkedProjects(Long userId, Map<String, Object> params);
    
    // 관련 프로젝트 조회
    List<Project> getRelatedProjects(Long projectId, int limit);
    
    // 인기 프로젝트 조회
    List<Project> getPopularProjects(int limit);
    
    // 긴급 프로젝트 조회  
    List<Project> getUrgentProjects(int limit);
    
    // 프로젝트 공유 URL 생성
    String generateShareUrl(Long projectId);
    
    // 상주 프로젝트 상세 조회
    RemoteProjectDTO getRemoteProjectById(Long id, Long userId);
    
    // 상주 프로젝트 목록 조회
    Map<String, Object> getRemoteProjects(Map<String, Object> params);
    
    // 조회수 증가
    void incrementViewCount(Long projectId);
    
    // 프로젝트 질문 목록 조회
    Map<String, Object> getProjectQuestions(Map<String, Object> params);
    
    // 프로젝트 질문 등록
    void createProjectQuestion(Long projectId, Long userId, String content);
    
    // 프로젝트 후기 목록 조회
    Map<String, Object> getProjectReviews(Map<String, Object> params);
    
    // 프로젝트 후기 등록
    void createProjectReview(Long projectId, Long userId, String content, Integer rating);
}