-- Sync categories between frontend and admin dashboard
-- Working with the actual database structure (jenis_barang table)

-- First, let's see what we have
SELECT 'Current categories:' as status;
SELECT id, nama_jenis, icon_color FROM jenis_barang ORDER BY id;

-- Update existing categories to match frontend names and add proper colors
UPDATE jenis_barang SET 
    nama_jenis = 'Kebutuhan Dapur',
    icon_color = '#FF6B35'
WHERE nama_jenis = 'Kebutuhan Dapur';

UPDATE jenis_barang SET 
    nama_jenis = 'Makanan',
    icon_color = '#FF9800'
WHERE nama_jenis IN ('Makanan & Snacks', 'makanan');

UPDATE jenis_barang SET 
    nama_jenis = 'Minuman & Beverage',
    icon_color = '#2196F3'
WHERE nama_jenis IN ('Minuman & Beverages', 'minuman');

UPDATE jenis_barang SET 
    nama_jenis = 'Kebutuhan Rumah',
    icon_color = '#4CAF50'
WHERE nama_jenis IN ('Kebutuhan Rumah Tangga', 'rumah tangga');

UPDATE jenis_barang SET 
    nama_jenis = 'Personal Care',
    icon_color = '#9C27B0'
WHERE nama_jenis IN ('Perawatan', 'perawatan');

-- Insert missing categories if they don't exist
INSERT INTO jenis_barang (nama_jenis, icon_color, image) 
SELECT 'Kebutuhan Ibu & Anak', '#FF69B4', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400'
WHERE NOT EXISTS (SELECT 1 FROM jenis_barang WHERE nama_jenis = 'Kebutuhan Ibu & Anak');

INSERT INTO jenis_barang (nama_jenis, icon_color, image) 
SELECT 'Produk Segar & Beku', '#00BCD4', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400'
WHERE NOT EXISTS (SELECT 1 FROM jenis_barang WHERE nama_jenis = 'Produk Segar & Beku');

INSERT INTO jenis_barang (nama_jenis, icon_color, image) 
SELECT 'Kebutuhan Kesehatan', '#F44336', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400'
WHERE NOT EXISTS (SELECT 1 FROM jenis_barang WHERE nama_jenis = 'Kebutuhan Kesehatan');

INSERT INTO jenis_barang (nama_jenis, icon_color, image) 
SELECT 'Lifestyle', '#607D8B', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400'
WHERE NOT EXISTS (SELECT 1 FROM jenis_barang WHERE nama_jenis = 'Lifestyle');

INSERT INTO jenis_barang (nama_jenis, icon_color, image) 
SELECT 'Pet Foods', '#795548', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400'
WHERE NOT EXISTS (SELECT 1 FROM jenis_barang WHERE nama_jenis = 'Pet Foods');

-- Verify the sync
SELECT 'Categories after sync:' as status;
SELECT id, nama_jenis as name, icon_color FROM jenis_barang ORDER BY id;

-- Show product counts per category
SELECT 'Product counts per category:' as status;
SELECT jb.nama_jenis as category_name, COUNT(b.id) as product_count 
FROM jenis_barang jb 
LEFT JOIN barang b ON jb.id = b.jenis_id 
GROUP BY jb.id, jb.nama_jenis 
ORDER BY jb.nama_jenis;