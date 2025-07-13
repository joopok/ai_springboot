package com.fid.job.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String[] passwords = {
            "admin123!",
            "test123!", 
            "free123!",
            "client123!"
        };
        
        System.out.println("=== BCrypt Password Hash Generation ===");
        System.out.println("UPDATE users SET password_hash = CASE");
        
        for (String password : passwords) {
            String hash = encoder.encode(password);
            System.out.println("-- Password: " + password);
            System.out.println("-- Hash: " + hash);
            
            // Generate SQL for each user
            String username = "";
            if (password.equals("admin123!")) username = "admin";
            else if (password.equals("test123!")) username = "test";
            else if (password.equals("free123!")) username = "freelancer1";
            else if (password.equals("client123!")) username = "client1";
            
            System.out.println("WHEN username = '" + username + "' THEN '" + hash + "'");
        }
        
        System.out.println("END WHERE username IN ('admin', 'test', 'freelancer1', 'client1');");
    }
}