package com.fid.job.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RemoteProjectDTO {
    
    private Long id;
    private String title;
    private String description;
    
    // 클라이언트 정보
    private ClientInfo client;
    
    // 예산 정보
    private BudgetInfo budget;
    
    // 일정 정보
    private TimelineInfo timeline;
    
    // 스킬 및 카테고리
    private List<String> skills;
    private String category;
    
    // 근무 형태
    private String workType; // full-remote, hybrid, flexible, onsite
    private String location;
    private String onsiteFrequency; // 상주 빈도
    private String officeLocation; // 사무실 상세 위치
    
    // 요구사항 및 산출물
    private List<String> requirements;
    private List<String> deliverables;
    
    // 지원 정보
    private LocalDateTime applicationDeadline;
    private String status;
    private Integer applicationsCount;
    private LocalDateTime postedDate;
    
    // 경력 수준
    private String experienceLevel; // entry, intermediate, expert
    
    // 원격근무 관련
    private List<String> communicationMethods;
    private String timezone;
    private String preferredWorkingHours;
    private List<String> remoteTools;
    
    // 팀 및 개발 환경
    private String teamSize;
    private String developmentMethodology;
    private String codeReviewProcess;
    
    // 상주근무 관련
    private String onsiteRequirements;
    private Boolean parkingAvailable;
    private Boolean mealProvided;
    private Boolean equipmentProvided;
    
    // 복지 혜택
    private List<String> benefits;
    
    // 프로젝트 단계
    private List<ProjectStage> projectStages;
    
    // 실시간 통계
    private Integer viewCount;
    private Integer bookmarkCount;
    
    // 유연근무제
    private Boolean flexibleHours;
    
    // 긴급도
    private String urgency; // low, medium, high
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ClientInfo {
        private String name;
        private String company;
        private Double rating;
        private Integer reviewCount;
        private Integer projectsCompleted;
        private String verificationStatus; // verified, unverified
        private String profileImage;
        private String introduction;
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class BudgetInfo {
        private String type; // fixed, hourly
        private String amount;
        private Boolean negotiable;
        private String currency;
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class TimelineInfo {
        private String duration;
        private LocalDateTime startDate;
        private LocalDateTime deadline;
        private String urgency; // low, medium, high
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ProjectStage {
        private String name;
        private String description;
        private String duration;
        private String status; // upcoming, current, completed
    }
    
    // Project 엔티티로부터 RemoteProjectDTO 생성
    public static RemoteProjectDTO fromProject(com.fid.job.model.Project project) {
        return RemoteProjectDTO.builder()
                .id(project.getId())
                .title(project.getTitle())
                .description(project.getDescription())
                .client(ClientInfo.builder()
                        .name(project.getCompanyName())
                        .company(project.getCompanyName())
                        .build())
                .budget(BudgetInfo.builder()
                        .type("fixed")
                        .amount(project.getBudget())
                        .negotiable(project.getNegotiable() != null ? project.getNegotiable() : true)
                        .currency("KRW")
                        .build())
                .timeline(TimelineInfo.builder()
                        .duration(project.getDuration())
                        .startDate(project.getStartDate() != null ? project.getStartDate().atStartOfDay() : null)
                        .deadline(project.getDeadline() != null ? project.getDeadline().atStartOfDay() : null)
                        .urgency(project.getUrgency())
                        .build())
                .skills(parseJsonArray(project.getRequiredSkills()))
                .category(project.getCategory())
                .workType(project.getWorkType())
                .location(project.getLocation())
                .requirements(parseJsonArray(project.getRequirements()))
                .deliverables(parseJsonArray(project.getDeliverables()))
                .applicationDeadline(project.getDeadline() != null ? project.getDeadline().atStartOfDay() : null)
                .status(project.getStatus())
                .applicationsCount(project.getApplicationsCount())
                .postedDate(project.getCreatedAt())
                .experienceLevel(project.getExperienceLevel())
                .communicationMethods(parseJsonArray(project.getCommunicationMethods()))
                .timezone(project.getTimezone())
                .preferredWorkingHours(project.getPreferredWorkingHours())
                .remoteTools(parseJsonArray(project.getRemoteTools()))
                .teamSize(project.getTeamSize())
                .developmentMethodology(project.getDevelopmentMethodology())
                .codeReviewProcess(project.getCodeReviewProcess())
                .onsiteRequirements(project.getOnsiteRequirements())
                .onsiteFrequency(project.getOnsiteFrequency())
                .officeLocation(project.getOfficeLocation())
                .parkingAvailable(project.getParkingAvailable())
                .mealProvided(project.getMealProvided())
                .equipmentProvided(project.getEquipmentProvided())
                .benefits(parseJsonArray(project.getBenefits()))
                .projectStages(parseProjectStages(project.getProjectStages()))
                .viewCount(project.getViewCount())
                .bookmarkCount(project.getBookmarkCount())
                .flexibleHours(project.getFlexibleHours())
                .urgency(project.getUrgency())
                .build();
    }
    
    private static List<String> parseJsonArray(String jsonString) {
        if (jsonString == null || jsonString.isEmpty()) {
            return List.of();
        }
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            return mapper.readValue(jsonString, List.class);
        } catch (Exception e) {
            return List.of();
        }
    }
    
    private static List<ProjectStage> parseProjectStages(String jsonString) {
        if (jsonString == null || jsonString.isEmpty()) {
            return List.of();
        }
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            List<Map<String, Object>> stages = mapper.readValue(jsonString, List.class);
            return stages.stream()
                    .map(stage -> ProjectStage.builder()
                            .name((String) stage.get("name"))
                            .description((String) stage.get("description"))
                            .duration((String) stage.get("duration"))
                            .status((String) stage.get("status"))
                            .build())
                    .toList();
        } catch (Exception e) {
            return List.of();
        }
    }
}