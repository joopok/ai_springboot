package com.fid.job;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
public class GeneratePasswordHashTest {

    @Test
    public void generateTestUserPasswords() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String[] passwords = {
            "admin123!",
            "test123!",
            "free123!",
            "client123!"
        };
        
        System.out.println("=== BCrypt Password Hash Generation ===");
        for (String password : passwords) {
            String hash = encoder.encode(password);
            System.out.println("Password: " + password);
            System.out.println("Hash: " + hash);
            System.out.println("Verification: " + encoder.matches(password, hash));
            System.out.println("--------------------------------------");
        }
    }
}