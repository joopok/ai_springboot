# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Spring Boot 2.7.0 backend application (PM7) using MyBatis for database operations with MariaDB. The project includes JWT authentication, RESTful APIs for notices and events, and uses Gradle as the build tool.

## Essential Commands

### Running the Application
```bash
# Start server on port 8080 (background)
nohup ./gradlew bootRun > application.log 2>&1 &

# Start server on port 8080 (foreground)
./gradlew bootRun

# Kill existing server before restart
lsof -ti :8080 | xargs kill -9 && ./gradlew bootRun
```

### Building the Project
```bash
./gradlew clean build
./gradlew build -x test    # Skip tests
./gradlew build            # Full build with tests
```

### Server Management
```bash
# Check if server is running
lsof -i :8080

# View real-time logs
tail -f application.log

# Kill server process
lsof -ti :8080 | xargs kill -9
```

## Architecture Overview

### Core Technologies
- **Framework**: Spring Boot 2.7.0
- **Build Tool**: Gradle (migrated from Maven)
- **Database**: MariaDB with MyBatis ORM
- **Authentication**: JWT tokens
- **API Documentation**: SpringDoc OpenAPI (Swagger UI at `/swagger-ui.html`)
- **Java Version**: Java 8

### Package Structure
```
com.example.pm7/
├── config/         # Security, JWT, Web, Cache configurations
├── controller/     # REST API endpoints
├── dto/           # Data transfer objects
├── mapper/        # MyBatis mapper interfaces
├── model/         # Domain entities
├── service/       # Business logic layer
├── aop/           # Aspect-oriented programming (logging)
├── exception/     # Global exception handling
└── interceptor/   # Request interceptors
```

### Key Configuration Files
- `src/main/resources/application.yml` - Main configuration
- `src/main/resources/mapper/*.xml` - MyBatis SQL mappings
- `build.gradle` - Project dependencies and build configuration

### Database Configuration
- **Host**: 192.168.0.109
- **Port**: 3306
- **Database**: jobtracker (was pms7 in earlier configs)
- **Username**: root
- **Connection pool**: HikariCP with 20 max connections
- **Important**: Check DB name in application.yml - may need to switch between `jobtracker` and `pms7`

### API Structure
- `/api/auth/*` - Authentication endpoints (login, logout, refresh)
- `/api/notices/*` - Notice management
- `/api/events/*` - Event management
- `/api/test/*` - Testing endpoints (development only)

### Security Configuration
- JWT-based authentication with 24-hour token expiration
- CORS enabled for all origins (development configuration)
- Login interceptor for protected endpoints
- Security endpoints excluded: `/api/auth/**`, `/swagger-ui/**`, `/api-docs/**`

### Development Notes
- Application runs on port 8080 (configured in application.yml)
- Comprehensive logging configured with DEBUG level for application code
- File uploads supported (max 10MB) with path `/uploads/notice`
- No test files currently exist in the project
- Redis caching is configured but implementation may be pending
- **Port Configuration**: Default port is 8080, but check application.yml as it may revert to 8080

## Frontend Integration (Next.js)

### Connected Next.js Project
- **Location**: `/Users/doseunghyeon/developerApp/react/aiproject02`
- **Framework**: Next.js 14 with TypeScript
- **Port**: 3000
- **Authentication**: JWT-based with localStorage persistence

### API Endpoint Mapping
Backend serves API endpoints that the Next.js frontend consumes:

| Frontend Route | Backend Endpoint | Method | Description |
|---------------|------------------|---------|-------------|
| `/api/auth/login` | `/api/auth/login` | POST | User authentication |
| `/api/auth/session` | `/api/auth/session-info` | GET | Session validation |
| `/api/auth/logout` | `/api/auth/logout` | POST | User logout |

### Authentication Flow Integration
```json
// Frontend Login Request (Next.js)
{
  "username": "user_id",  // Note: uses "username" not "username"
  "password": "password"
}

// Backend Response (Spring Boot)
{
  "success": true,
  "data": {
    "name": "User Name",
    "username": "username",
    "username": "user_id",
    "email": "user@example.com",
    "role": "ROLE_USER",
    "access_token": "jwt_token_here",
    "status": "200"
  }
}
```

### CORS Configuration
Backend CORS settings for Next.js frontend:
```java
// WebConfig.java
.allowedOrigins("http://localhost:3000")
.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
.allowCredentials(true)
```

### JWT Token Configuration
- **Expiration**: 24 hours (matches frontend 30-day localStorage)
- **Algorithm**: HS512
- **Storage**: Frontend stores in localStorage as `auth_token`
- **Validation**: Backend validates via Security filters

### Development Setup for Integration
1. **Start Backend**: `./gradlew bootRun` (runs on port 8080)
2. **Start Frontend**: `npm run dev` (runs on port 3000)
3. **API Proxy**: Next.js proxies `/api/*` to `http://localhost:8080/api/*`

### Required Environment Variables
Frontend `.env` should include:
```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api/
NEXT_PUBLIC_USE_MOCK_API=false
```

### Troubleshooting Integration
- **CORS Issues**: Ensure backend allows `http://localhost:3000` origin
- **Authentication**: Frontend uses `username` field for login
- **Port Conflicts**: Backend on 8080, Frontend on 3000
- **JWT Mismatch**: Check token expiration and format compatibility

### Shared Development Context
Both projects share:
- JWT-based authentication system
- RESTful API architecture
- Database integration (MariaDB)
- Comprehensive logging and error handling
- TypeScript/Java type safety principles

## Critical Database Mapping Issues

### User Table Column Mapping
The project has inconsistencies between DB schema and MyBatis mappings:

**Current DB Schema (users table)**:
- `id` (not user_id)
- `username` - Login ID
- `password` - Plain password field (not password_hash)
- `name` - User's full name (not full_name)
- `email`
- `role`
- `created_at`
- `updated_at`

**Common Mapping Errors**:
1. UserMapper.xml may reference `password_hash` but DB has `password`
2. UserMapper.xml may reference `full_name` but DB has `name`
3. UserMapper.xml may reference `user_id` but DB has `id`

**Fix Required**: Always check UserMapper.xml matches actual DB schema

### SQL Logging Configuration
To see SQL parameters in logs:
```yaml
logging:
  level:
    org.apache.ibatis: TRACE
    com.example.pm7.mapper: TRACE
    com.zaxxer.hikari: WARN  # Disable connection pool logs
```

### Common Troubleshooting

#### Login Failures
1. Check DB connection (jobtracker vs pms7)
2. Verify UserMapper.xml column names match DB
3. Check password encoding (BCrypt vs plain text)
4. Enable SQL parameter logging to debug

#### Port Conflicts
```bash
# Port 8080 in use
lsof -ti :8080 | xargs kill -9

# Port 8080 in use  
lsof -ti :8080 | xargs kill -9
```

#### Swagger UI Access
- URL: http://localhost:8081/swagger-ui.html
- Alternative: http://localhost:8081/swagger-ui/index.html
- API Docs: http://localhost:8081/api-docs

## Development Best Practices (from Cursor Rules)

### Chain-of-Thought Development Pattern
When implementing complex features:
1. **THINK**: What business logic is needed?
2. **PLAN**: Controller → Service → Mapper → DB structure
3. **IMPLEMENT**: Follow existing patterns
4. **VERIFY**: Test endpoints and check logs
5. **OPTIMIZE**: Apply caching, validation, security

### Code Patterns to Follow

#### Service Layer Pattern
```java
@Service
@RequiredArgsConstructor
public class ServiceImpl implements Service {
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    @Transactional
    public void create(Entity entity) {
        // Validation
        validateEntity(entity);
        // Business logic
        processEntity(entity);
        // Persistence
        mapper.insert(entity);
    }
}
```

#### REST Controller Pattern
```java
@RestController
@RequestMapping("/api/resource")
@RequiredArgsConstructor
public class ResourceController {
    private final ResourceService service;
    
    @PostMapping
    public ResponseEntity<ApiResponse<Resource>> create(
            @Valid @RequestBody ResourceRequest request) {
        Resource resource = service.create(request);
        return ResponseEntity.ok(ApiResponse.success(resource));
    }
}
```

#### MyBatis Mapper Pattern
```xml
<select id="findByCondition" resultType="Entity">
    SELECT * FROM entities
    <where>
        <if test="name != null and name != ''">
            AND name LIKE CONCAT('%', #{name}, '%')
        </if>
        <if test="status != null">
            AND status = #{status}
        </if>
    </where>
    ORDER BY created_at DESC
</select>
```

### Security Considerations
- Always validate input with `@Valid`
- Use parameterized queries to prevent SQL injection
- Apply proper authentication/authorization
- Never log sensitive data (passwords, tokens)
- Use BCrypt for password hashing

### Testing Strategy
```bash
# Run specific test class
./gradlew test --tests com.example.pm7.controller.UserControllerTest

# Run all tests with coverage
./gradlew test jacocoTestReport
```

## Project-Specific Notes

### Recent Changes
- Migrated from Maven to Gradle (mvnw files still present)
- Removed unnecessary shell scripts and configuration files
- Updated security configuration for Swagger access
- Fixed CORS issues for frontend integration

### Known Issues
1. **DB Name Inconsistency**: Check if using `jobtracker` or `pms7`
2. **Port Configuration**: May revert from 8081 to 8080 in application.yml
3. **UserMapper Column Names**: Must match actual DB schema
4. **Password Field**: DB uses `password` not `password_hash`

### Quick Fixes
```bash
# Fix port already in use
lsof -ti :8080 :8081 | xargs kill -9

# Clean build after changes
./gradlew clean build

# Check DB connectivity
mysql -h 192.168.0.109 -u root -p'~Asy10131227' jobtracker -e "SELECT 1"
```