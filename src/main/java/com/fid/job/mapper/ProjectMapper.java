package com.fid.job.mapper;

import com.fid.job.model.Project;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

@Mapper
public interface ProjectMapper {
    
    // 전체 프로젝트 목록 조회 (페이징, 필터링 포함)
    List<Project> findAll(@Param("params") Map<String, Object> params);
    
    // 전체 프로젝트 수 조회 (페이징용)
    int countAll(@Param("params") Map<String, Object> params);
    
    // 특정 프로젝트 상세 조회
    Project findById(@Param("id") Long id, @Param("userId") Long userId);
    
    // 조회수 증가
    void incrementViewCount(@Param("id") Long id);
    
    // 프로젝트 지원
    void insertApplication(@Param("projectId") Long projectId, 
                           @Param("userId") Long userId, 
                           @Param("coverLetter") String coverLetter,
                           @Param("proposedBudget") BigDecimal proposedBudget);
    
    // 지원 여부 확인
    boolean hasApplied(@Param("projectId") Long projectId, @Param("userId") Long userId);
    
    // 북마크 추가
    void insertBookmark(@Param("projectId") Long projectId, @Param("userId") Long userId);
    
    // 북마크 삭제
    void deleteBookmark(@Param("projectId") Long projectId, @Param("userId") Long userId);
    
    // 북마크 여부 확인
    boolean isBookmarked(@Param("projectId") Long projectId, @Param("userId") Long userId);
    
    // 북마크 수 조회
    int countBookmarks(@Param("projectId") Long projectId);
    
    // 사용자의 북마크 프로젝트 목록
    List<Project> findBookmarkedProjects(@Param("userId") Long userId, @Param("params") Map<String, Object> params);
    
    // 관련 프로젝트 조회
    List<Project> findRelatedProjects(@Param("projectId") Long projectId, @Param("limit") int limit);
    
    // 인기 프로젝트 조회
    List<Project> findPopularProjects(@Param("limit") int limit);
    
    // 긴급 프로젝트 조회
    List<Project> findUrgentProjects(@Param("limit") int limit);
    
    // 프로젝트 질문 목록 조회
    List<Map<String, Object>> findProjectQuestions(@Param("params") Map<String, Object> params);
    
    // 프로젝트 질문 수 조회
    int countProjectQuestions(@Param("params") Map<String, Object> params);
    
    // 프로젝트 질문 등록
    void insertProjectQuestion(@Param("params") Map<String, Object> params);
    
    // 프로젝트 후기 목록 조회
    List<Map<String, Object>> findProjectReviews(@Param("params") Map<String, Object> params);
    
    // 프로젝트 후기 수 조회
    int countProjectReviews(@Param("params") Map<String, Object> params);
    
    // 프로젝트 후기 등록
    void insertProjectReview(@Param("params") Map<String, Object> params);
}