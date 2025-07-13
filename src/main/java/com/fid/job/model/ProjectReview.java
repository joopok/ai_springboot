package com.fid.job.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ProjectReview {
    private Long id;
    private Long projectId;
    private Long userId;
    private Integer rating;
    private String content;
    private String projectDuration;
    private BigDecimal projectBudget;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Join된 정보
    private String authorName;
    private String authorProfileImage;
    private String freelancerName;
}