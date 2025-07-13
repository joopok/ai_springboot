package com.jobkorea.websocket.dto;

import lombok.Data;

@Data
public class RealtimeUpdate {
    private String type; // stats, viewer_join, viewer_leave, application, bookmark, inquiry
    private String projectId;
    private String freelancerId;
    private Object data; // RealtimeStats or other data
}