package com.jobkorea.websocket.dto;

import lombok.Data;

@Data
public class RealtimeStats {
    private Integer viewCount;
    private Integer currentViewers;
    private Integer applicationsCount;
    private Integer bookmarkCount;
    private Integer inquiryCount;
}