-- Update existing products to have proper categories
-- This will fix the N/A category issue

-- Update Oops Pops Crackers to Makanan category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE name LIKE '%Oops Pops Crackers%' AND category_id IS NULL;

-- Update Bango Kecap to Kebutuhan Dapur category  
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Kebutuhan Dapur' LIMIT 1)
WHERE name LIKE '%Bango Kecap%' AND category_id IS NULL;

-- Update Mentos to Makanan category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE name LIKE '%Mentos%' AND category_id IS NULL;

-- Update Adem Sari to Minuman category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Minuman' LIMIT 1)
WHERE name LIKE '%Adem Sari%' AND category_id IS NULL;

-- Update any remaining products without category to Makanan
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE category_id IS NULL;

-- Verify the updates
SELECT p.id, p.name, c.name as category_name 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
ORDER BY p.id;