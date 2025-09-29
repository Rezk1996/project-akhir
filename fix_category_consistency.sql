-- Fix Category Consistency
-- Ensure all products have valid category_id

-- Check current state
SELECT 'Current product-category mapping:' as info;
SELECT 
    p.id, 
    p.name, 
    p.category_id, 
    c.name as category_name,
    CASE 
        WHEN c.name IS NULL THEN 'MISSING CATEGORY'
        ELSE 'OK'
    END as status
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
ORDER BY p.id 
LIMIT 10;

-- Find products with invalid category_id
SELECT 'Products with invalid category_id:' as info;
SELECT p.id, p.name, p.category_id
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
WHERE c.id IS NULL AND p.category_id IS NOT NULL;

-- Find products with NULL category_id
SELECT 'Products with NULL category_id:' as info;
SELECT p.id, p.name, p.category_id
FROM products p 
WHERE p.category_id IS NULL;

-- Fix products with NULL category_id - assign to default category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE category_id IS NULL;

-- Fix products with invalid category_id - assign to default category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE category_id NOT IN (SELECT id FROM categories);

-- Final verification
SELECT 'Final verification:' as info;
SELECT 
    p.id, 
    p.name, 
    p.category_id, 
    c.name as category_name
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
ORDER BY p.id 
LIMIT 5;