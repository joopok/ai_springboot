package com.fid.job.service;

import com.fid.job.dto.CategoryDTO;
import com.fid.job.mapper.CategoryMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CategoryServiceImpl implements CategoryService {
    
    private final CategoryMapper categoryMapper;
    
    @Override
    public List<CategoryDTO> getAllCategories() {
        log.info("Fetching all categories");
        return categoryMapper.findAllCategories();
    }
    
    @Override
    public CategoryDTO getCategoryById(Long id) {
        log.info("Fetching category with id: {}", id);
        return categoryMapper.findCategoryById(id);
    }
}