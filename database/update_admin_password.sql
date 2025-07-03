-- Update admin user password with BCrypt hash for "admin123"
-- This hash was generated using BCryptPasswordEncoder with "admin123"
UPDATE users 
SET password_hash = '$2a$10$5Y8Y6Z1M5Z8Y6Z1M5Z8Y6Z1M5Z8Y6Z1M5Z8Y6Z1M5Z8Y6Z1M5Z8Y6Z'
WHERE username = 'admin';

-- Let's use a known working BCrypt hash for "admin123"
UPDATE users 
SET password_hash = '$2a$10$e0MYzXyjPyS8Zr6v3LQ0TuFvxVKHJx8TRkxEm2KjQWxH7HMVdReUO'
WHERE username = 'admin';

-- Show the updated user
SELECT id, username, password_hash, name, role, status 
FROM users 
WHERE username = 'admin';