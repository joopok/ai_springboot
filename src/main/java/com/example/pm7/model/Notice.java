package com.example.pm7.model;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class Notice {
    private Long id;
    private String title;
    private String content;
    private int readCount;
    private String author;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isTop;
    private boolean loginRequired;
    private List<NoticeAttachment> attachments;
} 