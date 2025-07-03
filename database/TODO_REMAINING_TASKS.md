# PM7 프로젝트 - 남은 작업 목록

## 1. DML (Data Manipulation Language) - 샘플 데이터 생성

### ✅ 완료된 작업
- [x] users 테이블 샘플 데이터 파일 생성 (insert_users_200.sql)
- [x] categories 테이블 샘플 데이터 파일 생성 (insert_categories_200.sql)
- [x] companies 테이블 샘플 데이터 파일 생성 (insert_companies_200.sql)

### 📋 남은 DML 작업

#### 1.1 freelancers 테이블 (200개)
```sql
-- insert_freelancers_200.sql
-- users 테이블과 1:1 관계
-- 필수 컬럼: user_id, title, experience_level
-- JSON 컬럼: skills
-- 주의사항: user_id는 중복되지 않아야 함
```

#### 1.2 projects 테이블 (200개)
```sql
-- insert_projects_200.sql
-- company_id, client_id, category_id 참조
-- 필수 컬럼: title, description, status
-- JSON 컬럼: required_skills, preferred_skills
-- 다양한 project_type, work_type, status 조합
```

#### 1.3 project_applications 테이블 (500개)
```sql
-- insert_project_applications_500.sql
-- project_id, user_id/freelancer_id 참조
-- 다양한 status (pending, reviewing, accepted, rejected, withdrawn)
-- UNIQUE 제약: project_id + user_id 조합
```

#### 1.4 reviews 테이블 (300개)
```sql
-- insert_reviews_300.sql
-- reviewer_id, reviewee_id, project_id 참조
-- rating: 0.00 ~ 5.00
-- review_type: freelancer_to_client, client_to_freelancer
```

#### 1.5 messages 테이블 (400개)
```sql
-- insert_messages_400.sql
-- sender_id, receiver_id, project_id(optional) 참조
-- is_read: true/false
-- 실제 메시지 대화 형태로 생성
```

#### 1.6 notifications 테이블 (500개)
```sql
-- insert_notifications_500.sql
-- user_id 참조
-- 다양한 type (프로젝트 지원, 메시지 수신, 리뷰 등록 등)
-- is_read: true/false
```

#### 1.7 portfolios 테이블 (300개)
```sql
-- insert_portfolios_300.sql
-- user_id 참조 (프리랜서들의 포트폴리오)
-- tags: JSON 배열
-- is_featured: 일부만 true
```

#### 1.8 blog_posts 테이블 (150개)
```sql
-- insert_blog_posts_150.sql
-- user_id/author_id, category_id 참조
-- status: draft, published, archived
-- tags: JSON 배열
-- slug: 유니크해야 함
```

#### 1.9 community_posts 테이블 (200개)
```sql
-- insert_community_posts_200.sql
-- user_id, category_id 참조
-- post_type: question, discussion, share, notice
-- 일부 is_pinned, is_locked
```

#### 1.10 comments 테이블 (600개)
```sql
-- insert_comments_600.sql
-- user_id/author_id 참조
-- blog_posts와 community_posts에 대한 댓글
-- parent_id로 대댓글 구조
```

#### 1.11 기타 테이블들
```sql
-- insert_other_tables.sql
-- job_postings: 100개
-- user_sessions: 200개
-- file_uploads: 300개
-- tags: 100개
-- system_settings: 20개
-- search_logs: 500개
-- project_skills: 400개
-- project_benefits: 300개
-- project_requirements: 300개
-- project_responsibilities: 300개
-- project_views: 1000개
-- project_bookmarks: 200개
```

## 2. DCL (Data Control Language) - 권한 설정

### 📋 생성할 DCL 파일

#### 2.1 기본 사용자 및 권한 설정
```sql
-- dcl_user_permissions.sql
-- 1. 애플리케이션 사용자 생성
--    - pm7_app: 애플리케이션 전용 사용자
--    - pm7_read: 읽기 전용 사용자
--    - pm7_admin: 관리자 사용자

-- 2. 데이터베이스 권한 부여
--    - pm7_app: SELECT, INSERT, UPDATE, DELETE on jobtracker.*
--    - pm7_read: SELECT on jobtracker.*
--    - pm7_admin: ALL PRIVILEGES on jobtracker.*

-- 3. 테이블별 세부 권한
--    - 민감한 테이블(users, companies)에 대한 제한적 권한
```

#### 2.2 역할(Role) 기반 권한 관리
```sql
-- dcl_roles.sql
-- 1. 역할 생성
--    - role_developer: 개발자 역할
--    - role_analyst: 분석가 역할
--    - role_support: 고객지원 역할

-- 2. 역할별 권한 부여
-- 3. 사용자에게 역할 할당
```

#### 2.3 보안 설정
```sql
-- dcl_security.sql
-- 1. 접속 제한 설정
--    - 특정 IP/호스트에서만 접속 가능
-- 2. SSL 연결 강제
-- 3. 비밀번호 정책 설정
-- 4. 감사(Audit) 설정
```

## 3. 추가 유틸리티 스크립트

### 3.1 데이터 검증 스크립트
```sql
-- verify_data.sql
-- 각 테이블의 데이터 수 확인
-- 외래키 무결성 검증
-- 필수 필드 NULL 체크
```

### 3.2 백업 스크립트
```bash
-- backup_database.sh
-- 데이터베이스 전체 백업
-- 테이블별 개별 백업
-- 백업 파일 압축 및 보관
```

### 3.3 초기화 스크립트
```sql
-- reset_database.sql
-- 모든 데이터 삭제
-- 시퀀스 초기화
-- 테이블 재생성
```

## 4. 실행 순서

1. **DDL 실행** (완료)
   - UNIFIED_DDL_SCHEMA.sql

2. **DML 실행** (순서 중요!)
   ```bash
   # 기본 테이블
   mysql < insert_users_200.sql
   mysql < insert_categories_200.sql
   mysql < insert_companies_200.sql
   mysql < insert_freelancers_200.sql
   
   # 프로젝트 관련
   mysql < insert_projects_200.sql
   mysql < insert_project_applications_500.sql
   mysql < insert_project_skills_400.sql
   mysql < insert_project_benefits_300.sql
   mysql < insert_project_requirements_300.sql
   mysql < insert_project_responsibilities_300.sql
   mysql < insert_project_views_1000.sql
   mysql < insert_project_bookmarks_200.sql
   
   # 커뮤니케이션
   mysql < insert_messages_400.sql
   mysql < insert_notifications_500.sql
   mysql < insert_reviews_300.sql
   
   # 콘텐츠
   mysql < insert_blog_posts_150.sql
   mysql < insert_community_posts_200.sql
   mysql < insert_comments_600.sql
   mysql < insert_portfolios_300.sql
   
   # 기타
   mysql < insert_other_tables.sql
   ```

3. **DCL 실행**
   ```bash
   mysql < dcl_user_permissions.sql
   mysql < dcl_roles.sql
   mysql < dcl_security.sql
   ```

4. **검증**
   ```bash
   mysql < verify_data.sql
   ```

## 5. 주의사항

1. **외래키 순서**: 참조 무결성을 위해 반드시 순서대로 실행
2. **트랜잭션**: 대량 INSERT 시 트랜잭션 단위로 처리
3. **인덱스**: 대량 데이터 삽입 후 인덱스 재구성 고려
4. **권한**: DCL 실행은 root 또는 충분한 권한을 가진 사용자로 실행

## 6. 예상 소요 시간

- DML 파일 생성: 3-4시간
- DML 실행: 30분-1시간
- DCL 파일 생성: 1시간
- DCL 실행: 10분
- 검증: 30분

**총 예상 시간: 5-7시간**