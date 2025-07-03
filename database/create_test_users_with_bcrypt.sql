-- Delete existing test users
DELETE FROM users WHERE username IN ('admin', 'test1', 'test2');

-- Create admin user with password 'admin123'
-- BCrypt hash: $2a$10$ty3K73EU8yG5GoLfBz4x..yd/tlM4tLdi.OcJruMAg6A7qqQMJ94e
INSERT INTO users (username, email, password_hash, name, role, status, is_active, created_at, updated_at)
VALUES (
    'admin',
    'admin@example.com',
    '$2a$10$ty3K73EU8yG5GoLfBz4x..yd/tlM4tLdi.OcJruMAg6A7qqQMJ94e',
    'Administrator',
    'admin',
    'active',
    1,
    NOW(),
    NOW()
);

-- Create test1 user with password 'test123'
-- BCrypt hash generated separately
INSERT INTO users (username, email, password_hash, name, role, status, is_active, created_at, updated_at)
VALUES (
    'test1',
    'test1@example.com',
    '$2a$10$4aH7A8SqFL6F9KD6N8pQnOKgD5VXzQdNpD9YWaPCuqGqJwEgNnFXe',
    'Test User 1',
    'freelancer',
    'active',
    1,
    NOW(),
    NOW()
);

-- Create test2 user with password 'password'
-- BCrypt hash: $2a$10$eXoKmj6HR1wDvQJUZ8g9OuLEbrCr5ZkPfAqUoSFpD8DH7WtBPBKgC
INSERT INTO users (username, email, password_hash, name, role, status, is_active, created_at, updated_at)
VALUES (
    'test2',
    'test2@example.com',
    '$2a$10$eXoKmj6HR1wDvQJUZ8g9OuLEbrCr5ZkPfAqUoSFpD8DH7WtBPBKgC',
    'Test User 2',
    'client',
    'active',
    1,
    NOW(),
    NOW()
);

-- Verify the users were created
SELECT id, username, email, name, role, status, LEFT(password_hash, 20) as password_preview
FROM users 
WHERE username IN ('admin', 'test1', 'test2');