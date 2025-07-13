package com.fid.job.config;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

@Configuration
public class JacksonConfig {

    @Bean
    public ObjectMapper objectMapper(Jackson2ObjectMapperBuilder builder) {
        ObjectMapper objectMapper = builder.build();
        
        // Pretty print JSON
        objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        
        // Escape non-ASCII characters
        objectMapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
        
        // Handle invalid UTF-8 characters
        objectMapper.getFactory().configure(JsonGenerator.Feature.STRICT_DUPLICATE_DETECTION, true);
        
        return objectMapper;
    }
}