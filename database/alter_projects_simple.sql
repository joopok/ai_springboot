-- projects 테이블에 누락된 컬럼 추가하기

USE jobtracker;

-- budget_type 컬럼 추가
ALTER TABLE projects 
ADD COLUMN budget_type ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입';

-- 다른 누락된 컬럼들도 추가
ALTER TABLE projects 
ADD COLUMN client_id INT DEFAULT NULL COMMENT '프로젝트 등록 사용자';

ALTER TABLE projects 
ADD COLUMN category VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리';

ALTER TABLE projects 
ADD COLUMN start_date DATE DEFAULT NULL COMMENT '시작 예정일';

ALTER TABLE projects 
ADD COLUMN preferred_skills JSON DEFAULT NULL COMMENT '우대 기술 (JSON 배열)';

ALTER TABLE projects 
ADD COLUMN experience_years INT DEFAULT 0 COMMENT '요구 경력 연수';

ALTER TABLE projects 
ADD COLUMN experience_level ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력';

ALTER TABLE projects 
ADD COLUMN applications INT DEFAULT 0 COMMENT '지원자수';

ALTER TABLE projects 
ADD COLUMN applications_count INT GENERATED ALWAYS AS (applications) VIRTUAL COMMENT '지원자수 별칭';

ALTER TABLE projects 
ADD COLUMN is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 여부';

ALTER TABLE projects 
ADD COLUMN is_urgent BOOLEAN DEFAULT FALSE COMMENT '긴급 여부';

-- 테이블 구조 확인
SHOW COLUMNS FROM projects;