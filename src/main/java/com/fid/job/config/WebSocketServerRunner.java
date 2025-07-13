package com.fid.job.config;

import com.corundumstudio.socketio.SocketIOServer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketServerRunner implements CommandLineRunner {

    private final SocketIOServer server;

    @Override
    public void run(String... args) throws Exception {
        log.info("Starting Socket.IO server on port {}", server.getConfiguration().getPort());
        server.start();
        log.info("Socket.IO server started successfully");
        
        // JVM 종료 시 서버 정리
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            log.info("Stopping Socket.IO server...");
            server.stop();
            log.info("Socket.IO server stopped");
        }));
    }
}