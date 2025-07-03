package com.example.pm7.service;

import com.example.pm7.dto.CategoryDTO;
import java.util.List;

public interface CategoryService {
    
    List<CategoryDTO> getAllCategories();
    
    CategoryDTO getCategoryById(Long id);
}