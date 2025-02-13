package com.example.pm7;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@SpringBootApplication
@EnableCaching
@MapperScan("com.example.pm7.mapper")
@EnableAspectJAutoProxy
public class Pm7Application {
    public static void main(String[] args) {
        SpringApplication.run(Pm7Application.class, args);
    }
} 