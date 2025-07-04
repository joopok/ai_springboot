package com.fid.job.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/encode")
    public Map<String, String> encodePassword(@RequestBody Map<String, String> request) {
        String rawPassword = request.get("password");
        String encodedPassword = passwordEncoder.encode(rawPassword);
        
        Map<String, String> response = new HashMap<>();
        response.put("rawPassword", rawPassword);
        response.put("encodedPassword", encodedPassword);
        
        return response;
    }

    @PostMapping("/verify")
    public Map<String, Object> verifyPassword(@RequestBody Map<String, String> request) {
        String rawPassword = request.get("rawPassword");
        String encodedPassword = request.get("encodedPassword");
        
        boolean matches = passwordEncoder.matches(rawPassword, encodedPassword);
        
        Map<String, Object> response = new HashMap<>();
        response.put("rawPassword", rawPassword);
        response.put("encodedPassword", encodedPassword);
        response.put("matches", matches);
        
        return response;
    }
}