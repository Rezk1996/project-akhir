-- Add Indonesian categories that match the e-commerce website
-- First, let's clear existing categories if needed and add the correct ones

-- Insert Indonesian categories that match the e-commerce frontend
INSERT INTO categories (name, image, icon_color) VALUES
('Makanan', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', '#FF6B6B'),
('Minuman & Beverage', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', '#4ECDC4'),
('Kebutuhan Ibu & Anak', 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400', '#45B7D1'),
('Personal Care', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400', '#96CEB4'),
('Household', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', '#FFEAA7'),
('Elektronik', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400', '#6C5CE7'),
('Fashion', 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400', '#FD79A8'),
('Kesehatan', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400', '#00B894')
ON CONFLICT (name) DO UPDATE SET
    image = EXCLUDED.image,
    icon_color = EXCLUDED.icon_color;

-- Update existing products to use the new categories
-- This assumes some products might already exist with the old category IDs

-- Update products to match Indonesian categories
UPDATE products SET category_id = (SELECT id FROM categories WHERE name = 'Elektronik' LIMIT 1) 
WHERE category_id IN (SELECT id FROM categories WHERE name = 'Electronics');

UPDATE products SET category_id = (SELECT id FROM categories WHERE name = 'Fashion' LIMIT 1) 
WHERE category_id IN (SELECT id FROM categories WHERE name = 'Fashion');

UPDATE products SET category_id = (SELECT id FROM categories WHERE name = 'Household' LIMIT 1) 
WHERE category_id IN (SELECT id FROM categories WHERE name = 'Home');

-- Add some sample products for Indonesian categories
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id, sold) VALUES
('Indomie Goreng (5 pcs)', 12000, 15000, 20, 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400', 'Mie instan goreng rasa original yang lezat', 4.8, 100, (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1), 250),
('Susu Ultra Milk 1L', 18000, 20000, 10, 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400', 'Susu segar berkualitas tinggi', 4.5, 80, (SELECT id FROM categories WHERE name = 'Minuman & Beverage' LIMIT 1), 180),
('Pampers Baby Dry Size M', 85000, 95000, 11, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400', 'Popok bayi dengan daya serap tinggi', 4.7, 50, (SELECT id FROM categories WHERE name = 'Kebutuhan Ibu & Anak' LIMIT 1), 120),
('Shampoo Pantene 340ml', 28000, 32000, 13, 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400', 'Shampoo untuk rambut sehat dan berkilau', 4.4, 75, (SELECT id FROM categories WHERE name = 'Personal Care' LIMIT 1), 95),
('Sabun Cuci Piring Sunlight 750ml', 15000, 18000, 17, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', 'Sabun cuci piring dengan formula anti bakteri', 4.3, 120, (SELECT id FROM categories WHERE name = 'Household' LIMIT 1), 200),
('Roti Tawar Sari Roti', 8000, 10000, 20, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400', 'Roti tawar segar untuk sarapan', 4.2, 60, (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1), 150),
('Teh Botol Sosro 450ml', 5000, 6000, 17, 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', 'Teh manis segar dalam kemasan botol', 4.6, 200, (SELECT id FROM categories WHERE name = 'Minuman & Beverage' LIMIT 1), 300),
('Vitamin C Blackmores', 125000, 140000, 11, 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400', 'Suplemen vitamin C untuk daya tahan tubuh', 4.5, 40, (SELECT id FROM categories WHERE name = 'Kesehatan' LIMIT 1), 85);

-- Add some more variety
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id, sold) VALUES
('Biskuit Oreo Original', 12000, 14000, 14, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400', 'Biskuit sandwich dengan krim vanilla', 4.7, 90, (SELECT id FROM categories WHERE name = 'Makanan' LIMIT 1), 220),
('Kopi Kapal Api Special Mix', 25000, 28000, 11, 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', 'Kopi instan dengan rasa yang khas', 4.4, 70, (SELECT id FROM categories WHERE name = 'Minuman & Beverage' LIMIT 1), 160),
('Deterjen Rinso 800g', 22000, 25000, 12, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', 'Deterjen bubuk untuk pakaian bersih', 4.3, 85, (SELECT id FROM categories WHERE name = 'Household' LIMIT 1), 140),
('Pasta Gigi Pepsodent', 8500, 10000, 15, 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400', 'Pasta gigi untuk gigi sehat dan kuat', 4.2, 110, (SELECT id FROM categories WHERE name = 'Personal Care' LIMIT 1), 190);