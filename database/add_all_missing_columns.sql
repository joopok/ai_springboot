-- projects 테이블에 누락된 모든 컬럼 추가

-- 1. client_id 컬럼 추가 (프로젝트 등록 사용자)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `client_id` INT DEFAULT NULL COMMENT '프로젝트 등록 사용자' AFTER `company_id`;

-- 2. category 컬럼 추가 (프로젝트 카테고리)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `category` VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리' AFTER `category_id`;

-- 3. budget_type 컬럼 추가 (예산 타입)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `budget_type` ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입' AFTER `project_type`;

-- 4. start_date 컬럼 추가 (시작 예정일)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `start_date` DATE DEFAULT NULL COMMENT '시작 예정일' AFTER `duration`;

-- 5. preferred_skills 컬럼 추가 (우대 기술)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `preferred_skills` JSON DEFAULT NULL COMMENT '우대 기술 (JSON 배열)' AFTER `required_skills`;

-- 6. experience_years 컬럼 추가 (요구 경력 연수)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `experience_years` INT DEFAULT 0 COMMENT '요구 경력 연수' AFTER `preferred_skills`;

-- 7. experience_level 컬럼 추가 (요구 경력 레벨)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `experience_level` ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력' AFTER `experience_years`;

-- 8. applications 컬럼 추가 (지원자수)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `applications` INT DEFAULT 0 COMMENT '지원자수' AFTER `views`;

-- 9. applications_count 가상 컬럼 추가 (지원자수 별칭)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `applications_count` INT GENERATED ALWAYS AS (`applications`) VIRTUAL COMMENT '지원자수 별칭' AFTER `applications`;

-- 10. is_featured 컬럼 추가 (추천 여부)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `is_featured` BOOLEAN DEFAULT FALSE COMMENT '추천 여부' AFTER `applications_count`;

-- 11. is_urgent 컬럼 추가 (긴급 여부)
ALTER TABLE `projects` 
ADD COLUMN IF NOT EXISTS `is_urgent` BOOLEAN DEFAULT FALSE COMMENT '긴급 여부' AFTER `is_featured`;

-- 12. 인덱스 추가
ALTER TABLE `projects` 
ADD INDEX IF NOT EXISTS `idx_client_id` (`client_id`);

ALTER TABLE `projects` 
ADD INDEX IF NOT EXISTS `idx_is_featured` (`is_featured`);

-- 13. 외래키 제약조건 추가 (client_id)
-- 먼저 외래키가 존재하는지 확인
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

-- 14. 테이블 구조 확인
DESCRIBE projects;