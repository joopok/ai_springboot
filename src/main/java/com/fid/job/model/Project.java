package com.fid.job.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Project {
    private Long id;
    private Long companyId;
    private Long clientId;
    private Long categoryId;
    private String category;
    private String title;
    private String description;
    private String projectType; // full_time, part_time, contract, freelance, internship
    private String budgetType; // fixed, hourly, negotiable
    private String workType; // remote, onsite, hybrid
    private String location;
    private BigDecimal budgetMin;
    private BigDecimal budgetMax;
    private String duration;
    private LocalDate startDate;
    private LocalDate deadline;
    private String requiredSkills; // JSON
    private String preferredSkills; // JSON
    private Integer experienceYears;
    private String experienceLevel; // junior, mid, senior, expert
    private String status; // draft, active, in_progress, closed, completed, cancelled
    private Integer views;
    private Integer applications;
    private Integer applicationsCount;
    private Boolean isFeatured;
    private Boolean isUrgent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Join된 정보
    private String companyName;
    private String companyLogo;
    private String clientName;
    private String categoryName;
    
    // 추가 정보
    private Boolean isBookmarked;
    private Boolean hasApplied;
    private Integer bookmarkCount;
}