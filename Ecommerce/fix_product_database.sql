-- Script untuk memperbaiki ketidaksesuaian produk database dengan ecommerce

-- 1. Pastikan tabel categories memiliki data yang diperlukan
INSERT INTO categories (name, image, icon_color) VALUES 
('Electronics', '/images/categories/electronics.jpg', '#FF6B6B'),
('Fashion', '/images/categories/fashion.jpg', '#4ECDC4'),
('Home & Garden', '/images/categories/home.jpg', '#45B7D1'),
('Sports', '/images/categories/sports.jpg', '#96CEB4'),
('Books', '/images/categories/books.jpg', '#FFEAA7'),
('Beauty', '/images/categories/beauty.jpg', '#DDA0DD'),
('Toys', '/images/categories/toys.jpg', '#98D8C8'),
('Automotive', '/images/categories/automotive.jpg', '#F7DC6F')
ON CONFLICT (name) DO NOTHING;

-- 2. Update produk yang memiliki category_id NULL dengan kategori default
UPDATE products 
SET category_id = (SELECT id FROM categories WHERE name = 'Electronics' LIMIT 1)
WHERE category_id IS NULL;

-- 3. Pastikan semua produk memiliki rating yang valid (antara 0.0 dan 5.0)
UPDATE products 
SET rating = CASE 
    WHEN rating IS NULL THEN 0.0
    WHEN rating < 0.0 THEN 0.0
    WHEN rating > 5.0 THEN 5.0
    ELSE rating
END;

-- 4. Pastikan semua produk memiliki stock yang valid (tidak negatif)
UPDATE products 
SET stock = CASE 
    WHEN stock IS NULL THEN 0
    WHEN stock < 0 THEN 0
    ELSE stock
END;

-- 5. Pastikan semua produk memiliki sold yang valid (tidak negatif)
UPDATE products 
SET sold = CASE 
    WHEN sold IS NULL THEN 0
    WHEN sold < 0 THEN 0
    ELSE sold
END;

-- 6. Pastikan semua produk memiliki discount yang valid (0-100)
UPDATE products 
SET discount = CASE 
    WHEN discount IS NULL THEN 0
    WHEN discount < 0 THEN 0
    WHEN discount > 100 THEN 100
    ELSE discount
END;

-- 7. Update original_price berdasarkan price dan discount jika NULL
UPDATE products 
SET original_price = CASE 
    WHEN original_price IS NULL AND discount > 0 THEN 
        ROUND(price / (1 - discount::decimal / 100), 2)
    WHEN original_price IS NULL THEN price
    ELSE original_price
END;

-- 8. Pastikan created_at dan updated_at tidak NULL
UPDATE products 
SET created_at = COALESCE(created_at, NOW()),
    updated_at = COALESCE(updated_at, NOW());

-- 9. Bersihkan data yang tidak konsisten
DELETE FROM products WHERE name IS NULL OR name = '';
DELETE FROM products WHERE price IS NULL OR price <= 0;

-- 10. Verifikasi data
SELECT 
    COUNT(*) as total_products,
    COUNT(CASE WHEN category_id IS NOT NULL THEN 1 END) as products_with_category,
    COUNT(CASE WHEN rating BETWEEN 0 AND 5 THEN 1 END) as valid_ratings,
    COUNT(CASE WHEN stock >= 0 THEN 1 END) as valid_stock,
    COUNT(CASE WHEN price > 0 THEN 1 END) as valid_prices
FROM products;

-- 11. Tampilkan sample data untuk verifikasi
SELECT 
    p.id,
    p.name,
    p.price,
    p.original_price,
    p.discount,
    p.stock,
    p.rating,
    p.sold,
    c.name as category_name,
    p.category_id
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LIMIT 10;