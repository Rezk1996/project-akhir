-- Ensure address column exists in users table
-- This script will add the address column if it doesn't exist

DO $$
BEGIN
    -- Check if address column exists, if not add it
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'address'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE users ADD COLUMN address TEXT;
        RAISE NOTICE 'Address column added to users table';
    ELSE
        RAISE NOTICE 'Address column already exists in users table';
    END IF;
END $$;

-- Verify the column exists
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name = 'address'
AND table_schema = 'public';