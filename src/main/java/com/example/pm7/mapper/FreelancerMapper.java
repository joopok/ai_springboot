package com.example.pm7.mapper;

import com.example.pm7.model.Freelancer;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface FreelancerMapper {
    
    // 전체 프리랜서 목록 조회 (페이징, 필터링 포함)
    List<Freelancer> findAll(@Param("params") Map<String, Object> params);
    
    // 전체 프리랜서 수 조회 (페이징용)
    int countAll(@Param("params") Map<String, Object> params);
    
    // 특정 프리랜서 상세 조회 (사용자 정보 포함)
    Freelancer findById(@Param("id") Long id);
    
    // 특정 사용자의 프리랜서 프로필 조회
    Freelancer findByUserId(@Param("userId") Long userId);
    
    // 선택된 프리랜서들 조회 (ID 리스트로)
    List<Freelancer> findByIds(@Param("ids") List<Long> ids);
    
    // 기술 스택으로 프리랜서 검색
    List<Freelancer> findBySkills(@Param("skills") List<String> skills, @Param("params") Map<String, Object> params);
    
    // 경험 수준별 프리랜서 조회
    List<Freelancer> findByExperienceLevel(@Param("experienceLevel") String experienceLevel, @Param("params") Map<String, Object> params);
    
    // 시간당 요금 범위로 프리랜서 조회
    List<Freelancer> findByHourlyRateRange(@Param("minRate") Double minRate, @Param("maxRate") Double maxRate, @Param("params") Map<String, Object> params);
    
    // 가용성별 프리랜서 조회
    List<Freelancer> findByAvailability(@Param("availability") String availability, @Param("params") Map<String, Object> params);
    
    // 평점별 프리랜서 조회
    List<Freelancer> findByRatingRange(@Param("minRating") Double minRating, @Param("params") Map<String, Object> params);
    
    // 인증된 프리랜서만 조회
    List<Freelancer> findVerifiedFreelancers(@Param("params") Map<String, Object> params);
    
    // 프리랜서 프로필 등록
    void insert(Freelancer freelancer);
    
    // 프리랜서 프로필 수정
    void update(Freelancer freelancer);
    
    // 프리랜서 프로필 삭제
    void delete(@Param("id") Long id);
    
    // 조회수 증가
    void incrementViewCount(@Param("id") Long id);

    // 프리랜서 기술 목록 조회
    List<String> freelancerSkillList();
}