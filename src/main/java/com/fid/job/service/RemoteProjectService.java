package com.fid.job.service;

import com.fid.job.dto.RemoteProjectDTO;
import java.util.List;
import java.util.Map;

public interface RemoteProjectService {
    
    /**
     * 상주/재택 프로젝트 목록 조회
     */
    Map<String, Object> getRemoteProjects(Map<String, Object> params);
    
    /**
     * 상주/재택 프로젝트 상세 조회
     */
    RemoteProjectDTO getRemoteProjectById(Long id, Long userId);
    
    /**
     * 프로젝트 조회수 증가
     */
    void incrementViewCount(Long projectId);
    
    /**
     * 원격근무 관련 필터 적용된 프로젝트 검색
     */
    Map<String, Object> searchRemoteProjects(Map<String, Object> params);
    
    /**
     * 상주근무 관련 필터 적용된 프로젝트 검색
     */
    Map<String, Object> searchOnsiteProjects(Map<String, Object> params);
    
    /**
     * 하이브리드 근무 관련 필터 적용된 프로젝트 검색
     */
    Map<String, Object> searchHybridProjects(Map<String, Object> params);
    
    /**
     * 근무 형태별 프로젝트 통계
     */
    Map<String, Object> getProjectStatsByWorkType();
    
    /**
     * 지역별 상주 프로젝트 분포
     */
    Map<String, Object> getOnsiteProjectsByLocation();
    
    /**
     * 원격 도구별 프로젝트 분포
     */
    Map<String, Object> getProjectsByRemoteTools();
    
    /**
     * 프로젝트 기술 스택 목록 조회
     */
    List<String> getProjectSkills();
    
    /**
     * 프로젝트 기술 스택 상위 20개 조회
     */
    List<String> getTopProjectSkills();
}