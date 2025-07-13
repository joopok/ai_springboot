package com.jobkorea.websocket.dto;

import lombok.Data;

@Data
public class JoinRoomRequest {
    private String projectId;
    private String freelancerId;
}