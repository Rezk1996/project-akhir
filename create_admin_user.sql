-- Create admin user for dashboard login
-- Password: admin123 (bcrypt hashed)

INSERT INTO users (name, email, password, role, created_at, updated_at) 
VALUES (
    'Admin User', 
    'admin@rmart.com', 
    '$2a$10$N9qo8uLOickgx2ZMRZoMye/Zt.flw.zfzIEGwMZjAu1XVpQQqyPGy', 
    'admin', 
    NOW(), 
    NOW()
) 
ON CONFLICT (email) DO UPDATE SET
    password = EXCLUDED.password,
    role = EXCLUDED.role,
    updated_at = NOW();

-- Verify the admin user was created
SELECT id, name, email, role, created_at FROM users WHERE email = 'admin@rmart.com';