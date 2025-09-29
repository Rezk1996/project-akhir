-- Add sample users to match admin dashboard expectations
INSERT INTO users (name, email, password, role, phone, address, created_at, updated_at) VALUES
('Test User', 'testuser@example.com', '$2a$10$dummy.hash.for.testing', 'customer', '081234567890', 'Jl. Test No. 123', '2025-07-29 20:16:05.862434', NOW()),
('rezki', 'rezki@mail.com', '$2a$10$dummy.hash.for.testing', 'customer', '081234567891', 'Jl. Rezki No. 456', '2025-07-29 20:19:38.910168', NOW()),
('nisa', 'nisa@yahoo.com', '$2a$10$dummy.hash.for.testing', 'customer', '081234567892', 'Jl. Nisa No. 789', '2025-08-24 16:50:44.229191', NOW()),
('ilal', 'ilal@mail.com', '$2a$10$dummy.hash.for.testing', 'customer', '081234567893', 'Jl. Ilal No. 101', '2025-08-23 20:17:14.284919', NOW())
ON CONFLICT (email) DO NOTHING;

-- Verify users were added
SELECT 'Users after adding samples:' as status;
SELECT id, name, email, role, phone FROM users ORDER BY id;