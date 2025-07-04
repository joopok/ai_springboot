#!/bin/bash

# MariaDB 연결 정보
HOST="192.168.0.109"
USER="root"
PASS="~Asy10131227"
DB="jobtracker"

# 각 컬럼을 개별적으로 추가 (이미 있으면 무시)
echo "Adding missing columns to projects table..."

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS client_id INT DEFAULT NULL COMMENT '프로젝트 등록 사용자';" 2>/dev/null
echo "✓ client_id"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS category VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리';" 2>/dev/null
echo "✓ category"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS budget_type ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입';" 2>/dev/null
echo "✓ budget_type"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS start_date DATE DEFAULT NULL COMMENT '시작 예정일';" 2>/dev/null
echo "✓ start_date"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS preferred_skills JSON DEFAULT NULL COMMENT '우대 기술 (JSON 배열)';" 2>/dev/null
echo "✓ preferred_skills"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS experience_years INT DEFAULT 0 COMMENT '요구 경력 연수';" 2>/dev/null
echo "✓ experience_years"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS experience_level ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력';" 2>/dev/null
echo "✓ experience_level"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS applications INT DEFAULT 0 COMMENT '지원자수';" 2>/dev/null
echo "✓ applications"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS applications_count INT GENERATED ALWAYS AS (applications) VIRTUAL COMMENT '지원자수 별칭';" 2>/dev/null
echo "✓ applications_count"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 여부';" 2>/dev/null
echo "✓ is_featured"

mysql -h $HOST -u $USER -p"$PASS" $DB -e "ALTER TABLE projects ADD COLUMN IF NOT EXISTS is_urgent BOOLEAN DEFAULT FALSE COMMENT '긴급 여부';" 2>/dev/null
echo "✓ is_urgent"

echo ""
echo "All columns added successfully!"
echo ""
echo "Checking table structure..."
mysql -h $HOST -u $USER -p"$PASS" $DB -e "DESCRIBE projects;"