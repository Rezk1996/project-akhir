-- Sample products untuk testing delete functionality

INSERT INTO products (name, price, original_price, discount, image, description, rating, sold, stock, category_id) VALUES
('Indomie Goreng', 3500, 4000, 13, 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400', 'Mie instan goreng rasa original yang lezat', 4.5, 150, 100, 1),
('Beras Premium 5kg', 65000, 70000, 7, 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'Beras premium kualitas terbaik untuk keluarga', 4.7, 80, 50, 1),
('Susu Ultra Milk 1L', 18500, NULL, 0, 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400', 'Susu segar berkualitas tinggi', 4.6, 200, 75, 1),
('Sabun Mandi Lifebuoy', 5500, 6000, 8, 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', 'Sabun mandi antibakteri untuk perlindungan keluarga', 4.3, 120, 200, 2),
('Shampo Pantene 170ml', 18000, 20000, 10, 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400', 'Shampo untuk rambut sehat dan berkilau', 4.4, 90, 60, 3);

SELECT 'Sample products added successfully!' as status;
SELECT COUNT(*) as total_products FROM products;