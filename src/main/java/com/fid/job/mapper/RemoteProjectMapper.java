package com.fid.job.mapper;

import com.fid.job.model.Project;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface RemoteProjectMapper {
    
    /**
     * 상주/재택 프로젝트 목록 조회
     */
    List<Project> findRemoteProjects(Map<String, Object> params);
    
    /**
     * 상주/재택 프로젝트 개수 조회
     */
    int countRemoteProjects(Map<String, Object> params);
    
    /**
     * 프로젝트 상세 조회
     */
    Project findById(@Param("id") Long id, @Param("userId") Long userId);
    
    /**
     * 프로젝트 조회수 증가
     */
    void incrementViewCount(@Param("id") Long id);
    
    /**
     * 근무 형태별 프로젝트 개수 조회
     */
    int countByWorkType(@Param("workType") String workType);
    
    /**
     * 지역별 상주 프로젝트 분포
     */
    List<Map<String, Object>> getProjectDistributionByLocation();
    
    /**
     * 원격 도구별 프로젝트 분포
     */
    List<Map<String, Object>> getProjectDistributionByRemoteTools();
    
    /**
     * 원격근무 프로젝트에서 사용되는 도구 목록
     */
    List<String> getUniqueRemoteTools();
    
    /**
     * 상주근무 프로젝트의 지역 목록
     */
    List<String> getUniqueOnsiteLocations();
    
    /**
     * 팀 규모별 프로젝트 분포
     */
    List<Map<String, Object>> getProjectDistributionByTeamSize();
    
    /**
     * 유연근무제 여부별 프로젝트 개수
     */
    Map<String, Object> countByFlexibleHours();
    
    /**
     * 주차/식사 제공 여부별 상주 프로젝트 개수
     */
    Map<String, Object> countOnsiteBenefits();
    
    /**
     * 근무 형태별 평균 예산
     */
    Map<String, Object> getAverageBudgetByWorkType();
    
    /**
     * 프로젝트에 사용된 모든 기술 스택 목록 조회
     */
    List<String> getAllProjectSkills();
    
    /**
     * 프로젝트 기술 스택 상위 20개 조회
     */
    List<String> getTopProjectSkills();
}