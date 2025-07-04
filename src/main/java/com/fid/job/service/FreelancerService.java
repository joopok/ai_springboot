package com.fid.job.service;

import com.fid.job.model.Freelancer;
import java.util.List;
import java.util.Map;

public interface FreelancerService {
    
    /**
     * 전체 프리랜서 목록 조회 (페이징, 필터링 포함)
     */
    Map<String, Object> getAllFreelancers(Map<String, Object> params);
    
    /**
     * 특정 프리랜서 상세 조회
     */
    Freelancer getFreelancerById(Long id);
    
    /**
     * 특정 사용자의 프리랜서 프로필 조회
     */
    Freelancer getFreelancerByUserId(Long userId);
    
    /**
     * 선택된 프리랜서들 조회 (ID 리스트로)
     */
    List<Freelancer> getFreelancersByIds(List<Long> ids);
    
    /**
     * 기술 스택으로 프리랜서 검색
     */
    List<Freelancer> searchFreelancersBySkills(List<String> skills, Map<String, Object> params);
    
    /**
     * 경험 수준별 프리랜서 조회
     */
    List<Freelancer> getFreelancersByExperienceLevel(String experienceLevel, Map<String, Object> params);
    
    /**
     * 시간당 요금 범위로 프리랜서 조회
     */
    List<Freelancer> getFreelancersByHourlyRateRange(Double minRate, Double maxRate, Map<String, Object> params);
    
    /**
     * 가용성별 프리랜서 조회
     */
    List<Freelancer> getFreelancersByAvailability(String availability, Map<String, Object> params);
    
    /**
     * 평점별 프리랜서 조회
     */
    List<Freelancer> getFreelancersByRating(Double minRating, Map<String, Object> params);
    
    /**
     * 인증된 프리랜서만 조회
     */
    List<Freelancer> getVerifiedFreelancers(Map<String, Object> params);
    
    /**
     * 프리랜서 프로필 등록
     */
    void createFreelancer(Freelancer freelancer);
    
    /**
     * 프리랜서 프로필 수정
     */
    void updateFreelancer(Freelancer freelancer);
    
    /**
     * 프리랜서 프로필 삭제
     */
    void deleteFreelancer(Long id);

    /**
     * 프리랜서 기술 목록 조회
     */
    List<String> freelancerSkillList();
}