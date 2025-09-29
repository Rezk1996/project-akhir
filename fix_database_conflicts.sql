-- =====================================================
-- SCRIPT PERBAIKAN DATABASE BENTROK
-- Menghapus tabel legacy dan memperbaiki struktur
-- =====================================================

-- 1. BACKUP DATA PENTING SEBELUM CLEANUP
CREATE TABLE IF NOT EXISTS migration_backup_products AS 
SELECT * FROM barang;

CREATE TABLE IF NOT EXISTS migration_backup_categories AS 
SELECT * FROM jenis_barang;

-- 2. HAPUS VIEWS YANG BENTROK
DROP VIEW IF EXISTS products CASCADE;
DROP VIEW IF EXISTS categories CASCADE;

-- 3. HAPUS TABEL LEGACY YANG BENTROK
DROP TABLE IF EXISTS keranjang CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS transaksi CASCADE;
DROP TABLE IF EXISTS detail_transaksi CASCADE;
DROP TABLE IF EXISTS point_member CASCADE;
DROP TABLE IF EXISTS admin CASCADE;

-- 4. HAPUS TABEL LAIN YANG TIDAK DIPERLUKAN
DROP TABLE IF EXISTS diskon CASCADE;
DROP TABLE IF EXISTS harga_beli CASCADE;
DROP TABLE IF EXISTS stok_keluar CASCADE;
DROP TABLE IF EXISTS stok_masuk CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS target_penjualan CASCADE;
DROP TABLE IF EXISTS tenaga_kerja CASCADE;
DROP TABLE IF EXISTS shift_kerja CASCADE;
DROP TABLE IF EXISTS categories_backup CASCADE;

-- 5. BUAT ULANG STRUKTUR YANG BERSIH
-- ENUM Definitions
DROP TYPE IF EXISTS user_role_type CASCADE;
DROP TYPE IF EXISTS payment_status_type CASCADE;
DROP TYPE IF EXISTS payment_method_type CASCADE;
DROP TYPE IF EXISTS transaction_status_type CASCADE;

CREATE TYPE user_role_type AS ENUM ('admin', 'customer');
CREATE TYPE payment_status_type AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE payment_method_type AS ENUM ('bank_transfer', 'credit_card', 'ewallet', 'cod');
CREATE TYPE transaction_status_type AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed');

-- CATEGORIES (dari jenis_barang)
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    image VARCHAR(500),
    icon_color VARCHAR(7),
    icon VARCHAR(100),
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT now()
);

-- PRODUCTS (dari barang)
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(12,2) CHECK (price > 0),
    original_price NUMERIC(12,2),
    discount INTEGER DEFAULT 0,
    image VARCHAR(500),
    description TEXT DEFAULT 'Produk berkualitas',
    rating NUMERIC(2,1) DEFAULT 4.5 CHECK (rating BETWEEN 0 AND 5),
    sold INTEGER DEFAULT 0,
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- 6. MIGRASI DATA DARI TABEL LAMA
-- Migrasi categories dari jenis_barang
INSERT INTO categories (id, name, image, icon_color, icon, created_at)
SELECT id, nama_jenis, image, icon_color, icon, now()
FROM jenis_barang
ON CONFLICT (id) DO NOTHING;

-- Migrasi products dari barang
INSERT INTO products (id, name, price, original_price, stock, image, category_id, created_at, updated_at)
SELECT 
    id, 
    nama_barang, 
    harga_jual, 
    harga_jual, 
    COALESCE(stok, 0), 
    COALESCE(gambar, 'default.jpg'),
    jenis_id,
    now(),
    now()
FROM barang
ON CONFLICT (id) DO NOTHING;

-- 7. HAPUS TABEL LAMA SETELAH MIGRASI
DROP TABLE IF EXISTS barang CASCADE;
DROP TABLE IF EXISTS jenis_barang CASCADE;

-- 8. UPDATE SEQUENCE VALUES
SELECT setval('categories_id_seq', COALESCE((SELECT MAX(id) FROM categories), 1));
SELECT setval('products_id_seq', COALESCE((SELECT MAX(id) FROM products), 1));

-- 9. BUAT TRIGGER UNTUK UPDATE TIMESTAMP
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

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 10. BERSIHKAN USERS TABLE (hapus kolom tidak perlu)
ALTER TABLE users DROP COLUMN IF EXISTS active;
ALTER TABLE users DROP COLUMN IF EXISTS full_name;
ALTER TABLE users DROP COLUMN IF EXISTS last_login;
ALTER TABLE users DROP COLUMN IF EXISTS username;
ALTER TABLE users ADD COLUMN IF NOT EXISTS address TEXT;

-- 11. PASTIKAN ADMIN USER ADA
INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES ('Admin', 'admin@rmart.com', '$2a$10$admin.hash.here', 'admin', now(), now())
ON CONFLICT (email) DO UPDATE SET role = 'admin';

COMMIT;

-- =====================================================
-- CLEANUP SELESAI - DATABASE SUDAH BERSIH
-- =====================================================