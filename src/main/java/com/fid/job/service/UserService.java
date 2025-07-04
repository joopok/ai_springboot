package com.fid.job.service;

import com.fid.job.model.User;
import java.util.List;

public interface UserService {
    User authenticate(String username, String password);
    User findByUsername(String username);
    void register(User user);
    List<User> findAll();
    User findById(Long id);
    void update(User user);
    void delete(Long id);
    void logout(String username, String jwtToken);
} 