#!/bin/bash

# Script to ensure DB_Rmart database always exists
echo "🔍 Checking DB_Rmart database..."

# Check if database exists
DB_EXISTS=$(psql -h localhost -U postgres -lqt | cut -d \| -f 1 | grep -w "DB_Rmart" | wc -l)

if [ $DB_EXISTS -eq 0 ]; then
    echo "❌ DB_Rmart not found. Creating database..."
    psql -h localhost -U postgres -c "CREATE DATABASE \"DB_Rmart\";"
    echo "✅ DB_Rmart database created."
else
    echo "✅ DB_Rmart database exists."
fi

# Ensure tables exist
echo "🔧 Ensuring tables exist..."
psql -h localhost -U postgres -d DB_Rmart -c "
-- Create tables if not exist
CREATE TABLE IF NOT EXISTS jenis_barang (
    id SERIAL PRIMARY KEY,
    nama_jenis VARCHAR(50) NOT NULL,
    image TEXT,
    icon_color VARCHAR(50),
    icon VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS barang (
    id SERIAL PRIMARY KEY,
    nama_barang TEXT NOT NULL,
    jenis_id INTEGER REFERENCES jenis_barang(id),
    harga_jual NUMERIC(10,2),
    stok INTEGER,
    gambar TEXT,
    gambar_url TEXT
);

CREATE TABLE IF NOT EXISTS customer (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    email VARCHAR(100),
    is_member BOOLEAN DEFAULT false,
    poin INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    active BOOLEAN DEFAULT true,
    full_name VARCHAR(255),
    last_login TIMESTAMP,
    username VARCHAR(255) UNIQUE
);

-- Ensure admin user exists
INSERT INTO users (name, email, password, role, created_at, active, username) VALUES
('Administrator', 'admin@rmart.com', 'admin123', 'admin', NOW(), true, 'administrator')
ON CONFLICT (email) DO UPDATE SET password = 'admin123', active = true;

-- Ensure basic categories exist
INSERT INTO jenis_barang (id, nama_jenis, image, icon_color, icon) VALUES
(1, 'Kebutuhan Dapur', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', '#FF6B35', '🍳'),
(2, 'Kebutuhan Ibu & Anak', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', '#FF69B4', '👶'),
(3, 'Personal Care', 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', '#AB47BC', '🧴'),
(4, 'Kebutuhan Rumah', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400', '#4CAF50', '🏠'),
(5, 'Makanan', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', '#FFA726', '🍽️'),
(6, 'Minuman', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', '#42A5F5', '🥤')
ON CONFLICT (id) DO UPDATE SET 
nama_jenis = EXCLUDED.nama_jenis,
image = EXCLUDED.image,
icon_color = EXCLUDED.icon_color,
icon = EXCLUDED.icon;
"

echo "✅ Database setup complete!"
echo "📊 Database status:"
psql -h localhost -U postgres -d DB_Rmart -c "
SELECT 'Categories: ' || COUNT(*) FROM jenis_barang;
SELECT 'Products: ' || COUNT(*) FROM barang;
SELECT 'Customers: ' || COUNT(*) FROM customer;
SELECT 'Users: ' || COUNT(*) FROM users;
"