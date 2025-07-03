-- Add freelancer_type column to freelancers table
ALTER TABLE freelancers 
ADD COLUMN freelancer_type ENUM('PM/PL', 'PMO', '개발자', '기획자', '퍼블리셔', '디자이너', '기타') 
DEFAULT '개발자' 
COMMENT '프리랜서 직종' 
AFTER title;

-- Add index for better query performance
ALTER TABLE freelancers 
ADD INDEX idx_freelancer_type (freelancer_type);

-- Update existing freelancers with appropriate types based on their titles
UPDATE freelancers 
SET freelancer_type = CASE
    WHEN title LIKE '%PM%' OR title LIKE '%프로젝트%매니저%' OR title LIKE '%PL%' THEN 'PM/PL'
    WHEN title LIKE '%PMO%' THEN 'PMO'
    WHEN title LIKE '%개발%' OR title LIKE '%Developer%' OR title LIKE '%Engineer%' OR title LIKE '%프로그래머%' THEN '개발자'
    WHEN title LIKE '%기획%' OR title LIKE '%Planner%' OR title LIKE '%서비스%기획%' THEN '기획자'
    WHEN title LIKE '%퍼블리%' OR title LIKE '%Publisher%' OR title LIKE '%마크업%' THEN '퍼블리셔'
    WHEN title LIKE '%디자이%' OR title LIKE '%Designer%' OR title LIKE '%UI%' OR title LIKE '%UX%' THEN '디자이너'
    ELSE '기타'
END
WHERE freelancer_type IS NULL OR freelancer_type = '개발자';

-- Show the distribution of freelancer types
SELECT freelancer_type, COUNT(*) as count 
FROM freelancers 
GROUP BY freelancer_type;