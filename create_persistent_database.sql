-- Create DB_Rmart database if not exists
CREATE DATABASE "DB_Rmart" WITH ENCODING 'UTF8';

-- Connect to DB_Rmart
\c "DB_Rmart";

-- Create tables with proper structure
CREATE TABLE IF NOT EXISTS jenis_barang (
    id SERIAL PRIMARY KEY,
    nama_jenis VARCHAR(50) NOT NULL,
    image TEXT,
    icon_color VARCHAR(20),
    icon VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS barang (
    id SERIAL PRIMARY KEY,
    nama_barang TEXT NOT NULL,
    jenis_id INTEGER REFERENCES jenis_barang(id),
    harga_jual NUMERIC(10,2),
    stok INTEGER,
    gambar_url TEXT,
    gambar TEXT
);

CREATE TABLE IF NOT EXISTS customer (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    is_member BOOLEAN DEFAULT false,
    poin INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    created_at TIMESTAMP(6) NOT NULL,
    active BOOLEAN NOT NULL,
    full_name VARCHAR(255),
    last_login TIMESTAMP(6),
    username VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    total_amount NUMERIC(10,2),
    status VARCHAR(255),
    created_at TIMESTAMP(6),
    updated_at TIMESTAMP(6)
);

-- Insert default categories
INSERT INTO jenis_barang (nama_jenis, image, icon_color, icon) VALUES
('Kebutuhan Dapur', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', '#FF6B35', '🍳'),
('Kebutuhan Ibu & Anak', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', '#FF69B4', '👶'),
('Personal Care', 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', '#AB47BC', '🧴'),
('Kebutuhan Rumah', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400', '#4CAF50', '🏠'),
('Makanan', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', '#FFA726', '🍽️'),
('Minuman', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', '#42A5F5', '🥤'),
('Produk Segar & Beku', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400', '#66BB6A', '🥬'),
('Kebutuhan Kesehatan', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400', '#EF5350', '💊'),
('Lifestyle', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400', '#5C6BC0', '✨'),
('Pet Foods', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400', '#8D6E63', '🐕')
ON CONFLICT DO NOTHING;

-- Insert sample products
INSERT INTO barang (nama_barang, jenis_id, harga_jual, stok, gambar_url, gambar) VALUES
('Aqua Botol 600ml', 6, 4000.00, 100, 'aqua_600ml.jpg', 'aqua_600ml.jpg'),
('Indomie Goreng', 5, 3000.00, 200, 'indomie_goreng.jpg', 'indomie_goreng.jpg'),
('Rinso 1kg', 4, 18000.00, 50, 'rinso_1kg.jpg', 'rinso_1kg.jpg'),
('Shampoo Lifebuoy', 3, 15000.00, 70, 'lifebuoy_shampoo.jpg', 'lifebuoy_shampoo.jpg')
ON CONFLICT DO NOTHING;

-- Insert sample customer
INSERT INTO customer (nama, email, is_member, poin) VALUES
('Budi', 'budi@mail.com', true, 120)
ON CONFLICT (email) DO NOTHING;

-- Insert admin user
INSERT INTO users (name, email, password, role, created_at, active, username) VALUES
('Administrator', 'admin@rmart.com', 'admin123', 'admin', NOW(), true, 'administrator')
ON CONFLICT (email) DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_barang_jenis_id ON barang(jenis_id);
CREATE INDEX IF NOT EXISTS idx_barang_nama ON barang(nama_barang);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);