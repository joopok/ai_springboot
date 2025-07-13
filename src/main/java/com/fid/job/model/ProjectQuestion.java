package com.fid.job.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ProjectQuestion {
    private Long id;
    private Long projectId;
    private Long userId;
    private String content;
    private String answer;
    private Long answeredBy;
    private LocalDateTime answeredAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Join된 정보
    private String authorName;
    private String authorProfileImage;
    private String answererName;
}