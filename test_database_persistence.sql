-- Test database persistence
-- Check if updates are actually saved to database

-- Before update - check current data
SELECT id, name, email, phone, address, updated_at 
FROM users 
WHERE email != 'test@example.com' 
ORDER BY updated_at DESC;

-- After running update, check if data changed
-- Run this query after profile update to verify persistence
SELECT id, name, email, phone, address, updated_at 
FROM users 
WHERE email != 'test@example.com' 
ORDER BY updated_at DESC;