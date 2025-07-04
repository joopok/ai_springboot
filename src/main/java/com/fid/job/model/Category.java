package com.fid.job.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Category {
    private Long id;
    private String name;
    private String nameEn;
    private String slug;
    private String description;
    private String icon;
    private String imageUrl;
    private String parentId;  // 상위 카테고리 ID (NULL 가능)
    private Integer displayOrder;  // 표시 순서
    private Boolean isActive;  // 활성/비활성 상태
    private Boolean isFeatured;  // 추천 카테고리 여부
    private String colorPrimary;
    private String colorSecondary;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}