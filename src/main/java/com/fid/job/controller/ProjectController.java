package com.fid.job.controller;

import com.fid.job.dto.ApiResponse;
import com.fid.job.dto.ProjectApplicationRequest;
import com.fid.job.model.Project;
import com.fid.job.service.ProjectService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/projects")
@RequiredArgsConstructor
@Slf4j
public class ProjectController {
    
    private final ProjectService projectService;
    
    /**
     * 프로젝트 목록 조회
     */
    @GetMapping
    public ResponseEntity<ApiResponse> getAllProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String projectType,
            @RequestParam(required = false) String workType,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) List<String> skills,
            @RequestParam(required = false) Integer minBudget,
            @RequestParam(required = false) Integer maxBudget,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Boolean urgentOnly,
            @RequestParam(required = false) Boolean featuredOnly,
            @RequestParam(required = false) Integer deadlineWithin,
            @RequestParam(defaultValue = "latest") String sortBy,
            @RequestParam(defaultValue = "true") boolean fastMode,
            HttpServletRequest request) {
        
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("search", search);
            params.put("projectType", projectType);
            params.put("workType", workType);
            params.put("location", location);
            params.put("experienceLevel", experienceLevel);
            params.put("skills", skills);
            params.put("minBudget", minBudget);
            params.put("maxBudget", maxBudget);
            params.put("categoryId", categoryId);
            params.put("urgentOnly", urgentOnly);
            params.put("featuredOnly", featuredOnly);
            params.put("deadlineWithin", deadlineWithin);
            params.put("sortBy", sortBy);
            params.put("fastMode", fastMode);
            
            // 로그인한 사용자 ID 가져오기 (JWT 토큰에서)
            Long userId = getUserIdFromRequest(request);
            if (userId != null) {
                params.put("userId", userId);
            }
            
            Map<String, Object> result = projectService.getAllProjects(params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 프로젝트 상세 조회
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getProjectDetail(
            @PathVariable Long id,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            Project project = projectService.getProjectById(id, userId);
            
            return ResponseEntity.ok(ApiResponse.success(project, "프로젝트 상세 조회 성공"));
        } catch (Exception e) {
            log.error("프로젝트 상세 조회 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 상세 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 프로젝트 지원하기
     */
    @PostMapping("/{id}/apply")
    public ResponseEntity<ApiResponse> applyToProject(
            @PathVariable Long id,
            @Valid @RequestBody ProjectApplicationRequest request,
            HttpServletRequest httpRequest) {
        
        try {
            Long userId = getUserIdFromRequest(httpRequest);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("로그인이 필요합니다"));
            }
            
            projectService.applyToProject(id, userId, request.getCoverLetter(), request.getProposedBudget());
            
            return ResponseEntity.ok(ApiResponse.success(null, "프로젝트 지원 완료"));
        } catch (Exception e) {
            log.error("프로젝트 지원 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 지원 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 북마크 토글
     */
    @PostMapping("/{id}/bookmark")
    public ResponseEntity<ApiResponse> toggleBookmark(
            @PathVariable Long id,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("로그인이 필요합니다"));
            }
            
            boolean isBookmarked = projectService.toggleBookmark(id, userId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("isBookmarked", isBookmarked);
            result.put("message", isBookmarked ? "북마크에 추가되었습니다" : "북마크가 제거되었습니다");
            
            return ResponseEntity.ok(ApiResponse.success(result, "북마크 상태 변경 완료"));
        } catch (Exception e) {
            log.error("북마크 토글 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("북마크 상태 변경 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 북마크 추가
     */
    @PostMapping("/{id}/bookmark/add")
    public ResponseEntity<ApiResponse> addBookmark(
            @PathVariable Long id,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("로그인이 필요합니다"));
            }
            
            projectService.addBookmark(id, userId);
            
            return ResponseEntity.ok(ApiResponse.success(null, "북마크에 추가되었습니다"));
        } catch (Exception e) {
            log.error("북마크 추가 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("북마크 추가 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 북마크 제거
     */
    @DeleteMapping("/{id}/bookmark")
    public ResponseEntity<ApiResponse> removeBookmark(
            @PathVariable Long id,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("로그인이 필요합니다"));
            }
            
            projectService.removeBookmark(id, userId);
            
            return ResponseEntity.ok(ApiResponse.success(null, "북마크가 제거되었습니다"));
        } catch (Exception e) {
            log.error("북마크 제거 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("북마크 제거 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 프로젝트 공유 URL 생성
     */
    @GetMapping("/{id}/share")
    public ResponseEntity<ApiResponse> getShareUrl(@PathVariable Long id) {
        try {
            String shareUrl = projectService.generateShareUrl(id);
            
            Map<String, String> result = new HashMap<>();
            result.put("shareUrl", shareUrl);
            result.put("title", "프로젝트 공유하기");
            
            return ResponseEntity.ok(ApiResponse.success(result, "공유 URL 생성 완료"));
        } catch (Exception e) {
            log.error("공유 URL 생성 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("공유 URL 생성 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 북마크한 프로젝트 목록
     */
    @GetMapping("/bookmarked")
    public ResponseEntity<ApiResponse> getBookmarkedProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("로그인이 필요합니다"));
            }
            
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            
            Map<String, Object> result = projectService.getBookmarkedProjects(userId, params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "북마크한 프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("북마크 프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("북마크 프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 관련 프로젝트 조회
     */
    @GetMapping("/{id}/related")
    public ResponseEntity<ApiResponse> getRelatedProjects(
            @PathVariable Long id,
            @RequestParam(defaultValue = "6") int limit) {
        
        try {
            List<Project> projects = projectService.getRelatedProjects(id, limit);
            
            return ResponseEntity.ok(ApiResponse.success(projects, "관련 프로젝트 조회 성공"));
        } catch (Exception e) {
            log.error("관련 프로젝트 조회 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("관련 프로젝트 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 인기 프로젝트 조회
     */
    @GetMapping("/popular")
    public ResponseEntity<ApiResponse> getPopularProjects(
            @RequestParam(defaultValue = "10") int limit) {
        
        try {
            List<Project> projects = projectService.getPopularProjects(limit);
            
            return ResponseEntity.ok(ApiResponse.success(projects, "인기 프로젝트 조회 성공"));
        } catch (Exception e) {
            log.error("인기 프로젝트 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("인기 프로젝트 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 긴급 프로젝트 조회
     */
    @GetMapping("/urgent")
    public ResponseEntity<ApiResponse> getUrgentProjects(
            @RequestParam(defaultValue = "10") int limit) {
        
        try {
            List<Project> projects = projectService.getUrgentProjects(limit);
            
            return ResponseEntity.ok(ApiResponse.success(projects, "긴급 프로젝트 조회 성공"));
        } catch (Exception e) {
            log.error("긴급 프로젝트 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("긴급 프로젝트 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * JWT 토큰에서 사용자 ID 추출 (실제 구현 필요)
     */
    private Long getUserIdFromRequest(HttpServletRequest request) {
        // TODO: JWT 토큰에서 사용자 ID 추출하는 로직 구현
        // 예시: JwtTokenUtil을 사용하여 토큰에서 사용자 ID 추출
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            // String token = authHeader.substring(7);
            // return jwtTokenUtil.getUserIdFromToken(token);
        }
        return null; // 임시로 null 반환
    }
}