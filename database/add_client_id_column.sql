-- projects 테이블에 client_id 컬럼 추가
-- client_id는 프로젝트를 등록한 사용자를 나타냅니다

-- 1. client_id 컬럼 추가
ALTER TABLE `projects` 
ADD COLUMN `client_id` INT DEFAULT NULL COMMENT '프로젝트 등록 사용자' AFTER `company_id`;

-- 2. 인덱스 추가
ALTER TABLE `projects` 
ADD INDEX `idx_client_id` (`client_id`);

-- 3. 외래키 제약조건 추가
ALTER TABLE `projects` 
ADD CONSTRAINT `fk_project_client` 
FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

-- 4. 기존 데이터 업데이트 (선택사항)
-- company_id가 있는 경우, 해당 회사의 첫 번째 사용자를 client_id로 설정
-- UPDATE projects p
-- JOIN companies c ON p.company_id = c.id
-- JOIN users u ON u.company_id = c.id
-- SET p.client_id = u.id
-- WHERE p.client_id IS NULL
-- AND u.id = (SELECT MIN(id) FROM users WHERE company_id = c.id);