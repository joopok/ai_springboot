# MariaDB MCP 서버 설정 가이드

이 가이드는 aiproject02 프로젝트에서 MariaDB를 MCP(Model Context Protocol)를 통해 연결하는 방법을 설명합니다.

## 📋 사전 요구사항

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

2. **Node.js** (이미 설치됨)

## 🔧 설정 단계

### 1. MariaDB 초기 설정

```bash
# MariaDB 보안 설정 (선택사항)
sudo mysql_secure_installation

# MariaDB 접속
mysql -u root -p
```

### 2. 데이터베이스 생성

MariaDB에 접속한 후 다음 명령어를 실행하세요:

```sql
-- 데이터베이스 생성
CREATE DATABASE aiproject02_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 사용자 생성 (선택사항 - 보안을 위해 권장)
CREATE USER 'aiproject02_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON aiproject02_db.* TO 'aiproject02_user'@'localhost';
FLUSH PRIVILEGES;

-- 데이터베이스 사용
USE aiproject02_db;
```

### 3. 스키마 생성

```bash
# 프로젝트 루트에서 실행
mysql -u root -p aiproject02_db < database/schema.sql
```

### 4. 환경 변수 설정

`.env.local` 파일을 생성하거나 수정하세요:

```env
# MariaDB Database Configuration
MARIADB_HOST=localhost
MARIADB_PORT=3306
MARIADB_USER=root
MARIADB_PASSWORD=your_password_here
MARIADB_DATABASE=aiproject02_db

# Database Connection Pool Settings
MARIADB_CONNECTION_LIMIT=10
MARIADB_ACQUIRE_TIMEOUT=60000
MARIADB_TIMEOUT=60000

# MCP Server Settings
MARIADB_ALLOW_INSERT=true
MARIADB_ALLOW_UPDATE=true
MARIADB_ALLOW_DELETE=false
```

### 5. MCP 설정

`mcp-settings.json` 파일을 수정하세요:

```json
{
  "mcpServers": {
    "mariadb": {
      "command": "node",
      "args": ["./mariadb-mcp-server/dist/index.js"],
      "env": {
        "MARIADB_HOST": "localhost",
        "MARIADB_PORT": "3306",
        "MARIADB_USER": "root",
        "MARIADB_PASSWORD": "your_password_here",
        "MARIADB_DATABASE": "aiproject02_db",
        "MARIADB_ALLOW_INSERT": "true",
        "MARIADB_ALLOW_UPDATE": "true",
        "MARIADB_ALLOW_DELETE": "false"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

## 🧪 연결 테스트

### 1. 데이터베이스 헬스 체크

```bash
# 개발 서버 실행
npm run dev

# 브라우저에서 접속
http://localhost:3000/api/database/health
```

### 2. 프로젝트 API 테스트

```bash
# 프로젝트 목록 조회
curl http://localhost:3000/api/projects

# 검색 기능 테스트
curl "http://localhost:3000/api/projects?search=React&type=remote&page=1&limit=10"
```

## 📊 데이터베이스 구조

### 주요 테이블

- **users**: 사용자 정보
- **projects**: 프로젝트 정보
- **blog_posts**: 블로그 게시글
- **freelancers**: 프리랜서 프로필
- **community_posts**: 커뮤니티 게시글
- **comments**: 댓글
- **notifications**: 알림

### 샘플 데이터

스키마 생성 시 다음 샘플 데이터가 자동으로 추가됩니다:

- 관리자 계정: `admin` / `admin123`
- 테스트 사용자들
- 샘플 프로젝트 3개
- 샘플 블로그 포스트 3개
- 샘플 커뮤니티 게시글 3개

## 🔧 사용 가능한 API 엔드포인트

### 데이터베이스 관련
- `GET /api/database/health` - 데이터베이스 연결 상태 확인

### 프로젝트 관련
- `GET /api/projects` - 프로젝트 목록 조회
- `GET /api/projects?type=remote` - 타입별 필터링
- `GET /api/projects?search=React` - 검색
- `POST /api/projects` - 새 프로젝트 생성

### 향후 추가 예정
- `GET /api/users` - 사용자 관리
- `GET /api/blog` - 블로그 관리
- `GET /api/freelancers` - 프리랜서 관리

## 🔒 보안 고려사항

1. **비밀번호 보안**: 강력한 데이터베이스 비밀번호 사용
2. **환경 변수**: `.env.local` 파일을 `.gitignore`에 추가
3. **사용자 권한**: 필요한 최소 권한만 부여
4. **SQL 인젝션**: 매개변수화된 쿼리 사용 (이미 구현됨)

## 🐛 문제 해결

### 연결 오류

```bash
# MariaDB 서비스 상태 확인
brew services list | grep mariadb  # macOS
sudo systemctl status mariadb      # Linux

# 포트 확인
netstat -an | grep 3306

# 로그 확인
tail -f /usr/local/var/mysql/*.err  # macOS
sudo tail -f /var/log/mysql/error.log  # Linux
```

### 권한 오류

```sql
-- 사용자 권한 확인
SHOW GRANTS FOR 'your_user'@'localhost';

-- 권한 재설정
GRANT ALL PRIVILEGES ON aiproject02_db.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
```

## 📚 추가 리소스

- [MariaDB 공식 문서](https://mariadb.org/documentation/)
- [Node.js MariaDB 클라이언트](https://github.com/mariadb-corporation/mariadb-connector-nodejs)
- [MCP 프로토콜 문서](https://modelcontextprotocol.io/)

## 🤝 기여하기

데이터베이스 스키마나 API에 개선사항이 있다면 이슈를 생성하거나 PR을 제출해주세요. 