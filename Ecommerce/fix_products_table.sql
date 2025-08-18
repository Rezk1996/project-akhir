-- Script untuk memperbaiki struktur tabel products agar sesuai dengan entity Java

-- Backup data yang ada
CREATE TEMP TABLE products_backup AS SELECT * FROM products;

-- Drop tabel products dan buat ulang dengan struktur yang benar
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price > 0),
    original_price NUMERIC(12,2),
    discount INTEGER DEFAULT 0,
    image VARCHAR(500),
    description TEXT,
    rating NUMERIC(2,1) DEFAULT 0.0 CHECK (rating BETWEEN 0 AND 5),
    sold INTEGER DEFAULT 0,
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Restore data dengan mapping category name ke category_id
INSERT INTO products (name, price, original_price, discount, image, description, rating, sold, stock, category_id, created_at, updated_at)
SELECT 
    pb.name,
    pb.price,
    pb.original_price,
    pb.discount,
    pb.image,
    pb.description,
    pb.rating,
    pb.sold,
    pb.stock,
    c.id as category_id,
    pb.created_at,
    pb.updated_at
FROM products_backup pb
LEFT JOIN categories c ON c.name = pb.category;

-- Buat trigger untuk update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Tampilkan hasil
SELECT 'Products table structure fixed successfully!' as status;
SELECT COUNT(*) as total_products FROM products;