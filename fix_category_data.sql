-- Fix Category Data
-- Ensure categories exist and products have correct category_id

-- Check current categories
SELECT 'Current Categories:' as info;
SELECT id, name FROM categories ORDER BY id;

-- Check products without category
SELECT 'Products without category:' as info;
SELECT id, name, category_id FROM products WHERE category_id IS NULL;

-- Insert missing categories if they don't exist
INSERT INTO categories (name, description, icon, icon_color, created_at, updated_at) 
VALUES 
    ('Makanan', 'Kategori makanan dan minuman', '🍽️', '#FF6B35', NOW(), NOW()),
    ('Minuman', 'Kategori minuman segar', '🥤', '#4ECDC4', NOW(), NOW()),
    ('Elektronik', 'Kategori perangkat elektronik', '📱', '#45B7D1', NOW(), NOW()),
    ('Pakaian', 'Kategori pakaian dan fashion', '👕', '#96CEB4', NOW(), NOW()),
    ('Rumah Tangga', 'Kategori peralatan rumah tangga', '🏠', '#FFEAA7', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Update products that have NULL category_id to default category
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1)
WHERE category_id IS NULL;

-- Show final result
SELECT 'Final check - Products with categories:' as info;
SELECT p.id, p.name, p.category_id, c.name as category_name 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
ORDER BY p.id 
LIMIT 10;