package com.fid.job.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class PasswordTestController {

    @GetMapping("/password-hash")
    public ResponseEntity<Map<String, String>> generatePasswordHash(@RequestParam String password) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        Map<String, String> response = new HashMap<>();
        response.put("password", password);
        response.put("hash", encoder.encode(password));
        response.put("note", "Use this hash to update the database");
        
        // Test with the problematic hash
        String problematicHash = "$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW";
        boolean matchesProblematic = encoder.matches("password123", problematicHash);
        response.put("problematicHashMatches", String.valueOf(matchesProblematic));
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/verify-password")
    public ResponseEntity<Map<String, Object>> verifyPassword(@RequestBody Map<String, String> request) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String password = request.get("password");
        String hash = request.get("hash");
        
        Map<String, Object> response = new HashMap<>();
        response.put("password", password);
        response.put("hash", hash);
        response.put("matches", encoder.matches(password, hash));
        
        return ResponseEntity.ok(response);
    }
}