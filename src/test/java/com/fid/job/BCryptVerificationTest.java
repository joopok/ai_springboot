package com.fid.job;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class BCryptVerificationTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // 테스트할 해시들
        String[] hashes = {
            "$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",
            "$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG",
            "$2a$10$ty3K73EU8yG5GoLfBz4x..yd/tlM4tLdi.OcJruMAg6A7qqQMJ94e"
        };
        
        String password = "password123";
        
        System.out.println("=== BCrypt Password Verification Test ===");
        System.out.println("Testing password: " + password);
        System.out.println();
        
        for (String hash : hashes) {
            boolean matches = encoder.matches(password, hash);
            System.out.println("Hash: " + hash);
            System.out.println("Matches: " + matches);
            System.out.println("---");
        }
        
        // 새로운 해시 생성
        System.out.println("\n=== Generating new hash for password123 ===");
        for (int i = 0; i < 3; i++) {
            String newHash = encoder.encode(password);
            System.out.println("New hash " + (i+1) + ": " + newHash);
            System.out.println("Verification: " + encoder.matches(password, newHash));
        }
    }
}