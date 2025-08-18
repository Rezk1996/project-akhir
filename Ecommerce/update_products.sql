-- Update existing products and add new ones for new categories
DELETE FROM products;

-- Kebutuhan Dapur (ID: 6)
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('Rice Cooker Digital', 299.99, 349.99, 14, 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', 'Rice cooker digital dengan timer otomatis', 4.5, 25, 6),
('Blender 3 in 1', 149.99, 179.99, 17, 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400', 'Blender multifungsi untuk jus dan smoothie', 4.3, 40, 6),
('Coffee Maker Premium', 199.99, 249.99, 20, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400', 'Mesin kopi otomatis dengan grinder built-in', 4.7, 15, 6);

-- Kebutuhan Ibu & Anak (ID: 7)
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('Baby Stroller Premium', 599.99, 699.99, 14, 'https://images.unsplash.com/photo-1544717302-de2939b7ef71?w=400', 'Stroller bayi dengan sistem keamanan terbaik', 4.8, 12, 7),
('Baby Monitor Wireless', 129.99, 159.99, 19, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400', 'Monitor bayi dengan kamera HD dan audio', 4.6, 30, 7);

-- Makanan (ID: 9)
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('Organic Honey 500ml', 24.99, 29.99, 17, 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', 'Madu organik murni dari lebah hutan', 4.9, 100, 9),
('Premium Olive Oil', 34.99, 39.99, 13, 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400', 'Minyak zaitun extra virgin berkualitas tinggi', 4.7, 80, 9);

-- Personal Care (ID: 12)
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('Skincare Set Complete', 89.99, 109.99, 18, 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', 'Set perawatan kulit lengkap untuk semua jenis kulit', 4.5, 50, 12),
('Electric Toothbrush', 79.99, 99.99, 20, 'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=400', 'Sikat gigi elektrik dengan 5 mode pembersihan', 4.4, 35, 12);

-- Lifestyle (ID: 14)
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('Yoga Mat Premium', 49.99, 59.99, 17, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', 'Matras yoga anti-slip dengan ketebalan optimal', 4.6, 60, 14),
('Bluetooth Speaker', 129.99, 149.99, 13, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400', 'Speaker bluetooth portable dengan bass yang kuat', 4.5, 45, 14);