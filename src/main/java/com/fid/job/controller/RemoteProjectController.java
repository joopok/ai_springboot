package com.fid.job.controller;

import com.fid.job.dto.ApiResponse;
import com.fid.job.dto.RemoteProjectDTO;
import com.fid.job.service.RemoteProjectService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/remote-projects")
@RequiredArgsConstructor
@Slf4j
public class RemoteProjectController {
    
    private final RemoteProjectService remoteProjectService;
    
    /**
     * 상주/재택 프로젝트 목록 조회
     */
    @GetMapping
    public ResponseEntity<ApiResponse> getRemoteProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String workType,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) List<String> skills,
            @RequestParam(required = false) String teamSize,
            @RequestParam(required = false) String onsiteFrequency,
            @RequestParam(required = false) Boolean flexibleHours,
            @RequestParam(defaultValue = "latest") String sortBy,
            HttpServletRequest request) {
        
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("search", search);
            params.put("workType", workType);
            params.put("location", location);
            params.put("experienceLevel", experienceLevel);
            params.put("skills", skills);
            params.put("teamSize", teamSize);
            params.put("onsiteFrequency", onsiteFrequency);
            params.put("flexibleHours", flexibleHours);
            params.put("sortBy", sortBy);
            
            // 로그인한 사용자 ID 가져오기
            Long userId = getUserIdFromRequest(request);
            if (userId != null) {
                params.put("userId", userId);
            }
            
            Map<String, Object> result = remoteProjectService.getRemoteProjects(params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 상주/재택 프로젝트 상세 조회
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getRemoteProjectDetail(
            @PathVariable Long id,
            HttpServletRequest request) {
        
        try {
            Long userId = getUserIdFromRequest(request);
            RemoteProjectDTO project = remoteProjectService.getRemoteProjectById(id, userId);
            
            if (project == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("프로젝트를 찾을 수 없습니다"));
            }
            
            // 조회수 증가
            remoteProjectService.incrementViewCount(id);
            
            return ResponseEntity.ok(ApiResponse.success(project, "프로젝트 상세 조회 성공"));
        } catch (Exception e) {
            log.error("프로젝트 상세 조회 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 상세 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 원격근무 프로젝트 목록 조회
     */
    @GetMapping("/remote")
    public ResponseEntity<ApiResponse> getRemoteOnlyProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) List<String> skills,
            @RequestParam(required = false) List<String> remoteTools,
            @RequestParam(required = false) List<String> communicationMethods,
            @RequestParam(defaultValue = "latest") String sortBy,
            HttpServletRequest request) {
        
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("search", search);
            params.put("workType", "remote");
            params.put("experienceLevel", experienceLevel);
            params.put("skills", skills);
            params.put("remoteTools", remoteTools);
            params.put("communicationMethods", communicationMethods);
            params.put("sortBy", sortBy);
            
            Long userId = getUserIdFromRequest(request);
            if (userId != null) {
                params.put("userId", userId);
            }
            
            Map<String, Object> result = remoteProjectService.getRemoteProjects(params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "원격근무 프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("원격근무 프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("원격근무 프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 상주근무 프로젝트 목록 조회
     */
    @GetMapping("/onsite")
    public ResponseEntity<ApiResponse> getOnsiteProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) List<String> skills,
            @RequestParam(required = false) String onsiteFrequency,
            @RequestParam(required = false) Boolean parkingAvailable,
            @RequestParam(required = false) Boolean mealProvided,
            @RequestParam(defaultValue = "latest") String sortBy,
            HttpServletRequest request) {
        
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("search", search);
            params.put("workType", "onsite");
            params.put("location", location);
            params.put("experienceLevel", experienceLevel);
            params.put("skills", skills);
            params.put("onsiteFrequency", onsiteFrequency);
            params.put("parkingAvailable", parkingAvailable);
            params.put("mealProvided", mealProvided);
            params.put("sortBy", sortBy);
            
            Long userId = getUserIdFromRequest(request);
            if (userId != null) {
                params.put("userId", userId);
            }
            
            Map<String, Object> result = remoteProjectService.getRemoteProjects(params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "상주근무 프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("상주근무 프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("상주근무 프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 하이브리드 프로젝트 목록 조회
     */
    @GetMapping("/hybrid")
    public ResponseEntity<ApiResponse> getHybridProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) List<String> skills,
            @RequestParam(required = false) String onsiteFrequency,
            @RequestParam(required = false) Boolean flexibleHours,
            @RequestParam(defaultValue = "latest") String sortBy,
            HttpServletRequest request) {
        
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("search", search);
            params.put("workType", "hybrid");
            params.put("location", location);
            params.put("experienceLevel", experienceLevel);
            params.put("skills", skills);
            params.put("onsiteFrequency", onsiteFrequency);
            params.put("flexibleHours", flexibleHours);
            params.put("sortBy", sortBy);
            
            Long userId = getUserIdFromRequest(request);
            if (userId != null) {
                params.put("userId", userId);
            }
            
            Map<String, Object> result = remoteProjectService.getRemoteProjects(params);
            
            return ResponseEntity.ok(ApiResponse.success(result, "하이브리드 프로젝트 목록 조회 성공"));
        } catch (Exception e) {
            log.error("하이브리드 프로젝트 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("하이브리드 프로젝트 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 프로젝트 기술 스택 목록 조회
     */
    @GetMapping("/skills")
    public ResponseEntity<ApiResponse> getProjectSkills() {
        try {
            log.info("프로젝트 기술 스택 상위 20개 조회 요청");
            List<String> skills = remoteProjectService.getTopProjectSkills();
            log.info("프로젝트 기술 스택 상위 20개 조회 성공");
            return ResponseEntity.ok(ApiResponse.success(skills, "프로젝트 기술 스택 목록을 성공적으로 조회했습니다."));
        } catch (Exception e) {
            log.error("프로젝트 기술 스택 목록 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("프로젝트 기술 스택 목록 조회 실패: " + e.getMessage()));
        }
    }
    
    /**
     * 프로젝트 조회수 증가
     */
    @PostMapping("/{id}/view")
    public ResponseEntity<ApiResponse> incrementViewCount(@PathVariable Long id) {
        try {
            log.info("프로젝트 조회수 증가 요청 - ID: {}", id);
            remoteProjectService.incrementViewCount(id);
            return ResponseEntity.ok(ApiResponse.success(null, "조회수가 증가되었습니다."));
        } catch (Exception e) {
            log.error("프로젝트 조회수 증가 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("조회수 증가 실패: " + e.getMessage()));
        }
    }
    
    /**
     * JWT 토큰에서 사용자 ID 추출
     */
    private Long getUserIdFromRequest(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            // String token = authHeader.substring(7);
            // return jwtTokenUtil.getUserIdFromToken(token);
        }
        return null;
    }
}