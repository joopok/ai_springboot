# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PM7 is a Spring Boot 2.7.0 freelancer marketplace platform connecting freelancers with projects. It uses MyBatis for database operations with MariaDB, JWT authentication, and provides RESTful APIs for managing freelancers, categories, projects, and user authentication.

## Essential Commands

### Running the Application
```bash
# Start server on ports 8080 and 8081 (foreground)
./gradlew bootRun

# Start server with background logging
nohup ./gradlew bootRun > application.log 2>&1 &

# Kill existing server before restart
lsof -ti :8080 :8081 | xargs kill -9 && ./gradlew bootRun
```

### Building and Testing
```bash
./gradlew clean build         # Full build with tests
./gradlew build -x test       # Build without tests
./gradlew compileJava         # Compile only (Java 8 compatibility check)
./gradlew test                # Run all tests
```

### Database Access
```bash
# Connect to MariaDB
mysql -h 192.168.0.109 -u root -p'~Asy10131227' jobtracker

# Check database connectivity
mysql -h 192.168.0.109 -u root -p'~Asy10131227' jobtracker -e "SELECT 1"
```

## Architecture Overview

### Core Technologies
- **Framework**: Spring Boot 2.7.0
- **Java Version**: Java 8 (CRITICAL - see compatibility rules below)
- **Build Tool**: Gradle
- **Database**: MariaDB 10.x with MyBatis ORM
- **Authentication**: JWT tokens (24-hour expiration)
- **API Documentation**: SpringDoc OpenAPI (Swagger UI at `/swagger-ui.html`)
- **Ports**: 8080 (primary), 8081 (secondary via AdditionalPortConfig)

### High-Level Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Next.js UI    │────▶│  Spring Boot    │────▶│    MariaDB      │
│  (Port 3000)    │◀────│  (Port 8080)    │◀────│  (jobtracker)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                        │
         │                       ├── Controllers         ├── users
         │                       ├── Services            ├── freelancers
         └── JWT Auth           ├── Mappers (MyBatis)  ├── categories
                                └── DTOs                └── projects
```

### Package Structure and Responsibilities

- **controller/** - REST endpoints, request validation, response formatting
- **service/** - Business logic, transaction management, data transformation
- **mapper/** - MyBatis interfaces for database operations
- **model/** - Domain entities matching database tables
- **dto/** - Data transfer objects for API requests/responses
- **config/** - Spring configuration (Security, JWT, Web, Ports)
- **interceptor/** - Request interceptors for authentication
- **exception/** - Global exception handling

### Database Schema Overview

The database follows a user-centric model where freelancers and companies are extensions of the users table:

1. **users** - Core authentication and profile data
2. **freelancers** - Extended profile for freelancer users (1:1 with users)
3. **categories** - Hierarchical categorization system
4. **projects** - Job postings and project listings
5. **companies** - Company profiles (1:1 with users)

### API Endpoint Structure

- `/api/auth/*` - Authentication (login, logout, session)
- `/api/freelancers/*` - Freelancer profiles and search
- `/api/categories/*` - Category management
- `/api/projects/*` - Project management (in development)
- `/swagger-ui.html` - API documentation

## Critical Java 8 Compatibility Rules

### ❌ NEVER Use (Java 9+)
```java
List.of(), Set.of(), Map.of()     // Use Arrays.asList() or Collections
stream.toList()                    // Use .collect(Collectors.toList())
String.isBlank(), String.strip()   // Use StringUtils.isBlank() or .trim()
```

### ✅ ALWAYS Use (Java 8)
```java
Arrays.asList("item1", "item2")
stream.collect(Collectors.toList())
StringUtils.isBlank(str) or str.trim().isEmpty()
```

### Required Imports
```java
import java.util.stream.Collectors;  // For stream operations
import java.util.Arrays;             // For Arrays.asList()
import org.springframework.util.StringUtils;  // For string utilities
```

## Database Configuration and MCP Integration

### Connection Details
- **Host**: 192.168.0.109
- **Port**: 3306
- **Database**: jobtracker
- **Username**: root
- **MCP Server**: MariaDB MCP server configured in mcp-settings.json

### Common Database Operations

```sql
-- Check freelancer skills (JSON column)
SELECT * FROM freelancers 
WHERE JSON_SEARCH(skills, 'one', 'React') IS NOT NULL;

-- Update user logout time
UPDATE users SET last_login = CURRENT_TIMESTAMP 
WHERE username = ?;
```

## Frontend Integration

### Next.js Frontend
- **Location**: `/Users/doseunghyeon/developerApp/react/aiproject02`
- **Port**: 3000
- **Authentication**: JWT stored in localStorage as `auth_token`

### CORS Configuration
Backend allows requests from `http://localhost:3000` with credentials.

## Development Patterns

### Service Implementation Pattern
```java
@Service
@RequiredArgsConstructor
public class FreelancerServiceImpl implements FreelancerService {
    private final FreelancerMapper freelancerMapper;
    
    @Override
    @Transactional
    public List<FreelancerDto> searchBySkills(List<String> skills) {
        // Java 8 compatible implementation
        List<Freelancer> freelancers = freelancerMapper.findBySkills(skills);
        return freelancers.stream()
            .map(this::convertToDto)
            .collect(Collectors.toList());  // NOT .toList()!
    }
}
```

### MyBatis Mapper Pattern
```xml
<select id="findBySkills" resultMap="freelancerResultMap">
    SELECT * FROM freelancers f
    WHERE 
    <foreach collection="skills" item="skill" separator=" OR ">
        JSON_SEARCH(f.skills, 'one', #{skill}) IS NOT NULL
    </foreach>
</select>
```

## Recent Architectural Decisions

1. **JSON Skills Storage**: Skills stored as JSON arrays in MariaDB for flexibility
2. **Dual Port Support**: Application accessible on both 8080 and 8081
3. **Token Blacklisting**: In-memory JWT blacklist for secure logout
4. **Advanced Search**: Complex filtering using MyBatis dynamic SQL

## Common Troubleshooting

### Port Already in Use
```bash
lsof -ti :8080 :8081 | xargs kill -9
```

### Database Connection Issues
- Verify database name is `jobtracker` (not `pms7`)
- Check MyBatis mapper column names match actual DB schema
- Enable SQL logging for debugging:
  ```yaml
  logging.level.com.example.pm7.mapper: TRACE
  ```

### Java Compilation Errors
```bash
# Check for Java 9+ APIs
grep -r "List\.of\|\.toList()\|\.isBlank()" src/

# Verify compilation
./gradlew compileJava
```

## Project-Specific Keywords and Paths

When working with **서버, 자바, SQL, 쿼리, DTO, DAO, Lombok, MCP**:
- Work in: `/Users/doseunghyeon/developerApp/JAVA/project_ai01`

When working with **DDL, DML, DCL, database**:
- Reference: `/Users/doseunghyeon/developerApp/JAVA/project_ai01/database`
- Database name: `jobtracker`

*Last Updated: 2025-01-03*
*Version: 3.1 - Enhanced with database schema alignment*