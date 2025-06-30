-- ===================================================================
-- JobKorea Billboard - Database Control Language (DCL)
-- 사용자 권한 및 보안 설정
-- ===================================================================

USE jobtracker;

-- ===================================================================
-- 1. 데이터베이스 사용자 생성
-- ===================================================================

-- 애플리케이션용 사용자 (읽기/쓰기 권한)
CREATE USER IF NOT EXISTS 'jobkorea_app'@'localhost' IDENTIFIED BY 'JobKorea2024!@#';
CREATE USER IF NOT EXISTS 'jobkorea_app'@'%' IDENTIFIED BY 'JobKorea2024!@#';

-- 읽기 전용 사용자 (분석, 리포팅용)
CREATE USER IF NOT EXISTS 'jobkorea_readonly'@'localhost' IDENTIFIED BY 'ReadOnly2024!@#';
CREATE USER IF NOT EXISTS 'jobkorea_readonly'@'%' IDENTIFIED BY 'ReadOnly2024!@#';

-- 백업 전용 사용자
CREATE USER IF NOT EXISTS 'jobkorea_backup'@'localhost' IDENTIFIED BY 'Backup2024!@#';

-- 개발용 사용자 (개발 환경에서만 사용)
CREATE USER IF NOT EXISTS 'jobkorea_dev'@'localhost' IDENTIFIED BY 'DevUser2024!@#';

-- ===================================================================
-- 2. 애플리케이션 사용자 권한 설정
-- ===================================================================

-- 기본 CRUD 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON jobtracker.* TO 'jobkorea_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON jobtracker.* TO 'jobkorea_app'@'%';

-- 인덱스 관리 권한
GRANT INDEX ON jobtracker.* TO 'jobkorea_app'@'localhost';
GRANT INDEX ON jobtracker.* TO 'jobkorea_app'@'%';

-- 임시 테이블 생성 권한 (복잡한 쿼리용)
GRANT CREATE TEMPORARY TABLES ON jobtracker.* TO 'jobkorea_app'@'localhost';
GRANT CREATE TEMPORARY TABLES ON jobtracker.* TO 'jobkorea_app'@'%';

-- 트리거 실행 권한
GRANT TRIGGER ON jobtracker.* TO 'jobkorea_app'@'localhost';
GRANT TRIGGER ON jobtracker.* TO 'jobkorea_app'@'%';

-- ===================================================================
-- 3. 읽기 전용 사용자 권한 설정
-- ===================================================================

-- 모든 테이블에 대한 읽기 권한만 부여
GRANT SELECT ON jobtracker.* TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.* TO 'jobkorea_readonly'@'%';

-- 프로시저 실행 권한 (읽기 전용 프로시저용)
GRANT EXECUTE ON jobtracker.* TO 'jobkorea_readonly'@'localhost';
GRANT EXECUTE ON jobtracker.* TO 'jobkorea_readonly'@'%';

-- ===================================================================
-- 4. 백업 사용자 권한 설정
-- ===================================================================

-- 백업을 위한 읽기 권한
GRANT SELECT ON jobtracker.* TO 'jobkorea_backup'@'localhost';

-- 백업을 위한 테이블 잠금 권한
GRANT LOCK TABLES ON jobtracker.* TO 'jobkorea_backup'@'localhost';

-- 프로세스 확인 권한 (백업 중 프로세스 모니터링)
GRANT PROCESS ON *.* TO 'jobkorea_backup'@'localhost';

-- ===================================================================
-- 5. 개발 사용자 권한 설정 (개발 환경 전용)
-- ===================================================================

-- 개발자용 모든 권한 (개발 환경에서만 사용)
GRANT ALL PRIVILEGES ON jobtracker.* TO 'jobkorea_dev'@'localhost';

-- 테이블 생성/삭제 권한 (개발 중 스키마 변경용)
GRANT CREATE, DROP, ALTER ON jobtracker.* TO 'jobkorea_dev'@'localhost';

-- ===================================================================
-- 6. 보안 정책 설정
-- ===================================================================

-- 민감한 데이터 테이블에 대한 특별 권한 설정
-- (예: 사용자 비밀번호, 결제 정보 등)

-- 시스템 관리자만 사용자 비밀번호 컬럼에 접근 가능하도록 제한
-- 애플리케이션에서는 비밀번호 해시만 읽기 가능
REVOKE SELECT (password_hash) ON jobtracker.users FROM 'jobkorea_readonly'@'localhost';
REVOKE SELECT (password_hash) ON jobtracker.users FROM 'jobkorea_readonly'@'%';

-- ===================================================================
-- 7. 뷰 생성 (민감한 데이터 보호)
-- ===================================================================

-- 사용자 정보 뷰 (비밀번호 제외)
CREATE OR REPLACE VIEW v_users_safe AS
SELECT 
    id, username, email, full_name, phone, profile_image,
    role, status, email_verified, bio, location, website,
    last_login, created_at, updated_at
FROM users
WHERE status != 'deleted';

-- 프리랜서 공개 정보 뷰
CREATE OR REPLACE VIEW v_freelancers_public AS
SELECT 
    f.id, f.user_id, f.title, f.description, f.skills,
    f.experience_level, f.availability, f.preferred_work_type,
    f.portfolio_url, f.rating, f.total_reviews, f.completed_projects,
    f.is_verified, u.full_name, u.location, u.profile_image
FROM freelancers f
JOIN users u ON f.user_id = u.id
WHERE u.status = 'active' AND f.availability != 'unavailable';

-- 프로젝트 요약 뷰
CREATE OR REPLACE VIEW v_projects_summary AS
SELECT 
    p.id, p.title, p.category, p.budget_min, p.budget_max,
    p.work_type, p.experience_level, p.required_skills,
    p.status, p.views, p.applications_count, p.is_featured,
    p.deadline, p.created_at,
    u.full_name as client_name, c.name as company_name
FROM projects p
JOIN users u ON p.client_id = u.id
LEFT JOIN companies c ON p.company_id = c.id
WHERE p.status IN ('active', 'in_progress');

-- 채용공고 요약 뷰
CREATE OR REPLACE VIEW v_jobs_summary AS
SELECT 
    j.id, j.title, j.department, j.employment_type,
    j.work_type, j.salary_min, j.salary_max, j.location,
    j.required_skills, j.status, j.views, j.application_deadline,
    j.created_at, c.name as company_name, c.logo_url
FROM job_postings j
JOIN companies c ON j.company_id = c.id
WHERE j.status = 'active';

-- ===================================================================
-- 8. 뷰에 대한 권한 부여
-- ===================================================================

-- 읽기 전용 사용자에게 뷰 접근 권한 부여
GRANT SELECT ON jobtracker.v_users_safe TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.v_users_safe TO 'jobkorea_readonly'@'%';

GRANT SELECT ON jobtracker.v_freelancers_public TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.v_freelancers_public TO 'jobkorea_readonly'@'%';

GRANT SELECT ON jobtracker.v_projects_summary TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.v_projects_summary TO 'jobkorea_readonly'@'%';

GRANT SELECT ON jobtracker.v_jobs_summary TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.v_jobs_summary TO 'jobkorea_readonly'@'%';

-- 애플리케이션 사용자에게도 뷰 접근 권한 부여
GRANT SELECT ON jobtracker.v_users_safe TO 'jobkorea_app'@'localhost';
GRANT SELECT ON jobtracker.v_users_safe TO 'jobkorea_app'@'%';

GRANT SELECT ON jobtracker.v_freelancers_public TO 'jobkorea_app'@'localhost';
GRANT SELECT ON jobtracker.v_freelancers_public TO 'jobkorea_app'@'%';

GRANT SELECT ON jobtracker.v_projects_summary TO 'jobkorea_app'@'localhost';
GRANT SELECT ON jobtracker.v_projects_summary TO 'jobkorea_app'@'%';

GRANT SELECT ON jobtracker.v_jobs_summary TO 'jobkorea_app'@'localhost';
GRANT SELECT ON jobtracker.v_jobs_summary TO 'jobkorea_app'@'%';

-- ===================================================================
-- 9. 연결 제한 설정
-- ===================================================================

-- 사용자별 연결 수 제한
ALTER USER 'jobkorea_app'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 1000;
ALTER USER 'jobkorea_app'@'%' WITH MAX_CONNECTIONS_PER_HOUR 1000;

ALTER USER 'jobkorea_readonly'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 500;
ALTER USER 'jobkorea_readonly'@'%' WITH MAX_CONNECTIONS_PER_HOUR 500;

ALTER USER 'jobkorea_backup'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 10;
ALTER USER 'jobkorea_dev'@'localhost' WITH MAX_CONNECTIONS_PER_HOUR 100;

-- ===================================================================
-- 10. 감사 로그용 테이블 및 권한
-- ===================================================================

-- 감사 로그 테이블 생성
CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT COMMENT '작업 수행 사용자',
    table_name VARCHAR(100) NOT NULL COMMENT '테이블명',
    operation ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL COMMENT '작업 타입',
    record_id INT COMMENT '대상 레코드 ID',
    old_values JSON COMMENT '이전 값',
    new_values JSON COMMENT '새로운 값',
    ip_address VARCHAR(45) COMMENT 'IP 주소',
    user_agent TEXT COMMENT '사용자 에이전트',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작업 시간',
    
    INDEX idx_user_id (user_id),
    INDEX idx_table_operation (table_name, operation),
    INDEX idx_created_at (created_at)
) COMMENT='감사 로그';

-- 감사 로그에 대한 권한은 시스템 관리자만
GRANT INSERT ON jobtracker.audit_logs TO 'jobkorea_app'@'localhost';
GRANT INSERT ON jobtracker.audit_logs TO 'jobkorea_app'@'%';

GRANT SELECT ON jobtracker.audit_logs TO 'jobkorea_readonly'@'localhost';
GRANT SELECT ON jobtracker.audit_logs TO 'jobkorea_readonly'@'%';

-- ===================================================================
-- 11. 권한 적용 및 새로고침
-- ===================================================================

-- 권한 테이블 새로고침
FLUSH PRIVILEGES;

-- ===================================================================
-- 12. 권한 확인 쿼리 (관리용)
-- ===================================================================

-- 사용자별 권한 확인
-- SELECT User, Host, Select_priv, Insert_priv, Update_priv, Delete_priv 
-- FROM mysql.user 
-- WHERE User LIKE 'jobkorea_%';

-- 데이터베이스별 권한 확인
-- SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv, Delete_priv 
-- FROM mysql.db 
-- WHERE Db = 'jobtracker';

-- 테이블별 권한 확인
-- SELECT User, Host, Db, Table_name, Table_priv 
-- FROM mysql.tables_priv 
-- WHERE Db = 'jobtracker';

-- ===================================================================
-- 13. 보안 관련 추가 설정
-- ===================================================================

-- 데이터베이스 사용자 계정 만료 정책 설정 (선택사항)
-- ALTER USER 'jobkorea_app'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
-- ALTER USER 'jobkorea_readonly'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;

-- 계정 잠금 정책 설정 (로그인 실패 시)
-- ALTER USER 'jobkorea_app'@'localhost' FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 2;
-- ALTER USER 'jobkorea_readonly'@'localhost' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 5;

-- ===================================================================
-- DCL 설정 완료
-- ===================================================================

-- 생성된 사용자 정보 요약 출력
SELECT 
    'jobkorea_app' as username,
    'Application user with full CRUD access' as description,
    'JobKorea2024!@#' as password
UNION ALL
SELECT 
    'jobkorea_readonly',
    'Read-only user for reporting and analytics',
    'ReadOnly2024!@#'
UNION ALL
SELECT 
    'jobkorea_backup',
    'Backup user with minimal required permissions',
    'Backup2024!@#'
UNION ALL
SELECT 
    'jobkorea_dev',
    'Development user (dev environment only)',
    'DevUser2024!@#';

-- 주요 뷰 목록
SELECT 
    TABLE_NAME as view_name,
    VIEW_DEFINITION as description
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'jobtracker'
ORDER BY TABLE_NAME;