package com.fid.job.mapper;

import com.fid.job.dto.CategoryDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CategoryMapper {
    List<CategoryDTO> findAllCategories();
    CategoryDTO findCategoryById(Long id);
}