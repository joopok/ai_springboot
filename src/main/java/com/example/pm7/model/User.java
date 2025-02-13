package com.example.pm7.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private String name;
    private Long id;
    private String username;
    private String password;
    private String email;
    private String role;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 