package com.fid.job;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
public class PasswordEncoderTest {

    @Test
    public void generatePasswordHash() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // Generate hash for admin123
        String rawPassword = "admin123";
        String encodedPassword = encoder.encode(rawPassword);
        
        System.out.println("=== Password Encoding Test ===");
        System.out.println("Raw Password: " + rawPassword);
        System.out.println("BCrypt Hash: " + encodedPassword);
        System.out.println("=============================");
        
        // Verify the hash
        boolean matches = encoder.matches(rawPassword, encodedPassword);
        System.out.println("Verification Result: " + matches);
        
        // Test with the existing hash from database
        String existingHash = "$2a$10$X7qVDh8iBONHh8VQ7xPnKOqPapSZBDH.COVEIMdd4X/FQTfmE4L8K";
        boolean matchesExisting = encoder.matches(rawPassword, existingHash);
        System.out.println("Matches existing hash: " + matchesExisting);
    }
}