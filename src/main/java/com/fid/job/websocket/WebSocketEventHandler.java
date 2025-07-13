package com.fid.job.websocket;

import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.annotation.OnConnect;
import com.corundumstudio.socketio.annotation.OnDisconnect;
import com.corundumstudio.socketio.annotation.OnEvent;
import com.fid.job.websocket.dto.JoinRoomRequest;
import com.fid.job.websocket.dto.RealtimeUpdate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.HashMap;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketEventHandler {

    private final SocketIOServer server;
    private final WebSocketService webSocketService;
    
    // 클라이언트별 룸 정보 관리
    private final Map<UUID, String> clientRooms = new ConcurrentHashMap<>();
    
    @OnConnect
    public void onConnect(SocketIOClient client) {
        String clientId = client.getSessionId().toString();
        log.info("Client connected: {}", clientId);
        
        // 연결 시 기본 통계 전송
        sendInitialStats(client);
    }
    
    @OnDisconnect
    public void onDisconnect(SocketIOClient client) {
        String clientId = client.getSessionId().toString();
        String room = clientRooms.remove(client.getSessionId());
        
        if (room != null) {
            // 룸에서 나가기
            client.leaveRoom(room);
            
            // 다른 사용자들에게 viewer 감소 알림
            if (room.startsWith("project_")) {
                String projectId = room.substring(8);
                webSocketService.notifyViewerLeft(projectId, "project");
            } else if (room.startsWith("freelancer_")) {
                String freelancerId = room.substring(11);
                webSocketService.notifyViewerLeft(freelancerId, "freelancer");
            }
        }
        
        log.info("Client disconnected: {}", clientId);
    }
    
    @OnEvent("join_project")
    public void onJoinProject(SocketIOClient client, JoinRoomRequest request) {
        String projectId = request.getProjectId();
        String room = "project_" + projectId;
        
        // 이전 룸에서 나가기
        leaveCurrentRoom(client);
        
        // 새 룸에 참가
        client.joinRoom(room);
        clientRooms.put(client.getSessionId(), room);
        
        log.info("Client {} joined project room: {}", client.getSessionId(), projectId);
        
        // 현재 통계 전송
        webSocketService.sendProjectStats(client, projectId);
        
        // 다른 사용자들에게 viewer 증가 알림
        webSocketService.notifyViewerJoined(projectId, "project");
    }
    
    @OnEvent("leave_project")
    public void onLeaveProject(SocketIOClient client, JoinRoomRequest request) {
        String projectId = request.getProjectId();
        String room = "project_" + projectId;
        
        client.leaveRoom(room);
        clientRooms.remove(client.getSessionId());
        
        log.info("Client {} left project room: {}", client.getSessionId(), projectId);
        
        // 다른 사용자들에게 viewer 감소 알림
        webSocketService.notifyViewerLeft(projectId, "project");
    }
    
    @OnEvent("join_freelancer")
    public void onJoinFreelancer(SocketIOClient client, JoinRoomRequest request) {
        String freelancerId = request.getFreelancerId();
        String room = "freelancer_" + freelancerId;
        
        // 이전 룸에서 나가기
        leaveCurrentRoom(client);
        
        // 새 룸에 참가
        client.joinRoom(room);
        clientRooms.put(client.getSessionId(), room);
        
        log.info("Client {} joined freelancer room: {}", client.getSessionId(), freelancerId);
        
        // 현재 통계 전송
        webSocketService.sendFreelancerStats(client, freelancerId);
        
        // 다른 사용자들에게 viewer 증가 알림
        webSocketService.notifyViewerJoined(freelancerId, "freelancer");
    }
    
    @OnEvent("leave_freelancer")
    public void onLeaveFreelancer(SocketIOClient client, JoinRoomRequest request) {
        String freelancerId = request.getFreelancerId();
        String room = "freelancer_" + freelancerId;
        
        client.leaveRoom(room);
        clientRooms.remove(client.getSessionId());
        
        log.info("Client {} left freelancer room: {}", client.getSessionId(), freelancerId);
        
        // 다른 사용자들에게 viewer 감소 알림
        webSocketService.notifyViewerLeft(freelancerId, "freelancer");
    }
    
    private void leaveCurrentRoom(SocketIOClient client) {
        String currentRoom = clientRooms.get(client.getSessionId());
        if (currentRoom != null) {
            client.leaveRoom(currentRoom);
            
            // 이전 룸의 viewer 감소 알림
            if (currentRoom.startsWith("project_")) {
                String projectId = currentRoom.substring(8);
                webSocketService.notifyViewerLeft(projectId, "project");
            } else if (currentRoom.startsWith("freelancer_")) {
                String freelancerId = currentRoom.substring(11);
                webSocketService.notifyViewerLeft(freelancerId, "freelancer");
            }
        }
    }
    
    private void sendInitialStats(SocketIOClient client) {
        RealtimeUpdate update = new RealtimeUpdate();
        update.setType("stats");
        Map<String, Object> data = new HashMap<>();
        data.put("connected", true);
        data.put("timestamp", System.currentTimeMillis());
        update.setData(data);
        
        client.sendEvent("realtime_update", update);
    }
}