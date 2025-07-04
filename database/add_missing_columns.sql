-- projects 테이블에 누락된 컬럼들 추가

-- 1. client_id 컬럼 추가 (프로젝트 등록 사용자)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `client_id` INT DEFAULT NULL COMMENT '프로젝트 등록 사용자' AFTER `company_id`;

-- 2. category 컬럼 추가 (프로젝트 카테고리)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `category` VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리' AFTER `category_id`;

-- 3. 인덱스 추가
ALTER TABLE `projects` 
ADD INDEX IF NOT EXISTS `idx_client_id` (`client_id`);

-- 4. 외래키 제약조건 추가 (이미 존재하지 않는 경우에만)
-- client_id에 대한 외래키
SET @fk_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_SCHEMA = 'jobtracker' 
    AND TABLE_NAME = 'projects' 
    AND CONSTRAINT_NAME = 'fk_project_client'
);

SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE `projects` ADD CONSTRAINT `fk_project_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE',
    'SELECT "Foreign key fk_project_client already exists"'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5. 테이블 구조 확인
DESCRIBE projects;