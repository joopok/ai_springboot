package com.example.pm7.controller;

import com.example.pm7.dto.ApiResponse;
import com.example.pm7.model.Freelancer;
import com.example.pm7.service.FreelancerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/freelancers")
@CrossOrigin(origins = {"http://localhost:3000", "http://127.0.0.1:3000"})
@Slf4j
public class FreelancerController {

    @Autowired
    private FreelancerService freelancerService;

    /**
     * 전체 프리랜서 목록 조회 (페이징, 필터링 포함)
     * GET /api/freelancers
     */
    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> getAllFreelancers(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) String availability,
            @RequestParam(required = false) Double minRate,
            @RequestParam(required = false) Double maxRate,
            @RequestParam(required = false) Double minRating,
            @RequestParam(required = false) Boolean isVerified,
            @RequestParam(required = false) String skills,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String experienceRange,
            @RequestParam(required = false) String freelancerType,
            @RequestParam(defaultValue = "created_at") String sortBy) {
        
        try {
            log.info("프리랜서 목록 조회 요청 - 페이지: {}, 크기: {}", page, limit);
            
            Map<String, Object> params = new HashMap<>();
            params.put("page", page);
            params.put("limit", limit);
            params.put("experienceLevel", experienceLevel);
            params.put("availability", availability);
            params.put("minRate", minRate);
            params.put("maxRate", maxRate);
            params.put("minRating", minRating);
            params.put("isVerified", isVerified);
            params.put("keyword", keyword);
            params.put("category", category);
            params.put("experienceRange", experienceRange);
            params.put("freelancerType", freelancerType);
            params.put("sortBy", sortBy);
            
            // 기술 스택 처리 (쉼표로 구분된 문자열을 리스트로 변환)
            if (skills != null && !skills.trim().isEmpty()) {
                List<String> skillList = Arrays.asList(skills.split(","))
                        .stream()
                        .map(skill -> skill.replaceAll("\"", ""))
                        .collect(Collectors.toList());
                params.put("skills", skillList);
            }
            
            Map<String, Object> result = freelancerService.getAllFreelancers(params);
            
            log.info("프리랜서 목록 조회 성공 - 총 {}명", result.get("totalCount"));
            return ResponseEntity.ok(ApiResponse.success(result, "프리랜서 목록을 성공적으로 조회했습니다."));
            
        } catch (Exception e) {
            log.error("프리랜서 목록 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("프리랜서 목록 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 특정 프리랜서 상세 조회
     * GET /api/freelancers/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Freelancer>> getFreelancerById(@PathVariable Long id) {
        try {
            log.info("프리랜서 상세 조회 요청 - ID: {}", id);
            
            Freelancer freelancer = freelancerService.getFreelancerById(id);
            
            log.info("프리랜서 상세 조회 성공 - ID: {}, 이름: {}", id, freelancer.getUserFullName());
            return ResponseEntity.ok(ApiResponse.success(freelancer, "프리랜서 정보를 성공적으로 조회했습니다."));
            
        } catch (RuntimeException e) {
            log.warn("프리랜서 조회 실패 - ID: {}, 오류: {}", id, e.getMessage());
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            log.error("프리랜서 상세 조회 중 오류 발생 - ID: {}", id, e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("프리랜서 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 선택된 프리랜서들 조회 (ID 리스트로)
     * GET /api/freelancers/selected
     */
    @GetMapping("/selected")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getSelectedFreelancers(
            @RequestParam String ids) {
        try {
            log.info("선택된 프리랜서들 조회 요청 - IDs: {}", ids);
            
            List<Long> idList = Arrays.stream(ids.split(","))
                    .map(String::trim)
                    .map(Long::parseLong)
                    .collect(Collectors.toList());
            
            List<Freelancer> freelancers = freelancerService.getFreelancersByIds(idList);
            
            log.info("선택된 프리랜서들 조회 성공 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "선택된 프리랜서 목록을 성공적으로 조회했습니다."));
            
        } catch (IllegalArgumentException e) {
            log.warn("잘못된 요청 - {}", e.getMessage());
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("잘못된 요청입니다: " + e.getMessage()));
        } catch (Exception e) {
            log.error("선택된 프리랜서들 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("프리랜서 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 기술 스택으로 프리랜서 검색
     * GET /api/freelancers/search/skills
     */
    @GetMapping("/search/skills")
    public ResponseEntity<ApiResponse<List<Freelancer>>> searchBySkills(
            @RequestParam String skills,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("기술 스택으로 프리랜서 검색 - 스킬: {}", skills);
            
            List<String> skillList = Arrays.asList(skills.split(","));
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.searchFreelancersBySkills(skillList, params);
            
            log.info("기술 스택 검색 완료 - {}명 발견", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "기술 스택 검색이 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("기술 스택 검색 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("기술 스택 검색 중 오류가 발생했습니다."));
        }
    }

    /**
     * 경험 수준별 프리랜서 조회
     * GET /api/freelancers/experience/{level}
     */
    @GetMapping("/experience/{level}")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getByExperienceLevel(
            @PathVariable String level,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("경험 수준별 프리랜서 조회 - 레벨: {}", level);
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.getFreelancersByExperienceLevel(level, params);
            
            log.info("경험 수준별 조회 완료 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "경험 수준별 프리랜서 조회가 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("경험 수준별 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("경험 수준별 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 시간당 요금 범위로 프리랜서 조회
     * GET /api/freelancers/hourly-rate
     */
    @GetMapping("/hourly-rate")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getByHourlyRateRange(
            @RequestParam(required = false) Double minRate,
            @RequestParam(required = false) Double maxRate,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("시간당 요금 범위로 프리랜서 조회 - 최소: {}, 최대: {}", minRate, maxRate);
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.getFreelancersByHourlyRateRange(minRate, maxRate, params);
            
            log.info("시간당 요금 범위 조회 완료 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "시간당 요금 범위 조회가 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("시간당 요금 범위 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("시간당 요금 범위 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 가용성별 프리랜서 조회
     * GET /api/freelancers/availability/{status}
     */
    @GetMapping("/availability/{status}")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getByAvailability(
            @PathVariable String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("가용성별 프리랜서 조회 - 상태: {}", status);
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.getFreelancersByAvailability(status, params);
            
            log.info("가용성별 조회 완료 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "가용성별 프리랜서 조회가 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("가용성별 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("가용성별 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 평점별 프리랜서 조회
     * GET /api/freelancers/rating
     */
    @GetMapping("/rating")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getByRating(
            @RequestParam Double minRating,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("평점별 프리랜서 조회 - 최소 평점: {}", minRating);
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.getFreelancersByRating(minRating, params);
            
            log.info("평점별 조회 완료 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "평점별 프리랜서 조회가 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("평점별 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("평점별 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 인증된 프리랜서만 조회
     * GET /api/freelancers/verified
     */
    @GetMapping("/verified")
    public ResponseEntity<ApiResponse<List<Freelancer>>> getVerifiedFreelancers(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            log.info("인증된 프리랜서 조회");
            
            Map<String, Object> params = new HashMap<>();
            params.put("offset", (page - 1) * limit);
            params.put("limit", limit);
            
            List<Freelancer> freelancers = freelancerService.getVerifiedFreelancers(params);
            
            log.info("인증된 프리랜서 조회 완료 - {}명", freelancers.size());
            return ResponseEntity.ok(ApiResponse.success(freelancers, "인증된 프리랜서 조회가 완료되었습니다."));
            
        } catch (Exception e) {
            log.error("인증된 프리랜서 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("인증된 프리랜서 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 사용자별 프리랜서 프로필 조회
     * GET /api/freelancers/user/{userId}
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<Freelancer>> getFreelancerByUserId(@PathVariable Long userId) {
        try {
            log.info("사용자별 프리랜서 프로필 조회 - 사용자 ID: {}", userId);
            
            Freelancer freelancer = freelancerService.getFreelancerByUserId(userId);
            
            if (freelancer == null) {
                log.info("해당 사용자의 프리랜서 프로필이 없음 - 사용자 ID: {}", userId);
                return ResponseEntity.ok(ApiResponse.success(null, "해당 사용자의 프리랜서 프로필이 없습니다."));
            }
            
            log.info("사용자별 프리랜서 프로필 조회 성공 - 사용자 ID: {}", userId);
            return ResponseEntity.ok(ApiResponse.success(freelancer, "프리랜서 프로필을 성공적으로 조회했습니다."));
            
        } catch (Exception e) {
            log.error("사용자별 프리랜서 프로필 조회 중 오류 발생 - 사용자 ID: {}", userId, e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("프리랜서 프로필 조회 중 오류가 발생했습니다."));
        }
    }

    /**
     * 프리랜서 기술 스택 목록 조회
     * GET /api/freelancers/skills
     */
    @GetMapping("/skills")
    public ResponseEntity<ApiResponse<List<String>>> freelancerSkillList() {
        try {
            log.info("프리랜서 기술 스택 목록 조회 요청");
            List<String> skills = freelancerService.freelancerSkillList();
            log.info("프리랜서 기술 스택 목록 조회 성공 - 총 {}개", skills.size());
            return ResponseEntity.ok(ApiResponse.success(skills, "프리랜서 기술 스택 목록을 성공적으로 조회했습니다."));
        } catch (Exception e) {
            log.error("프리랜서 기술 스택 목록 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.error("프리랜서 기술 스택 목록 조회 중 오류가 발생했습니다."));
        }
    }
}