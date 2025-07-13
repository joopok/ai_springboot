package com.jobkorea.config;

import com.corundumstudio.socketio.SocketIOServer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class WebSocketServerConfig {

    private final SocketIOServer server;

    @Bean
    public CommandLineRunner socketIOServerRunner() {
        return args -> {
            try {
                server.start();
                log.info("Socket.IO server started on port: {}", server.getConfiguration().getPort());
                
                // JVM shutdown hook
                Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                    server.stop();
                    log.info("Socket.IO server stopped");
                }));
                
            } catch (Exception e) {
                log.error("Failed to start Socket.IO server", e);
            }
        };
    }
}