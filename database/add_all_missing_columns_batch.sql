-- projects 테이블에 누락된 모든 컬럼을 한번에 추가

ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS client_id INT DEFAULT NULL COMMENT '프로젝트 등록 사용자',
ADD COLUMN IF NOT EXISTS category VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리',
ADD COLUMN IF NOT EXISTS budget_type ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입',
ADD COLUMN IF NOT EXISTS start_date DATE DEFAULT NULL COMMENT '시작 예정일',
ADD COLUMN IF NOT EXISTS preferred_skills JSON DEFAULT NULL COMMENT '우대 기술 (JSON 배열)',
ADD COLUMN IF NOT EXISTS experience_years INT DEFAULT 0 COMMENT '요구 경력 연수',
ADD COLUMN IF NOT EXISTS experience_level ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력',
ADD COLUMN IF NOT EXISTS applications INT DEFAULT 0 COMMENT '지원자수',
ADD COLUMN IF NOT EXISTS applications_count INT GENERATED ALWAYS AS (applications) VIRTUAL COMMENT '지원자수 별칭',
ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 여부',
ADD COLUMN IF NOT EXISTS is_urgent BOOLEAN DEFAULT FALSE COMMENT '긴급 여부';