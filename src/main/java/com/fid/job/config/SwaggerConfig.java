package com.fid.job.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.Components;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;

/**
 * Swagger/OpenAPI 3.0 설정
 * SpringDoc OpenAPI를 사용한 API 문서화 설정
 */
@Configuration
public class SwaggerConfig {
    
    private static final String SECURITY_SCHEME_NAME = "bearerAuth";
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(apiInfo())
                .servers(Arrays.asList(
                    new Server().url("http://localhost:8080").description("Local Development Server"),
                    new Server().url("http://192.168.0.109:8080").description("Synology Production Server")
                ))
                .components(new Components()
                    .addSecuritySchemes(SECURITY_SCHEME_NAME,
                        new SecurityScheme()
                            .type(SecurityScheme.Type.HTTP)
                            .scheme("bearer")
                            .bearerFormat("JWT")
                            .description("JWT 토큰을 입력하세요 (Bearer 접두사 제외)")
                    )
                )
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME));
    }
    
    private Info apiInfo() {
        return new Info()
                .title("Job Platform API")
                .description("Spring Boot 기반 프리랜서 마켓플레이스 및 전자결재 시스템 API")
                .version("1.0.0")
                .contact(new Contact()
                    .name("Job Platform Team")
                    .email("doshyun@gmail.com")
                    .url("https://github.com/joopok/ai_springboot")
                )
                .license(new License()
                    .name("MIT License")
                    .url("https://opensource.org/licenses/MIT")
                );
    }
}