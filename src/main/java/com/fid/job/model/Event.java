package com.fid.job.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Event {
    private Long eventId;
    private String title;
    private String description;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 