package com.example.pm7.service;

import com.example.pm7.model.User;
import java.util.List;

public interface UserService {
    User authenticate(String username, String password);
    User findByUsername(String username);
    void register(User user);
    List<User> findAll();
    User findById(Long id);
    void update(User user);
    void delete(Long id);
} 