-- Create a test user with a known BCrypt password
-- Password: admin123
-- BCrypt hash generated with Spring Security BCryptPasswordEncoder

-- First, delete existing admin user if exists
DELETE FROM users WHERE username = 'admin';

-- Insert new admin user with BCrypt hashed password for "admin123"
INSERT INTO users (username, email, password_hash, name, role, status, is_active, created_at, updated_at)
VALUES (
    'admin',
    'admin@example.com',
    '$2a$10$tQrGP0yW6BKFwW2Y5FXqAOd3lA3QWx2irAuqIsFnvUEBAlDZZjP/e',
    'Administrator',
    'admin',
    'active',
    1,
    NOW(),
    NOW()
);

-- Verify the user was created
SELECT id, username, password_hash, name, role, status 
FROM users 
WHERE username = 'admin';