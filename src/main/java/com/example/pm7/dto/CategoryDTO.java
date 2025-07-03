package com.example.pm7.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO {
    private Long id;
    private String name;
    private String nameEn;
    private String slug;
    private String description;
    private String icon;
    private String imageUrl;
    private Integer count;
    private Integer onsiteCount;
    private Integer remoteCount;
    private Boolean isFeatured;
    private String colorPrimary;
    private String colorSecondary;
}