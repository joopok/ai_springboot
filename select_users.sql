-- 최근 가입한 사용자 순으로 조회
SELECT 
    username,
    email,
    created_at,
    updated_at
FROM users
ORDER BY created_at DESC


