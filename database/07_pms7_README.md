# PMS7 Database Schema Documentation

## 개요
PMS7 (Project Management System Version 7)은 프로젝트 관리 시스템을 위한 데이터베이스 스키마입니다. 이 시스템은 사용자 관리, 채용공고, 공지사항, 이벤트, 메뉴 시스템 등을 포함하는 종합적인 관리 플랫폼입니다.

## 데이터베이스 구조

### 핵심 테이블

#### 1. 사용자 관리
- **`roles`**: 사용자 역할 정의 (ADMIN, USER, MANAGER, HR, DEVELOPER)
- **`users`**: 사용자 기본 정보 (username, email, password, role_id)
- **`sessions`**: 사용자 세션 관리

#### 2. 채용 시스템
- **`categories`**: 채용공고 카테고리
- **`jobs`**: 채용공고 정보
- **`applications`**: 지원서 관리

#### 3. 콘텐츠 관리
- **`notices`**: 공지사항
- **`notice_attachments`**: 공지사항 첨부파일
- **`events`**: 이벤트 관리

#### 4. 메뉴 시스템
- **`menu_types`**: 메뉴 카테고리
- **`menus`**: 1차 메뉴
- **`sub_menus`**: 2차 서브메뉴
- **`menu_permissions`**: 역할별 메뉴 접근 권한
- **`user_menu_customizations`**: 사용자별 메뉴 커스터마이징
- **`user_menu_favorites`**: 사용자별 즐겨찾기 메뉴

#### 5. 레거시
- **`g5_menu`**: G5 CMS 호환용 메뉴 테이블

## 주요 특징

### 1. 계층적 메뉴 시스템
```
Menu Types → Menus → Sub Menus
     ↓           ↓        ↓
   권한 관리  →  역할별 접근 제어
```

### 2. 역할 기반 권한 관리 (RBAC)
- **ADMIN**: 모든 시스템 기능 접근
- **MANAGER**: 사용자 관리 및 운영 기능
- **HR**: 채용 관련 기능
- **USER**: 기본 사용자 기능
- **DEVELOPER**: 개발자 전용 기능

### 3. 자동화된 이벤트 상태 관리
```sql
-- 이벤트 상태 자동 업데이트 트리거
TRIGGER before_event_insert/update:
- FINISHED: 종료된 이벤트
- IN_PROGRESS: 진행 중인 이벤트  
- UPCOMING: 예정된 이벤트
```

### 4. 사용자 경험 개선
- 메뉴 커스터마이징 (숨김/표시, 순서 변경)
- 즐겨찾기 메뉴
- 첨부파일 지원

## 설치 및 실행

### 1. 데이터베이스 생성
```bash
mysql -u root -p < 05_pms7_ddl_create_tables.sql
```

### 2. 샘플 데이터 삽입
```bash
mysql -u root -p < 06_pms7_dml_insert_data.sql
```

### 3. 연결 설정
```yaml
# application.yml
spring:
  datasource:
    url: jdbc:mariadb://localhost:3306/pms7
    username: root
    password: your_password
```

## API 엔드포인트

### 사용자 관리
- `GET /api/users` - 사용자 목록
- `POST /api/users` - 사용자 등록
- `PUT /api/users/{id}` - 사용자 정보 수정
- `DELETE /api/users/{id}` - 사용자 삭제

### 공지사항
- `GET /api/notices` - 공지사항 목록
- `POST /api/notices` - 공지사항 등록
- `GET /api/notices/{id}` - 공지사항 상세
- `PUT /api/notices/{id}` - 공지사항 수정

### 이벤트
- `GET /api/events` - 이벤트 목록
- `POST /api/events` - 이벤트 등록
- `GET /api/events/{id}` - 이벤트 상세
- `PUT /api/events/{id}` - 이벤트 수정

### 채용공고
- `GET /api/jobs` - 채용공고 목록
- `POST /api/jobs` - 채용공고 등록
- `POST /api/jobs/{id}/apply` - 지원서 제출

### 메뉴 시스템
- `GET /api/menus` - 사용자별 메뉴 조회
- `POST /api/menus/favorites` - 즐겨찾기 추가
- `PUT /api/menus/customization` - 메뉴 커스터마이징

## 보안 고려사항

### 1. 비밀번호 암호화
- BCrypt 해시 알고리즘 사용
- 솔트 포함 암호화

### 2. 세션 관리
- JWT 토큰 기반 인증
- 세션 타임아웃 관리

### 3. 권한 검증
- 역할 기반 접근 제어
- 메뉴별 권한 검증

### 4. SQL 인젝션 방지
- 파라미터화된 쿼리 사용
- 입력값 검증

## 성능 최적화

### 1. 인덱스 설정
```sql
-- 주요 검색 필드에 인덱스 적용
INDEX role_id (role_id)
INDEX type_id (type_id)  
INDEX user_id (user_id)
INDEX notice_id (notice_id)
```

### 2. 외래키 제약조건
- 데이터 무결성 보장
- CASCADE 삭제로 관련 데이터 자동 정리

### 3. 캐싱 전략
- 메뉴 구조 캐싱
- 권한 정보 캐싱
- 자주 조회되는 공지사항 캐싱

## 데이터베이스 버전 관리

### 마이그레이션 히스토리
- v1.0: 기본 사용자 관리
- v2.0: 채용 시스템 추가
- v3.0: 메뉴 시스템 구현
- v4.0: 권한 관리 강화
- v5.0: 이벤트 시스템 추가
- v6.0: 첨부파일 지원
- **v7.0: 현재 버전 (PMS7)**

### 향후 계획
- v7.1: 알림 시스템 추가
- v7.2: 대시보드 위젯 시스템
- v7.3: 다국어 지원
- v8.0: 마이크로서비스 아키텍처 전환

## 문제 해결

### 자주 발생하는 문제

1. **외래키 제약조건 오류**
   ```sql
   SET FOREIGN_KEY_CHECKS=0;
   -- 데이터 작업 수행
   SET FOREIGN_KEY_CHECKS=1;
   ```

2. **권한 문제**
   ```sql
   -- 사용자에게 권한 부여
   INSERT INTO menu_permissions (role_id, menu_id, can_access) 
   VALUES (user_role_id, target_menu_id, 1);
   ```

3. **세션 만료**
   - JWT 토큰 갱신 구현
   - 세션 정리 배치 작업

## 연락처
- 개발팀: dev@company.com
- 시스템 관리: admin@company.com
- 문서 관리: docs@company.com

---
*Last Updated: 2025-07-01*
*Version: PMS7 v7.0*