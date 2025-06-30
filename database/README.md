# JobKorea Billboard Database Schema

## 📋 개요

이 폴더는 JobKorea Billboard 프로젝트의 완전한 데이터베이스 스키마와 관련 스크립트들을 포함합니다.

## 📁 파일 구조

```
database/
├── 01_ddl_create_tables.sql    # 테이블 생성 DDL
├── 02_dml_insert_data.sql      # 더미 데이터 DML
├── 03_dcl_permissions.sql      # 권한 설정 DCL
├── 04_erd_diagram.md          # ERD 다이어그램
├── schema.sql                 # 기존 스키마 (호환성)
└── README.md                  # 이 파일
```

## 🚀 빠른 시작

### 1. 데이터베이스 생성 및 스키마 적용

```bash
# 1. 데이터베이스와 테이블 생성
mysql -u root -p < database/01_ddl_create_tables.sql

# 2. 더미 데이터 삽입
mysql -u root -p < database/02_dml_insert_data.sql

# 3. 사용자 권한 설정
mysql -u root -p < database/03_dcl_permissions.sql
```

### 2. npm 스크립트 사용

```bash
# 전체 스키마 적용 (package.json에 스크립트 추가 필요)
npm run db:setup

# 데이터베이스 연결 테스트
npm run test:db
```

## 📊 데이터베이스 구조

### 🔑 핵심 테이블 (18개)

| 카테고리 | 테이블명 | 설명 |
|---------|----------|------|
| **사용자** | `users` | 기본 사용자 정보 |
| | `freelancers` | 프리랜서 전문 정보 |
| | `companies` | 회사 정보 |
| **프로젝트** | `projects` | 프리랜서 프로젝트 |
| | `project_applications` | 프로젝트 지원 |
| **채용** | `job_postings` | 채용 공고 |
| **콘텐츠** | `blog_posts` | 블로그 게시물 |
| | `community_posts` | 커뮤니티 게시물 |
| | `comments` | 댓글 시스템 |
| **평가** | `reviews` | 리뷰 및 평점 |
| | `portfolios` | 포트폴리오 |
| **소통** | `messages` | 메시지 시스템 |
| | `notifications` | 알림 |
| **시스템** | `user_sessions` | 사용자 세션 |
| | `file_uploads` | 파일 업로드 |
| | `tags` | 태그 관리 |
| | `search_logs` | 검색 로그 |
| | `system_settings` | 시스템 설정 |
| | `audit_logs` | 감사 로그 |

### 📈 주요 특징

- **성능 최적화**: 적절한 인덱싱과 FULLTEXT 검색
- **보안**: 사용자별 권한 분리 및 민감 데이터 보호
- **확장성**: JSON 컬럼과 모듈형 구조
- **감사**: 모든 중요 작업 로깅

## 👥 데이터베이스 사용자

### 생성된 사용자 계정

| 사용자명 | 용도 | 권한 | 비밀번호 |
|---------|------|------|---------|
| `jobkorea_app` | 애플리케이션 | CRUD + INDEX | JobKorea2024!@# |
| `jobkorea_readonly` | 분석/리포팅 | SELECT만 | ReadOnly2024!@# |
| `jobkorea_backup` | 백업 | SELECT + LOCK | Backup2024!@# |
| `jobkorea_dev` | 개발 (dev 환경) | ALL | DevUser2024!@# |

### 보안 뷰

민감한 데이터 보호를 위한 뷰:
- `v_users_safe`: 비밀번호 제외 사용자 정보
- `v_freelancers_public`: 공개 프리랜서 정보
- `v_projects_summary`: 프로젝트 요약 정보
- `v_jobs_summary`: 채용공고 요약 정보

## 🔗 ERD 다이어그램

자세한 테이블 관계는 [ERD 다이어그램](./04_erd_diagram.md)을 참조하세요.

## 🧪 더미 데이터

### 포함된 테스트 데이터

- **사용자**: 10명 (관리자 1명, 프리랜서 5명, 클라이언트 4명)
- **회사**: 4개 (다양한 규모)
- **프로젝트**: 7개 (진행 단계별)
- **채용공고**: 5개 (다양한 직무)
- **블로그 포스트**: 7개 (카테고리별)
- **커뮤니티 게시물**: 8개
- **리뷰**: 6개 (상호 평가)
- **포트폴리오**: 6개
- **기타**: 메시지, 알림, 파일, 태그 등

### 테스트 계정

```
관리자: admin / admin@jobkorea.com
프리랜서: john_dev / john@example.com
클라이언트: tech_company / hr@techcompany.com
```

## 🛠 개발 가이드

### 새 테이블 추가 시

1. `01_ddl_create_tables.sql`에 CREATE TABLE 구문 추가
2. `02_dml_insert_data.sql`에 샘플 데이터 추가
3. 필요시 `03_dcl_permissions.sql`에 권한 설정 추가
4. `04_erd_diagram.md`의 ERD 다이어그램 업데이트

### 스키마 변경 시

```sql
-- 마이그레이션 스크립트 예시
ALTER TABLE users ADD COLUMN new_field VARCHAR(100);
INSERT INTO audit_logs (table_name, operation, new_values) 
VALUES ('users', 'ALTER', '{"added_column": "new_field"}');
```

## 🔧 유지보수

### 정기 작업

```sql
-- 만료된 세션 정리
DELETE FROM user_sessions WHERE expires_at < NOW();

-- 오래된 검색 로그 정리 (30일 이상)
DELETE FROM search_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- 삭제된 파일 정리
DELETE FROM file_uploads WHERE status = 'deleted' AND created_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
```

### 백업 명령어

```bash
# 전체 백업
mysqldump -u jobkorea_backup -p jobtracker > backup_$(date +%Y%m%d).sql

# 스키마만 백업
mysqldump -u jobkorea_backup -p --no-data jobtracker > schema_backup.sql

# 특정 테이블만 백업
mysqldump -u jobkorea_backup -p jobtracker users projects > critical_data.sql
```

## 📊 성능 모니터링

### 유용한 쿼리

```sql
-- 느린 쿼리 확인
SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST WHERE TIME > 5;

-- 테이블 크기 확인
SELECT 
    TABLE_NAME,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'SIZE_MB'
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'jobtracker'
ORDER BY SIZE_MB DESC;

-- 인덱스 사용률 확인
SHOW INDEX FROM projects;
```

## 🚨 주의사항

1. **프로덕션 환경**에서는 개발용 사용자(`jobkorea_dev`) 계정을 생성하지 마세요
2. **비밀번호**는 반드시 변경하여 사용하세요
3. **백업**을 정기적으로 수행하세요
4. **권한**은 최소 필요 원칙에 따라 부여하세요
5. **감사 로그**는 정기적으로 확인하세요

## 📞 지원

문제가 발생하면:
1. [ERD 다이어그램](./04_erd_diagram.md) 확인
2. 테이블 관계 및 제약조건 검토
3. 로그 파일 확인
4. 팀에 문의

---

**버전**: 1.0.0  
**최종 업데이트**: 2024-06-29  
**호환성**: MariaDB 10.3+, MySQL 8.0+