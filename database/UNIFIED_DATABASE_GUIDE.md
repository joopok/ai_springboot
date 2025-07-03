# 📚 PM7 프로젝트 통합 데이터베이스 가이드

## 🎯 개요

PM7 프로젝트의 MariaDB 데이터베이스 설정, 사용자 데이터, 프리랜서 데이터를 통합 관리하는 가이드입니다.

---

## 🏗️ 데이터베이스 기본 설정

### 📋 사전 요구사항

1. **MariaDB 서버 설치**
   ```bash
   # macOS (Homebrew)
   brew install mariadb
   brew services start mariadb
   
   # Ubuntu/Debian
   sudo apt update
   sudo apt install mariadb-server
   sudo systemctl start mariadb
   
   # Windows
   # MariaDB 공식 웹사이트에서 설치 프로그램 다운로드
   ```

2. **Node.js** (MCP 서버용)

### 🔧 데이터베이스 초기 설정

```bash
# MariaDB 보안 설정 (선택사항)
sudo mysql_secure_installation

# MariaDB 접속
mysql -u root -p
```

### 📊 데이터베이스 및 사용자 생성

```sql
-- 데이터베이스 생성
CREATE DATABASE jobtracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 사용자 생성 (보안 권장)
CREATE USER 'pm7_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON jobtracker.* TO 'pm7_user'@'localhost';
FLUSH PRIVILEGES;

-- 데이터베이스 사용
USE jobtracker;
```

### 🔒 환경 변수 설정

`.env.local` 파일 생성:

```env
# MariaDB Database Configuration
MARIADB_HOST=192.168.0.109
MARIADB_PORT=3306
MARIADB_USER=root
MARIADB_PASSWORD=~Asy10131227
MARIADB_DATABASE=jobtracker

# Database Connection Pool Settings
MARIADB_CONNECTION_LIMIT=20
MARIADB_ACQUIRE_TIMEOUT=60000
MARIADB_TIMEOUT=60000
```

---

## 👥 사용자 데이터 구조 (120명)

### 테이블 스키마

```sql
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL COMMENT '로그인ID',
    password VARCHAR(255) NOT NULL COMMENT '비밀번호',
    name VARCHAR(100) NOT NULL COMMENT '사용자명',
    email VARCHAR(100) NOT NULL COMMENT '이메일',
    role VARCHAR(50) NOT NULL COMMENT '역할',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_email (email)
);
```

### 역할별 사용자 분포

| 역할 | 인원 수 | 비율 | ID 범위 | 설명 |
|------|---------|------|---------|------|
| **ADMIN** | 5명 | 4.2% | 1-5 | 시스템 관리자 |
| **PM** | 10명 | 8.3% | 6-15 | 프로젝트 매니저 |
| **DEVELOPER** | 70명 | 58.3% | 16-85 | 개발자 (시니어 20, 미드 35, 주니어 15) |
| **DESIGNER** | 10명 | 8.3% | 86-95 | 디자이너 |
| **QA** | 10명 | 8.3% | 96-105 | 품질 보증 |
| **USER** | 15명 | 12.5% | 106-120 | 일반 사용자 |

### 주요 계정 정보

#### 관리자 계정
- `admin01` / `admin01@pm7.co.kr` - 기본 관리자
- `super_admin` / `superadmin@pm7.co.kr` - 슈퍼 관리자
- `sys_manager` / `sysmanager@pm7.co.kr` - 시스템 매니저

#### 핵심 개발자 계정
- `backend_master` - 백엔드 아키텍처 전문가
- `frontend_guru` - 프론트엔드 전문가
- `fullstack_pro` - 풀스택 개발자
- `mobile_expert` - 모바일 개발 전문가
- `devops_ninja` - DevOps 엔지니어

---

## 💼 프리랜서 데이터 구조 (100명)

### 테이블 스키마

```sql
CREATE TABLE freelancers (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL COMMENT '전문 분야',
    skills JSON COMMENT '기술 스택',
    experience_level ENUM('junior', 'mid', 'senior', 'expert') NOT NULL,
    hourly_rate INT NOT NULL COMMENT '시급 (원)',
    availability ENUM('available', 'busy', 'not_available') DEFAULT 'available',
    work_preference ENUM('remote', 'onsite', 'hybrid') DEFAULT 'remote',
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    portfolio_url VARCHAR(255),
    github_url VARCHAR(255),
    bio TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 전문 분야 분포

- **프론트엔드**: React, Vue, Angular 개발자
- **백엔드**: Node.js, Python, Java, Go 개발자
- **모바일**: Flutter, React Native, iOS, Android
- **DevOps/클라우드**: AWS, Azure, Kubernetes
- **데이터/AI**: 데이터 사이언티스트, ML 엔지니어
- **UI/UX**: 디자이너, 프로덕트 디자이너
- **기타**: 블록체인, 보안, QA 전문가

### 시급 및 경력 분포

| 경력 수준 | 비율 | 평균 시급 |
|-----------|------|-----------|
| junior | 20% | 45,000-60,000원 |
| mid | 40% | 60,000-80,000원 |
| senior | 35% | 80,000-120,000원 |
| expert | 5% | 120,000-150,000원 |

---

## 🚀 데이터 설치 가이드

### 1단계: 스키마 생성

```bash
# 테이블 생성
mysql -u root -p jobtracker < database/schema.sql
```

### 2단계: 사용자 데이터 삽입

```bash
# 120명의 사용자 데이터 삽입
mysql -u root -p jobtracker < database/insert_120_users_premium.sql
```

### 3단계: 프리랜서 데이터 삽입

```bash
# 100명의 프리랜서 데이터 순차 삽입
mysql -u root -p jobtracker < database/insert_100_freelancers_premium.sql
mysql -u root -p jobtracker < database/insert_100_freelancers_premium_part2.sql
mysql -u root -p jobtracker < database/insert_100_freelancers_premium_part3.sql
```

---

## 📊 인덱스 구조

### Users 테이블 인덱스
```sql
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);
```

### Freelancers 테이블 인덱스
```sql
CREATE INDEX idx_freelancers_user_id ON freelancers(user_id);
CREATE INDEX idx_freelancers_title ON freelancers(title);
CREATE INDEX idx_freelancers_experience_level ON freelancers(experience_level);
CREATE INDEX idx_freelancers_hourly_rate ON freelancers(hourly_rate);
CREATE INDEX idx_freelancers_rating ON freelancers(rating DESC);
CREATE INDEX idx_freelancers_availability ON freelancers(availability);
```

---

## 🔍 검증 쿼리

### 사용자 데이터 검증

```sql
-- 전체 사용자 수 및 역할별 분포
SELECT role, COUNT(*) as count 
FROM users 
GROUP BY role 
ORDER BY count DESC;

-- 최근 가입 사용자 확인
SELECT username, name, role, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;
```

### 프리랜서 데이터 검증

```sql
-- 경력별 평균 시급
SELECT 
    experience_level,
    COUNT(*) as count,
    ROUND(AVG(hourly_rate), 0) as avg_hourly_rate
FROM freelancers 
GROUP BY experience_level;

-- 상위 평점 프리랜서
SELECT 
    f.title, 
    f.rating, 
    f.hourly_rate, 
    u.name 
FROM freelancers f
JOIN users u ON f.user_id = u.id
ORDER BY f.rating DESC 
LIMIT 10;
```

---

## 🔧 MCP 서버 설정

### mcp-settings.json 구성

```json
{
  "mcpServers": {
    "mariadb": {
      "command": "node",
      "args": ["./mariadb-mcp-server/dist/index.js"],
      "env": {
        "MARIADB_HOST": "192.168.0.109",
        "MARIADB_PORT": "3306",
        "MARIADB_USER": "root",
        "MARIADB_PASSWORD": "~Asy10131227",
        "MARIADB_DATABASE": "jobtracker",
        "MARIADB_ALLOW_INSERT": "true",
        "MARIADB_ALLOW_UPDATE": "true",
        "MARIADB_ALLOW_DELETE": "false"
      },
      "disabled": false
    }
  }
}
```

---

## 🛡️ 보안 고려사항

1. **비밀번호 정책**
   - 모든 테스트 계정은 BCrypt 해시 사용
   - 프로덕션에서는 강력한 비밀번호 정책 적용 필수

2. **권한 관리**
   - 최소 권한 원칙 적용
   - 역할별 접근 제어 구현

3. **데이터 보호**
   - 개인정보는 테스트용 더미 데이터만 사용
   - 실제 환경에서는 암호화 적용

---

## 🐛 문제 해결

### 연결 오류
```bash
# MariaDB 서비스 상태 확인
sudo systemctl status mariadb

# 포트 확인
netstat -an | grep 3306
```

### 인코딩 문제
```sql
SET NAMES utf8mb4;
ALTER DATABASE jobtracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 권한 오류
```sql
-- 현재 권한 확인
SHOW GRANTS FOR CURRENT_USER();

-- 권한 재설정
GRANT ALL PRIVILEGES ON jobtracker.* TO 'pm7_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## 📈 성능 최적화

1. **쿼리 최적화**
   - 인덱스된 컬럼을 WHERE 절에 사용
   - JOIN 시 외래 키 활용

2. **연결 풀 설정**
   - HikariCP 최대 연결 수: 20
   - 유휴 시간 초과: 60초

3. **캐싱 전략**
   - Redis를 통한 자주 조회되는 데이터 캐싱
   - 세션 정보 캐싱

---

## 📚 참고 자료

- [MariaDB 공식 문서](https://mariadb.org/documentation/)
- [Spring Boot + MyBatis 가이드](https://mybatis.org/spring-boot-starter/)
- [MCP 프로토콜 문서](https://modelcontextprotocol.io/)

---

**최종 업데이트**: 2024-12-19  
**버전**: 1.0 (통합본)  
**문의**: PM7 개발팀