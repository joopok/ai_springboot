package com.fid.job.service;

import com.fid.job.dto.RemoteProjectDTO;
import com.fid.job.mapper.RemoteProjectMapper;
import com.fid.job.model.Project;
import com.fid.job.util.JsonSanitizer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class RemoteProjectServiceImpl implements RemoteProjectService {
    
    private final RemoteProjectMapper remoteProjectMapper;
    
    @Override
    public Map<String, Object> getRemoteProjects(Map<String, Object> params) {
        log.info("프로젝트 목록 조회 - 파라미터: {}", params);
        
        // 페이징 처리
        int page = 1;
        int limit = 10;
        
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
                    limit = 10;
                }
            }
        }
        
        int offset = (page - 1) * limit;
        params.put("offset", offset);
        params.put("limit", limit);
        
        // 기본값 설정
        params.put("includeCompany", true);
        params.put("includeClient", true);
        params.put("includeCategory", true);
        
        List<Project> projects = remoteProjectMapper.findRemoteProjects(params);
        
        // Sanitize project data
        List<RemoteProjectDTO> sanitizedProjects = projects.stream()
            .map(this::sanitizeProject)
            .map(RemoteProjectDTO::fromProject)
            .collect(Collectors.toList());
        
        int totalCount = remoteProjectMapper.countRemoteProjects(params);
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        Map<String, Object> result = new HashMap<>();
        result.put("projects", sanitizedProjects);
        result.put("totalCount", totalCount);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        result.put("limit", limit);
        
        log.info("프로젝트 목록 조회 완료 - 총 {}개, {}페이지", totalCount, totalPages);
        return result;
    }
    
    @Override
    @Transactional
    public RemoteProjectDTO getRemoteProjectById(Long id, Long userId) {
        log.info("프로젝트 상세 조회 - ID: {}, User ID: {}", id, userId);
        
        // 프로젝트 조회
        Project project = remoteProjectMapper.findById(id, userId);
        if (project == null) {
            log.warn("프로젝트를 찾을 수 없음 - ID: {}", id);
            return null;
        }
        
        // Project를 RemoteProjectDTO로 변환
        RemoteProjectDTO remoteProject = RemoteProjectDTO.fromProject(sanitizeProject(project));
        
        // 클라이언트 정보 보강 (필요시)
        if (remoteProject.getClient() != null) {
            remoteProject.getClient().setRating(4.5);
            remoteProject.getClient().setReviewCount(12);
            remoteProject.getClient().setProjectsCompleted(8);
            remoteProject.getClient().setVerificationStatus("verified");
        }
        
        return remoteProject;
    }
    
    @Override
    @Transactional
    public void incrementViewCount(Long projectId) {
        log.info("프로젝트 조회수 증가 - ID: {}", projectId);
        remoteProjectMapper.incrementViewCount(projectId);
    }
    
    @Override
    public Map<String, Object> searchRemoteProjects(Map<String, Object> params) {
        params.put("workType", "remote");
        return getRemoteProjects(params);
    }
    
    @Override
    public Map<String, Object> searchOnsiteProjects(Map<String, Object> params) {
        params.put("workType", "onsite");
        return getRemoteProjects(params);
    }
    
    @Override
    public Map<String, Object> searchHybridProjects(Map<String, Object> params) {
        params.put("workType", "hybrid");
        return getRemoteProjects(params);
    }
    
    @Override
    public Map<String, Object> getProjectStatsByWorkType() {
        log.info("근무 형태별 프로젝트 통계 조회");
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("remote", remoteProjectMapper.countByWorkType("remote"));
        stats.put("onsite", remoteProjectMapper.countByWorkType("onsite"));
        stats.put("hybrid", remoteProjectMapper.countByWorkType("hybrid"));
        
        return stats;
    }
    
    @Override
    public Map<String, Object> getOnsiteProjectsByLocation() {
        log.info("지역별 상주 프로젝트 분포 조회");
        
        List<Map<String, Object>> distribution = remoteProjectMapper.getProjectDistributionByLocation();
        
        Map<String, Object> result = new HashMap<>();
        result.put("distribution", distribution);
        result.put("total", distribution.stream().mapToInt(d -> (Integer) d.get("count")).sum());
        
        return result;
    }
    
    @Override
    public Map<String, Object> getProjectsByRemoteTools() {
        log.info("원격 도구별 프로젝트 분포 조회");
        
        List<Map<String, Object>> distribution = remoteProjectMapper.getProjectDistributionByRemoteTools();
        
        Map<String, Object> result = new HashMap<>();
        result.put("distribution", distribution);
        result.put("total", distribution.size());
        
        return result;
    }
    
    @Override
    public List<String> getProjectSkills() {
        log.info("프로젝트 기술 스택 목록 조회");
        
        List<String> skills = remoteProjectMapper.getAllProjectSkills();
        log.info("프로젝트 기술 스택 조회 완료 - 총 {}개", skills.size());
        
        return skills;
    }
    
    @Override
    public List<String> getTopProjectSkills() {
        log.info("프로젝트 기술 스택 상위 20개 조회");
        
        List<String> skills = remoteProjectMapper.getTopProjectSkills();
        log.info("프로젝트 기술 스택 상위 20개 조회 완료");
        
        return skills;
    }
    
    /**
     * Sanitize project data to remove invalid characters
     */
    private Project sanitizeProject(Project project) {
        if (project == null) {
            return null;
        }
        
        // Sanitize all string fields
        project.setTitle(JsonSanitizer.sanitize(project.getTitle()));
        project.setDescription(JsonSanitizer.sanitize(project.getDescription()));
        project.setCategory(JsonSanitizer.sanitize(project.getCategory()));
        project.setProjectType(JsonSanitizer.sanitize(project.getProjectType()));
        project.setBudgetType(JsonSanitizer.sanitize(project.getBudgetType()));
        project.setWorkType(JsonSanitizer.sanitize(project.getWorkType()));
        project.setLocation(JsonSanitizer.sanitize(project.getLocation()));
        project.setDuration(JsonSanitizer.sanitize(project.getDuration()));
        project.setRequiredSkills(JsonSanitizer.sanitize(project.getRequiredSkills()));
        project.setPreferredSkills(JsonSanitizer.sanitize(project.getPreferredSkills()));
        project.setExperienceLevel(JsonSanitizer.sanitize(project.getExperienceLevel()));
        project.setStatus(JsonSanitizer.sanitize(project.getStatus()));
        project.setCompanyName(JsonSanitizer.sanitize(project.getCompanyName()));
        project.setCompanyLogo(JsonSanitizer.sanitize(project.getCompanyLogo()));
        project.setClientName(JsonSanitizer.sanitize(project.getClientName()));
        project.setCategoryName(JsonSanitizer.sanitize(project.getCategoryName()));
        project.setRemoteTools(JsonSanitizer.sanitize(project.getRemoteTools()));
        project.setCommunicationMethods(JsonSanitizer.sanitize(project.getCommunicationMethods()));
        project.setTeamSize(JsonSanitizer.sanitize(project.getTeamSize()));
        project.setDevelopmentMethodology(JsonSanitizer.sanitize(project.getDevelopmentMethodology()));
        project.setCodeReviewProcess(JsonSanitizer.sanitize(project.getCodeReviewProcess()));
        project.setWorkingHours(JsonSanitizer.sanitize(project.getWorkingHours()));
        project.setTimezone(JsonSanitizer.sanitize(project.getTimezone()));
        project.setOnsiteRequirements(JsonSanitizer.sanitize(project.getOnsiteRequirements()));
        project.setOnsiteFrequency(JsonSanitizer.sanitize(project.getOnsiteFrequency()));
        project.setOfficeLocation(JsonSanitizer.sanitize(project.getOfficeLocation()));
        project.setBenefits(JsonSanitizer.sanitize(project.getBenefits()));
        project.setPreferredWorkingHours(JsonSanitizer.sanitize(project.getPreferredWorkingHours()));
        project.setDeliverables(JsonSanitizer.sanitize(project.getDeliverables()));
        project.setProjectStages(JsonSanitizer.sanitize(project.getProjectStages()));
        project.setUrgency(JsonSanitizer.sanitize(project.getUrgency()));
        project.setBudget(JsonSanitizer.sanitize(project.getBudget()));
        project.setRequirements(JsonSanitizer.sanitize(project.getRequirements()));
        
        return project;
    }
}