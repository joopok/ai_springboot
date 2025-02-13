package com.example.pm7.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class NoticeAttachment {
    private Long id;
    private Long noticeId;
    private String fileName;
    private String filePath;
    private LocalDateTime uploadedAt;
} 