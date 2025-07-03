package com.example.pm7.service;

import com.example.pm7.mapper.FreelancerMapper;
import com.example.pm7.model.Freelancer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class FreelancerServiceImpl implements FreelancerService {

    @Autowired
    private FreelancerMapper freelancerMapper;

    @Override
    public Map<String, Object> getAllFreelancers(Map<String, Object> params) {
        log.info("전체 프리랜서 목록 조회 - 파라미터: {}", params);
        
        // 페이징 처리
        int page = (Integer) params.getOrDefault("page", 1);
        int limit = (Integer) params.getOrDefault("limit", 10);
        int offset = (page - 1) * limit;
        
        params.put("offset", offset);
        params.put("limit", limit);
        
        List<Freelancer> freelancers = freelancerMapper.findAll(params);
        int totalCount = freelancerMapper.countAll(params);
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        Map<String, Object> result = new HashMap<>();
        result.put("freelancers", freelancers);
        result.put("totalCount", totalCount);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        result.put("limit", limit);
        
        log.info("프리랜서 목록 조회 완료 - 총 {}명, {}페이지", totalCount, totalPages);
        return result;
    }

    @Override
    @Transactional
    public Freelancer getFreelancerById(Long id) {
        log.info("프리랜서 상세 조회 - ID: {}", id);
        Freelancer freelancer = freelancerMapper.findById(id);
        if (freelancer == null) {
            log.warn("프리랜서를 찾을 수 없음 - ID: {}", id);
            throw new RuntimeException("프리랜서를 찾을 수 없습니다.");
        }
        
        // 조회수 증가
        freelancerMapper.incrementViewCount(id);
        log.debug("프리랜서 조회수 증가 - ID: {}", id);
        
        return freelancer;
    }

    @Override
    public Freelancer getFreelancerByUserId(Long userId) {
        log.info("사용자별 프리랜서 프로필 조회 - User ID: {}", userId);
        return freelancerMapper.findByUserId(userId);
    }

    @Override
    public List<Freelancer> getFreelancersByIds(List<Long> ids) {
        log.info("선택된 프리랜서들 조회 - IDs: {}", ids);
        if (ids == null || ids.isEmpty()) {
            throw new IllegalArgumentException("프리랜서 ID 목록이 비어있습니다.");
        }
        return freelancerMapper.findByIds(ids);
    }

    @Override
    public List<Freelancer> searchFreelancersBySkills(List<String> skills, Map<String, Object> params) {
        log.info("기술 스택으로 프리랜서 검색 - 스킬: {}", skills);
        if (skills == null || skills.isEmpty()) {
            throw new IllegalArgumentException("검색할 기술 스택이 없습니다.");
        }
        return freelancerMapper.findBySkills(skills, params);
    }

    @Override
    public List<Freelancer> getFreelancersByExperienceLevel(String experienceLevel, Map<String, Object> params) {
        log.info("경험 수준별 프리랜서 조회 - 레벨: {}", experienceLevel);
        return freelancerMapper.findByExperienceLevel(experienceLevel, params);
    }

    @Override
    public List<Freelancer> getFreelancersByHourlyRateRange(Double minRate, Double maxRate, Map<String, Object> params) {
        log.info("시간당 요금 범위 프리랜서 조회 - 최소: {}, 최대: {}", minRate, maxRate);
        return freelancerMapper.findByHourlyRateRange(minRate, maxRate, params);
    }

    @Override
    public List<Freelancer> getFreelancersByAvailability(String availability, Map<String, Object> params) {
        log.info("가용성별 프리랜서 조회 - 상태: {}", availability);
        return freelancerMapper.findByAvailability(availability, params);
    }

    @Override
    public List<Freelancer> getFreelancersByRating(Double minRating, Map<String, Object> params) {
        log.info("평점별 프리랜서 조회 - 최소 평점: {}", minRating);
        return freelancerMapper.findByRatingRange(minRating, params);
    }

    @Override
    public List<Freelancer> getVerifiedFreelancers(Map<String, Object> params) {
        log.info("인증된 프리랜서 조회");
        return freelancerMapper.findVerifiedFreelancers(params);
    }

    @Override
    @Transactional
    public void createFreelancer(Freelancer freelancer) {
        log.info("프리랜서 프로필 등록 - 사용자 ID: {}", freelancer.getUserId());
        
        // 기본값 설정
        if (freelancer.getExperienceYears() == null) {
            freelancer.setExperienceYears(0);
        }
        if (freelancer.getExperienceLevel() == null) {
            freelancer.setExperienceLevel("junior");
        }
        if (freelancer.getAvailability() == null) {
            freelancer.setAvailability("available");
        }
        if (freelancer.getPreferredWorkType() == null) {
            freelancer.setPreferredWorkType("all");
        }
        if (freelancer.getIsVerified() == null) {
            freelancer.setIsVerified(false);
        }
        
        freelancerMapper.insert(freelancer);
        log.info("프리랜서 프로필 등록 완료 - ID: {}", freelancer.getId());
    }

    @Override
    @Transactional
    public void updateFreelancer(Freelancer freelancer) {
        log.info("프리랜서 프로필 수정 - ID: {}", freelancer.getId());
        
        // 기존 프리랜서 존재 확인
        Freelancer existingFreelancer = freelancerMapper.findById(freelancer.getId());
        if (existingFreelancer == null) {
            throw new RuntimeException("수정할 프리랜서 프로필을 찾을 수 없습니다.");
        }
        
        freelancerMapper.update(freelancer);
        log.info("프리랜서 프로필 수정 완료 - ID: {}", freelancer.getId());
    }

    @Override
    @Transactional
    public void deleteFreelancer(Long id) {
        log.info("프리랜서 프로필 삭제 - ID: {}", id);
        
        // 기존 프리랜서 존재 확인
        Freelancer existingFreelancer = freelancerMapper.findById(id);
        if (existingFreelancer == null) {
            throw new RuntimeException("삭제할 프리랜서 프로필을 찾을 수 없습니다.");
        }
        
        freelancerMapper.delete(id);
        log.info("프리랜서 프로필 삭제 완료 - ID: {}", id);
    }

    @Override
    public List<String> freelancerSkillList() {
        log.info("프리랜서 기술 목록 조회");
        return freelancerMapper.freelancerSkillList();
    }
}