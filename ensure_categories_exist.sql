-- Ensure categories exist for admin dashboard
-- This script will insert sample categories if they don't exist

-- Check if categories table exists and create if needed
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    image VARCHAR(500),
    icon VARCHAR(10) DEFAULT '📦',
    icon_color VARCHAR(20) DEFAULT '#007AFF',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample categories (will skip if they already exist due to UNIQUE constraint)
INSERT INTO categories (name, image, icon, icon_color) VALUES
('Makanan', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400', '🍔', '#FF6B6B'),
('Minuman', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', '🥤', '#4ECDC4'),
('Elektronik', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400', '📱', '#45B7D1'),
('Fashion', 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400', '👕', '#96CEB4'),
('Kesehatan', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400', '💊', '#FFEAA7'),
('Olahraga', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400', '⚽', '#DDA0DD'),
('Buku', 'https://images.unsplash.com/photo-1481277542470-605612bd2d61?w=400', '📚', '#74B9FF'),
('Rumah Tangga', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400', '🏠', '#A29BFE')
ON CONFLICT (name) DO NOTHING;

-- Verify categories were inserted
SELECT 'Categories in database:' as info;
SELECT id, name, icon, icon_color FROM categories ORDER BY id;