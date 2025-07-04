package com.fid.job.config;

import com.fid.job.interceptor.LoginCheckInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.lang.NonNull;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private LoginCheckInterceptor loginCheckInterceptor;

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        registry.addInterceptor(loginCheckInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                    "/api/login", 
                    "/api/register", 
                    "/swagger-ui/**",
                    "/api/test",
                    "/api/db-test",
                    "/api/insert-test-data",
                    "/api/users"  // 테스트를 위해 users API도 인증 제외
                );
    }
} 