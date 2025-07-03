package com.example.pm7.mapper;

import com.example.pm7.dto.CategoryDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CategoryMapper {
    List<CategoryDTO> findAllCategories();
    CategoryDTO findCategoryById(Long id);
}