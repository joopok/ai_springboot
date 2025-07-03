package com.example.pm7.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Freelancer {
    private Long id;
    private Long userId;
    private String title;
    private String description;
    private String skills;
    private Integer experienceYears;
    private String experienceLevel; // junior, mid, senior, expert
    private BigDecimal hourlyRate;
    private String availability; // available, busy, unavailable
    private String preferredWorkType; // remote, onsite, hybrid, all
    private String portfolioUrl;
    private String githubUrl;
    private String linkedinUrl;
    private BigDecimal rating;
    private Integer totalReviews;
    private Integer completedProjects;
    private Integer viewCount;
    private Integer projectCount;
    private Boolean isVerified;
    private LocalDateTime verificationDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Join된 사용자 정보
    private String userName;
    private String userEmail;
    private String userFullName;
    private String userPhone;
    private String userProfileImage;
    private String userLocation;
    private String userWebsite;
    private String userBio;
    private String category;
    private String freelancerType;
}