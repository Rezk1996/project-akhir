-- Create categories table with icon support
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(255),
    icon_color VARCHAR(7) DEFAULT '#6366F1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert categories with appropriate icons
INSERT INTO categories (name, description, icon, icon_color) VALUES
('Kebutuhan Dapur', 'Peralatan dan perlengkapan dapur', '🍳', '#FF6B35'),
('Kebutuhan Ibu & Anak', 'Produk untuk ibu dan anak', '👶', '#FF69B4'),
('Kebutuhan Rumah', 'Perlengkapan rumah tangga', '🏠', '#4CAF50'),
('Makanan', 'Makanan dan cemilan', '🍽️', '#FF9800'),
('Produk Segar & Beku', 'Produk segar dan beku', '❄️', '#00BCD4'),
('Personal Care', 'Perawatan pribadi', '💄', '#9C27B0'),
('Kebutuhan Kesehatan', 'Produk kesehatan dan obat-obatan', '⚕️', '#F44336'),
('Lifestyle', 'Produk gaya hidup', '✨', '#607D8B'),
('Pet Foods', 'Makanan hewan peliharaan', '🐕', '#795548'),
('Minuman & Beverage', 'Minuman dan beverage', '🥤', '#2196F3')
ON CONFLICT (name) DO UPDATE SET
    icon = EXCLUDED.icon,
    icon_color = EXCLUDED.icon_color,
    updated_at = CURRENT_TIMESTAMP;