package com.fid.job.config;

import com.corundumstudio.socketio.Configuration;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.annotation.SpringAnnotationScanner;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
@org.springframework.context.annotation.Configuration
public class WebSocketConfig {

    @Value("${socket.io.host:0.0.0.0}")
    private String host;

    @Value("${socket.io.port:9092}")
    private int port;

    @Bean
    public SocketIOServer socketIOServer() {
        Configuration config = new Configuration();
        config.setHostname(host);
        config.setPort(port);
        
        // CORS 설정
        config.setOrigin("http://localhost:3000");
        
        // 인증 설정
        config.setAuthorizationListener(data -> {
            String token = data.getSingleUrlParam("token");
            // JWT 토큰 검증 로직 추가
            return true; // 임시로 모든 연결 허용
        });
        
        // 기타 설정
        config.setMaxFramePayloadLength(1024 * 1024);
        config.setMaxHttpContentLength(1024 * 1024);
        config.setPingTimeout(60000);
        config.setPingInterval(25000);
        config.setUpgradeTimeout(10000);
        
        return new SocketIOServer(config);
    }

    @Bean
    public SpringAnnotationScanner springAnnotationScanner(SocketIOServer socketServer) {
        return new SpringAnnotationScanner(socketServer);
    }
}