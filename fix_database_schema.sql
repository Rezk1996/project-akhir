-- Fix database schema: Add missing address column
ALTER TABLE users ADD COLUMN IF NOT EXISTS address TEXT;

-- Verify the fix
\d users;