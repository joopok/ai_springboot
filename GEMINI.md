# GEMINI.md

This file provides comprehensive guidance for the Gemini CLI when working with the PM7 Spring Boot project.

## 🚨 CRITICAL PROJECT-WIDE RULES

1.  **Java 8 Compatibility**: This project **MUST** remain compatible with **Java 8**.
    -   **NEVER USE**: `List.of()`, `Set.of()`, `Map.of()`, `stream.toList()`, `String.isBlank()`, `String.strip()`.
    -   **ALWAYS USE**: `Arrays.asList()`, `stream.collect(Collectors.toList())`, `StringUtils.isBlank()`.
2.  **Security Configuration**: The `SecurityConfig.java` file is currently configured to `anyRequest().permitAll()`. This is for development convenience ONLY and **MUST** be changed for production.
3.  **Database Schema**: The primary database is `jobtracker`. Be aware of potential inconsistencies between the DB schema and MyBatis mappers (`UserMapper.xml`), especially regarding column names (`id` vs `user_id`, `name` vs `name`, `password` vs `password_hash`).

## Project Overview

-   **Framework**: Spring Boot 2.7.0
-   **Build Tool**: Gradle
-   **Database**: MariaDB (via MyBatis)
-   **Authentication**: JWT
-   **API Docs**: Swagger UI at `/swagger-ui.html`
-   **Java Version**: 8

## Essential Commands

### Server Management
```bash
# Start server in background (port 8080)
nohup ./gradlew bootRun > application.log 2>&1 &

# Start server in foreground
./gradlew bootRun

# Kill and restart server
lsof -ti :8080 | xargs kill -9 && ./gradlew bootRun

# View real-time logs
tail -f application.log
```

### Build Commands
```bash
# Clean and build
./gradlew clean build

# Build skipping tests
./gradlew build -x test
```

## Database Configuration

-   **Host**: `192.168.0.109:3306`
-   **Database Name**: `jobtracker` (may sometimes be `pms7` in older configs, always verify in `application.yml`)
-   **Username**: `root`
-   **SQL Logging**: To debug queries, enable TRACE logging for `org.apache.ibatis` and `com.example.pm7.mapper` in `application.yml`.

## Architecture & Key Files

-   **Configuration**: `src/main/resources/application.yml`
-   **MyBatis Mappers**: `src/main/resources/mapper/*.xml`
-   **Dependencies**: `build.gradle`
-   **Package Structure**:
    -   `com.example.pm7.config`: Security, JWT, Web configurations
    -   `com.example.pm7.controller`: REST API endpoints
    -   `com.example.pm7.service`: Business logic
    -   `com.example.pm7.mapper`: MyBatis interfaces
    -   `com.example.pm7.dto`: Data Transfer Objects

## Frontend Integration (Next.js)

-   **Project Location**: `/Users/doseunghyeon/developerApp/react/aiproject02`
-   **Frontend Port**: `3000`
-   **Backend Port**: `8080`
-   **Proxy**: The Next.js app proxies all `/api/*` requests to `http://localhost:8080/api/*`.
-   **CORS**: `WebConfig.java` is configured to allow requests from `http://localhost:3000`.

## Development Workflow & Best Practices

1.  **Analyze**: Before coding, review existing interfaces and patterns.
2.  **Follow Sequence**: Define changes in `Controller` -> `Service` -> `Mapper` -> `DB`.
3.  **Verify Java 8**: Before committing, run `./gradlew compileJava` to ensure there are no Java 8 compatibility issues.
4.  **Use Patterns**: Adhere to the established REST Controller, Service, and MyBatis patterns found in the codebase.
5.  **Validate Inputs**: Use `@Valid` annotations in controllers for all incoming requests.

*Last Updated: 2024-07-03 (Merged from CLAUDE.md)*