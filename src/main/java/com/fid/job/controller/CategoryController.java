package com.fid.job.controller;

import com.fid.job.dto.CategoryDTO;
import com.fid.job.dto.ApiResponse;
import com.fid.job.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getCategories() {
        try {
            List<CategoryDTO> categories = categoryService.getAllCategories();
            return ResponseEntity.ok(ApiResponse.success(categories, "Categories fetched successfully"));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(
                ApiResponse.<List<CategoryDTO>>error("Failed to fetch categories: " + e.getMessage())
            );
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryDTO>> getCategoryById(@PathVariable Long id) {
        try {
            CategoryDTO category = categoryService.getCategoryById(id);
            if (category != null) {
                return ResponseEntity.ok(ApiResponse.success(category, "Category fetched successfully"));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(
                ApiResponse.<CategoryDTO>error("Failed to fetch category: " + e.getMessage())
            );
        }
    }
}