-- budget_type 컬럼만 먼저 추가
ALTER TABLE projects ADD COLUMN budget_type ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입';