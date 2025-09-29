-- Sync categories between frontend and admin dashboard
-- This script will update the database to match the frontend categories

-- First, clear existing categories
DELETE FROM categories;

-- Insert the categories that match the frontend display
INSERT INTO categories (name, description, icon, icon_color, image, created_at, updated_at) VALUES
('Kebutuhan Dapur', 'Peralatan dan kebutuhan untuk dapur Anda', '🥘', '#FF6B35', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', NOW(), NOW()),
('Kebutuhan Ibu & Anak', 'Produk untuk ibu dan anak', '🍼', '#FF69B4', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', NOW(), NOW()),
('Kebutuhan Rumah', 'Peralatan dan kebutuhan rumah tangga', '🧽', '#4CAF50', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', NOW(), NOW()),
('Makanan', 'Berbagai jenis makanan dan snacks', '🍞', '#FF9800', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', NOW(), NOW()),
('Produk Segar & Beku', 'Produk segar dan makanan beku', '🥬', '#00BCD4', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400', NOW(), NOW()),
('Personal Care', 'Produk perawatan pribadi', '🧴', '#9C27B0', 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', NOW(), NOW()),
('Kebutuhan Kesehatan', 'Produk kesehatan dan vitamin', '💊', '#F44336', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400', NOW(), NOW()),
('Lifestyle', 'Produk gaya hidup dan fashion', '👕', '#607D8B', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400', NOW(), NOW()),
('Pet Foods', 'Makanan dan kebutuhan hewan peliharaan', '🦴', '#795548', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400', NOW(), NOW()),
('Minuman & Beverage', 'Berbagai jenis minuman', '🧃', '#2196F3', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', NOW(), NOW());

-- Update existing products to use the new category names
-- Map old category names to new ones
UPDATE products SET category = 'Makanan' WHERE category IN ('Makanan & Snacks', 'makanan');
UPDATE products SET category = 'Minuman & Beverage' WHERE category IN ('Minuman & Beverages', 'minuman');
UPDATE products SET category = 'Kebutuhan Rumah' WHERE category IN ('Kebutuhan Rumah Tangga', 'rumah tangga');
UPDATE products SET category = 'Personal Care' WHERE category IN ('Perawatan', 'perawatan');

-- Verify the sync
SELECT 'Categories after sync:' as status;
SELECT id, name, icon, icon_color FROM categories ORDER BY id;

SELECT 'Product categories after sync:' as status;
SELECT DISTINCT category, COUNT(*) as product_count FROM products GROUP BY category ORDER BY category;