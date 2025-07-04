package com.fid.job.service;

import com.fid.job.dto.CategoryDTO;
import java.util.List;

public interface CategoryService {
    
    List<CategoryDTO> getAllCategories();
    
    CategoryDTO getCategoryById(Long id);
}