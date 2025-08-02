package com.fid.job.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.and())
            .csrf(csrf -> csrf.disable())
            .authorizeRequests(auth -> auth
                .antMatchers("/api/**").permitAll()  // 개발 중에는 모든 API 접근 허용
                .antMatchers("/swagger-ui/**").permitAll()  // Swagger UI 접근 허용
                .antMatchers("/v3/api-docs/**").permitAll()  // OpenAPI 문서 접근 허용
                .antMatchers("/swagger-ui.html").permitAll()  // Swagger UI HTML 허용
                .antMatchers("/swagger-resources/**").permitAll()  // Swagger 리소스 허용
                .antMatchers("/webjars/**").permitAll()  // Swagger UI 웹자원 허용
                .anyRequest().permitAll() // 모든 요청 허용
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .formLogin(form -> form.disable())
            .httpBasic(basic -> basic.disable());

        return http.build();
    }
} 