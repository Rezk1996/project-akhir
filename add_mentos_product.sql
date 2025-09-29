-- Add Mentos product to test category mapping

-- First, ensure Makanan category exists
INSERT INTO categories (name, description, icon, icon_color, created_at, updated_at) 
VALUES ('Makanan', 'Kategori makanan dan minuman', '🍽️', '#FF6B35', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Add Mentos product
INSERT INTO products (name, price, image, stock, category_id, description, rating, discount, sold, created_at, updated_at)
VALUES (
    'Mentos perment mint roll 37 g',
    5000,
    'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=300',
    100,
    (SELECT id FROM categories WHERE name = 'Makanan'),
    'Permen mint segar Mentos dalam kemasan roll 37 gram',
    4.5,
    0,
    25,
    NOW(),
    NOW()
);

-- Verify the product was added correctly
SELECT 'Product added successfully:' as info;
SELECT p.id, p.name, p.category_id, c.name as category_name 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.id 
WHERE p.name ILIKE '%mentos%';