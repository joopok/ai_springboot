package com.fid.job.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // admin 계정용 비밀번호 해시 생성
        String password = "admin";
        String hash = encoder.encode(password);
        
        System.out.println("=== BCrypt Password Hash Generator ===");
        System.out.println("Password: " + password);
        System.out.println("Generated Hash: " + hash);
        System.out.println("Verification: " + encoder.matches(password, hash));
        
        // SQL 문 생성
        System.out.println("\n=== SQL Update Statement ===");
        System.out.println("UPDATE users SET password_hash = '" + hash + "' WHERE username = 'admin';");
    }
}