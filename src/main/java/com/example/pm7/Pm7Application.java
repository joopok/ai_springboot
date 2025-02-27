package com.example.pm7;

// MyBatis 의존성 추가 필요
// build.gradle 또는 pom.xml에 다음 의존성을 추가하세요:
// implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:2.2.0'
import org.mybatis.spring.annotation.MapperScan;

// Spring Boot 의존성 추가 필요  
// implementation 'org.springframework.boot:spring-boot-starter-web'
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