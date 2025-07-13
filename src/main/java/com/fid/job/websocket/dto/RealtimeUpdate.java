package com.fid.job.websocket.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RealtimeUpdate {
    private String type;
    private String projectId;
    private String freelancerId;
    private Object data;
}