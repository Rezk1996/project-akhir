-- Add images column to products table
ALTER TABLE products ADD COLUMN images TEXT;

-- Update existing products to have images field based on image field
UPDATE products SET images = image WHERE image IS NOT NULL AND image != '';

-- Show updated table structure
DESCRIBE products;