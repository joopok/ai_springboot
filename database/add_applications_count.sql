-- applications_count 가상 컬럼 추가
-- 먼저 applications 컬럼이 있는지 확인하고 없으면 추가
ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS applications INT DEFAULT 0 COMMENT '지원자수';

-- applications_count 가상 컬럼 추가
ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS applications_count INT GENERATED ALWAYS AS (applications) VIRTUAL COMMENT '지원자수 별칭';