-- Create legacy tables for compatibility with existing backend entities

-- Create jenis_barang table (categories)
CREATE TABLE IF NOT EXISTS jenis_barang (
    id BIGSERIAL PRIMARY KEY,
    nama_jenis VARCHAR(100) NOT NULL,
    image VARCHAR(500),
    icon_color VARCHAR(7) DEFAULT '#007AFF',
    icon VARCHAR(10) DEFAULT '📦',
    created_at TIMESTAMP DEFAULT now()
);

-- Create barang table (products)
CREATE TABLE IF NOT EXISTS barang (
    id BIGSERIAL PRIMARY KEY,
    nama_barang VARCHAR(255) NOT NULL,
    jenis_id INTEGER REFERENCES jenis_barang(id) ON DELETE SET NULL,
    harga_jual NUMERIC(12,2) CHECK (harga_jual > 0),
    stok INTEGER DEFAULT 0 CHECK (stok >= 0),
    gambar VARCHAR(500),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Create customer table for legacy compatibility
CREATE TABLE IF NOT EXISTS customer (
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    is_member BOOLEAN DEFAULT false,
    poin INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT now()
);

-- Insert sample categories into jenis_barang
INSERT INTO jenis_barang (nama_jenis, image, icon_color, icon) VALUES
('Electronics', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400', '#3498db', '📱'),
('Fashion', 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400', '#e74c3c', '👕'),
('Books', 'https://images.unsplash.com/photo-1481277542470-605612bd2d61?w=400', '#f39c12', '📚'),
('Home & Garden', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400', '#2ecc71', '🏠'),
('Sports', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400', '#9b59b6', '⚽'),
('Food & Beverages', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', '#e67e22', '🍕'),
('Health & Beauty', 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400', '#f1c40f', '💄'),
('Automotive', 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400', '#34495e', '🚗'),
('Toys & Games', 'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=400', '#ff6b6b', '🎮'),
('Office Supplies', 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=400', '#95a5a6', '📝')
ON CONFLICT (nama_jenis) DO NOTHING;

-- Insert sample products into barang
INSERT INTO barang (nama_barang, jenis_id, harga_jual, stok, gambar) VALUES
('iPhone 14 Pro', 1, 15999000, 50, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400'),
('Samsung Galaxy S23', 1, 12999000, 30, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400'),
('MacBook Air M2', 1, 18999000, 25, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400'),
('Nike Air Max 270', 2, 2250000, 100, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'),
('Adidas Ultraboost', 2, 2800000, 75, 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400'),
('The Great Gatsby', 3, 150000, 200, 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400'),
('Coffee Maker Deluxe', 4, 1299000, 45, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400'),
('Yoga Mat Premium', 5, 750000, 90, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400'),
('Organic Green Tea', 6, 85000, 150, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400'),
('Face Moisturizer', 7, 320000, 80, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400')
ON CONFLICT DO NOTHING;

-- Insert sample customers
INSERT INTO customer (nama, email, is_member, poin) VALUES
('John Doe', 'john@example.com', true, 1500),
('Jane Smith', 'jane@example.com', false, 0),
('Bob Johnson', 'bob@example.com', true, 2300),
('Alice Brown', 'alice@example.com', false, 500)
ON CONFLICT (email) DO NOTHING;

-- Create trigger for updating updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add trigger to barang table
DROP TRIGGER IF EXISTS trg_barang_updated_at ON barang;
CREATE TRIGGER trg_barang_updated_at
    BEFORE UPDATE ON barang
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();