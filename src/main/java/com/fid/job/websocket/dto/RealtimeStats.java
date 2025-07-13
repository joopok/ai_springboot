package com.fid.job.websocket.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RealtimeStats {
    private Integer viewCount;
    private Integer currentViewers;
    private Integer applicationsCount;
    private Integer bookmarkCount;
    private Integer inquiryCount;
}