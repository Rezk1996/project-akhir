-- Fix: Add missing 'active' column to products table
-- This column is required by the Product entity but missing from database schema

-- Check if column exists first
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'products' 
        AND column_name = 'active'
    ) THEN
        -- Add the active column
        ALTER TABLE products ADD COLUMN active BOOLEAN NOT NULL DEFAULT true;
        
        -- Update existing products to be active
        UPDATE products SET active = true WHERE active IS NULL;
        
        RAISE NOTICE 'Added active column to products table';
    ELSE
        RAISE NOTICE 'Active column already exists in products table';
    END IF;
END
$$;

-- Verify the column was added
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'products' 
AND column_name = 'active';