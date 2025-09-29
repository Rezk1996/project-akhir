-- Fix admin password with BCrypt hash
-- BCrypt hash for 'admin123' with strength 10
UPDATE users 
SET password = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.' 
WHERE email = 'admin@rmart.com';

-- Verify the update
SELECT id, name, email, password, role FROM users WHERE email = 'admin@rmart.com';