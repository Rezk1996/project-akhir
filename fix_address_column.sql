-- Fix: Add missing address column to users table
-- This column is referenced in the Java entity but missing from database schema

ALTER TABLE users ADD COLUMN IF NOT EXISTS address TEXT;

-- Update the updated_at timestamp for any existing users
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE address IS NULL;

-- Verify the column was added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'address';