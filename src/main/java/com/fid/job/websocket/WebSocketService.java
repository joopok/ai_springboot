package com.fid.job.websocket;

import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.fid.job.service.ProjectService;
import com.fid.job.service.FreelancerService;
import com.fid.job.websocket.dto.RealtimeStats;
import com.fid.job.websocket.dto.RealtimeUpdate;
import com.fid.job.model.Project;
import com.fid.job.model.Freelancer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service
@RequiredArgsConstructor
public class WebSocketService {

    private final SocketIOServer server;
    private final ProjectService projectService;
    private final FreelancerService freelancerService;
    
    // 현재 뷰어 수 추적
    private final Map<String, AtomicInteger> projectViewers = new ConcurrentHashMap<>();
    private final Map<String, AtomicInteger> freelancerViewers = new ConcurrentHashMap<>();
    
    /**
     * 프로젝트 통계 전송
     */
    public void sendProjectStats(SocketIOClient client, String projectId) {
        try {
            Project project = projectService.getProjectById(Long.parseLong(projectId));
            if (project == null) return;
            
            RealtimeStats stats = new RealtimeStats();
            stats.setViewCount(project.getViewCount());
            stats.setCurrentViewers(getProjectViewerCount(projectId));
            stats.setApplicationsCount(project.getApplicationsCount());
            stats.setBookmarkCount(project.getBookmarkCount());
            
            RealtimeUpdate update = new RealtimeUpdate();
            update.setType("stats");
            update.setProjectId(projectId);
            update.setData(stats);
            
            client.sendEvent("stats_update", update);
            
        } catch (Exception e) {
            log.error("Error sending project stats", e);
        }
    }
    
    /**
     * 프리랜서 통계 전송
     */
    public void sendFreelancerStats(SocketIOClient client, String freelancerId) {
        try {
            Freelancer freelancer = freelancerService.getFreelancerById(Long.parseLong(freelancerId));
            if (freelancer == null) return;
            
            RealtimeStats stats = new RealtimeStats();
            stats.setViewCount(freelancer.getViewCount());
            stats.setCurrentViewers(getCurrentViewerCount("freelancer_" + freelancerId));
            stats.setApplicationsCount(freelancer.getProjectCount());
            stats.setBookmarkCount(0); // 프리랜서 북마크 수는 별도 조회 필요
            stats.setInquiryCount(0); // 프리랜서 문의 수는 별도 조회 필요
            
            RealtimeUpdate update = new RealtimeUpdate();
            update.setType("stats");
            update.setFreelancerId(freelancerId);
            update.setData(stats);
            
            client.sendEvent("stats_update", update);
            
        } catch (Exception e) {
            log.error("Error sending freelancer stats", e);
        }
    }
    
    /**
     * 뷰어 참가 알림
     */
    public void notifyViewerJoined(String id, String type) {
        AtomicInteger viewers;
        String room;
        
        if ("project".equals(type)) {
            viewers = projectViewers.computeIfAbsent(id, k -> new AtomicInteger(0));
            room = "project_" + id;
        } else {
            viewers = freelancerViewers.computeIfAbsent(id, k -> new AtomicInteger(0));
            room = "freelancer_" + id;
        }
        
        int currentViewers = viewers.incrementAndGet();
        
        RealtimeUpdate update = new RealtimeUpdate();
        update.setType("viewer_join");
        if ("project".equals(type)) {
            update.setProjectId(id);
        } else {
            update.setFreelancerId(id);
        }
        
        RealtimeStats stats = new RealtimeStats();
        stats.setCurrentViewers(currentViewers);
        update.setData(stats);
        
        // 룸의 모든 클라이언트에게 브로드캐스트
        server.getRoomOperations(room).sendEvent("realtime_update", update);
    }
    
    /**
     * 뷰어 퇴장 알림
     */
    public void notifyViewerLeft(String id, String type) {
        AtomicInteger viewers;
        String room;
        
        if ("project".equals(type)) {
            viewers = projectViewers.get(id);
            room = "project_" + id;
        } else {
            viewers = freelancerViewers.get(id);
            room = "freelancer_" + id;
        }
        
        if (viewers == null) return;
        
        int currentViewers = Math.max(0, viewers.decrementAndGet());
        
        RealtimeUpdate update = new RealtimeUpdate();
        update.setType("viewer_leave");
        if ("project".equals(type)) {
            update.setProjectId(id);
        } else {
            update.setFreelancerId(id);
        }
        
        RealtimeStats stats = new RealtimeStats();
        stats.setCurrentViewers(currentViewers);
        update.setData(stats);
        
        // 룸의 모든 클라이언트에게 브로드캐스트
        server.getRoomOperations(room).sendEvent("realtime_update", update);
    }
    
    /**
     * 프로젝트 지원 알림
     */
    public void notifyProjectApplication(String projectId) {
        try {
            Project project = projectService.getProjectById(Long.parseLong(projectId));
            if (project == null) return;
            
            RealtimeUpdate update = new RealtimeUpdate();
            update.setType("application");
            update.setProjectId(projectId);
            
            RealtimeStats stats = new RealtimeStats();
            stats.setApplicationsCount(project.getApplicationsCount());
            update.setData(stats);
            
            String room = "project_" + projectId;
            server.getRoomOperations(room).sendEvent("realtime_update", update);
            
        } catch (Exception e) {
            log.error("Error notifying project application", e);
        }
    }
    
    /**
     * 북마크 토글 알림
     */
    public void notifyBookmarkToggle(String projectId, boolean bookmarked) {
        try {
            Project project = projectService.getProjectById(Long.parseLong(projectId));
            if (project == null) return;
            
            RealtimeUpdate update = new RealtimeUpdate();
            update.setType("bookmark");
            update.setProjectId(projectId);
            
            RealtimeStats stats = new RealtimeStats();
            stats.setBookmarkCount(project.getBookmarkCount());
            update.setData(stats);
            
            String room = "project_" + projectId;
            server.getRoomOperations(room).sendEvent("realtime_update", update);
            
        } catch (Exception e) {
            log.error("Error notifying bookmark toggle", e);
        }
    }
    
    /**
     * 문의 알림
     */
    public void notifyInquiry(String id, String type) {
        RealtimeUpdate update = new RealtimeUpdate();
        update.setType("inquiry");
        
        String room;
        if ("project".equals(type)) {
            update.setProjectId(id);
            room = "project_" + id;
        } else {
            update.setFreelancerId(id);
            room = "freelancer_" + id;
        }
        
        server.getRoomOperations(room).sendEvent("realtime_update", update);
    }
    
    private int getCurrentViewerCount(String room) {
        if (room.startsWith("project_")) {
            String projectId = room.substring(8);
            return getProjectViewerCount(projectId);
        } else if (room.startsWith("freelancer_")) {
            String freelancerId = room.substring(11);
            return getFreelancerViewerCount(freelancerId);
        }
        return 0;
    }
    
    private int getProjectViewerCount(String projectId) {
        AtomicInteger viewers = projectViewers.get(projectId);
        return viewers != null ? viewers.get() : 0;
    }
    
    private int getFreelancerViewerCount(String freelancerId) {
        AtomicInteger viewers = freelancerViewers.get(freelancerId);
        return viewers != null ? viewers.get() : 0;
    }
}