package com.fid.job.service;

import com.fid.job.mapper.ProjectMapper;
import com.fid.job.model.Project;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProjectServiceImpl implements ProjectService {
    
    private final ProjectMapper projectMapper;
    
    @Override
    public Map<String, Object> getAllProjects(Map<String, Object> params) {
        log.info("프로젝트 목록 조회 - 파라미터: {}", params);
        
        // 페이징 처리
        int page = 1;
        int limit = 20;
        
        // page 파라미터 안전하게 처리
        Object pageParam = params.get("page");
        if (pageParam != null) {
            if (pageParam instanceof Integer) {
                page = Math.max(1, (Integer) pageParam);
            } else if (pageParam instanceof String) {
                try {
                    page = Math.max(1, Integer.parseInt((String) pageParam));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
        }
        
        // limit 파라미터 안전하게 처리
        Object limitParam = params.get("limit");
        if (limitParam != null) {
            if (limitParam instanceof Integer) {
                limit = Math.min(100, Math.max(1, (Integer) limitParam));
            } else if (limitParam instanceof String) {
                try {
                    limit = Math.min(100, Math.max(1, Integer.parseInt((String) limitParam)));
                } catch (NumberFormatException e) {
                    limit = 20;
                }
            }
        }
        
        int offset = (page - 1) * limit;
        
        params.put("offset", offset);
        params.put("limit", limit);
        
        // 성능 최적화: 불필요한 조인 제거
        if (params.get("fastMode") != null && (Boolean) params.get("fastMode")) {
            params.put("includeCompany", true);
            params.put("includeClient", false);
            params.put("includeCategory", false);
        }
        
        List<Project> projects = projectMapper.findAll(params);
        int totalCount = projectMapper.countAll(params);
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        Map<String, Object> result = new HashMap<>();
        result.put("projects", projects);
        result.put("totalCount", totalCount);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        result.put("limit", limit);
        
        log.info("프로젝트 목록 조회 완료 - 총 {}개, {}페이지", totalCount, totalPages);
        return result;
    }
    
    @Override
    @Transactional
    public Project getProjectById(Long id, Long userId) {
        log.info("프로젝트 상세 조회 - ID: {}, User ID: {}", id, userId);
        
        // 조회수 증가
        projectMapper.incrementViewCount(id);
        
        // 프로젝트 조회 (userId 전달)
        Project project = projectMapper.findById(id, userId);
        if (project == null) {
            log.warn("프로젝트를 찾을 수 없음 - ID: {}", id);
            throw new RuntimeException("프로젝트를 찾을 수 없습니다.");
        }
        
        return project;
    }
    
    @Override
    @Transactional
    public void applyToProject(Long projectId, Long userId, String coverLetter, BigDecimal proposedBudget) {
        log.info("프로젝트 지원 - Project ID: {}, User ID: {}", projectId, userId);
        
        // 이미 지원했는지 확인
        if (projectMapper.hasApplied(projectId, userId)) {
            log.warn("이미 지원한 프로젝트 - Project ID: {}, User ID: {}", projectId, userId);
            throw new RuntimeException("이미 지원한 프로젝트입니다.");
        }
        
        // 프로젝트 존재 확인
        Project project = projectMapper.findById(projectId, null);
        if (project == null) {
            throw new RuntimeException("프로젝트를 찾을 수 없습니다.");
        }
        
        if (!"active".equals(project.getStatus())) {
            throw new RuntimeException("지원할 수 없는 프로젝트입니다.");
        }
        
        // 지원하기
        projectMapper.insertApplication(projectId, userId, coverLetter, proposedBudget);
        log.info("프로젝트 지원 완료 - Project ID: {}, User ID: {}", projectId, userId);
    }
    
    @Override
    @Transactional
    public boolean toggleBookmark(Long projectId, Long userId) {
        log.info("북마크 토글 - Project ID: {}, User ID: {}", projectId, userId);
        
        boolean isBookmarked = projectMapper.isBookmarked(projectId, userId);
        
        if (isBookmarked) {
            projectMapper.deleteBookmark(projectId, userId);
            log.info("북마크 제거됨 - Project ID: {}, User ID: {}", projectId, userId);
            return false;
        } else {
            projectMapper.insertBookmark(projectId, userId);
            log.info("북마크 추가됨 - Project ID: {}, User ID: {}", projectId, userId);
            return true;
        }
    }
    
    @Override
    @Transactional
    public void addBookmark(Long projectId, Long userId) {
        log.info("북마크 추가 - Project ID: {}, User ID: {}", projectId, userId);
        
        if (projectMapper.isBookmarked(projectId, userId)) {
            log.warn("이미 북마크된 프로젝트 - Project ID: {}, User ID: {}", projectId, userId);
            return;
        }
        
        projectMapper.insertBookmark(projectId, userId);
    }
    
    @Override
    @Transactional
    public void removeBookmark(Long projectId, Long userId) {
        log.info("북마크 제거 - Project ID: {}, User ID: {}", projectId, userId);
        projectMapper.deleteBookmark(projectId, userId);
    }
    
    @Override
    public boolean isBookmarked(Long projectId, Long userId) {
        return projectMapper.isBookmarked(projectId, userId);
    }
    
    @Override
    public Map<String, Object> getBookmarkedProjects(Long userId, Map<String, Object> params) {
        log.info("북마크한 프로젝트 목록 조회 - User ID: {}", userId);
        
        // 페이징 처리
        int page = 1;
        int limit = 20;
        
        // page 파라미터 안전하게 처리
        Object pageParam = params.get("page");
        if (pageParam != null) {
            if (pageParam instanceof Integer) {
                page = Math.max(1, (Integer) pageParam);
            } else if (pageParam instanceof String) {
                try {
                    page = Math.max(1, Integer.parseInt((String) pageParam));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
        }
        
        // limit 파라미터 안전하게 처리
        Object limitParam = params.get("limit");
        if (limitParam != null) {
            if (limitParam instanceof Integer) {
                limit = Math.min(100, Math.max(1, (Integer) limitParam));
            } else if (limitParam instanceof String) {
                try {
                    limit = Math.min(100, Math.max(1, Integer.parseInt((String) limitParam)));
                } catch (NumberFormatException e) {
                    limit = 20;
                }
            }
        }
        
        int offset = (page - 1) * limit;
        
        params.put("offset", offset);
        params.put("limit", limit);
        
        List<Project> projects = projectMapper.findBookmarkedProjects(userId, params);
        
        Map<String, Object> result = new HashMap<>();
        result.put("projects", projects);
        result.put("currentPage", page);
        result.put("limit", limit);
        
        return result;
    }
    
    @Override
    public List<Project> getRelatedProjects(Long projectId, int limit) {
        log.info("관련 프로젝트 조회 - Project ID: {}, Limit: {}", projectId, limit);
        return projectMapper.findRelatedProjects(projectId, limit);
    }
    
    @Override
    public List<Project> getPopularProjects(int limit) {
        log.info("인기 프로젝트 조회 - Limit: {}", limit);
        return projectMapper.findPopularProjects(limit);
    }
    
    @Override
    public List<Project> getUrgentProjects(int limit) {
        log.info("긴급 프로젝트 조회 - Limit: {}", limit);
        return projectMapper.findUrgentProjects(limit);
    }
    
    @Override
    public String generateShareUrl(Long projectId) {
        // 실제 도메인으로 변경 필요
        String baseUrl = "http://localhost:3000";
        return baseUrl + "/project/" + projectId;
    }
}