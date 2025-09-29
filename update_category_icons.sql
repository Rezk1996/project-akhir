-- Update Category Icons dengan Icon yang Lebih Representatif
-- Script untuk mengganti icon kategori produk dengan emoji yang lebih sesuai

UPDATE jenis_barang SET icon = '🍳' WHERE nama_jenis = 'Kebutuhan Dapur';
UPDATE jenis_barang SET icon = '👶' WHERE nama_jenis = 'Kebutuhan Ibu & Anak';
UPDATE jenis_barang SET icon = '🧴' WHERE nama_jenis = 'Personal Care';
UPDATE jenis_barang SET icon = '🏠' WHERE nama_jenis = 'Kebutuhan Rumah';
UPDATE jenis_barang SET icon = '🍽️' WHERE nama_jenis = 'Makanan';
UPDATE jenis_barang SET icon = '🥤' WHERE nama_jenis = 'Minuman';
UPDATE jenis_barang SET icon = '🥬' WHERE nama_jenis = 'Produk Segar & Beku';
UPDATE jenis_barang SET icon = '💊' WHERE nama_jenis = 'Kebutuhan Kesehatan';
UPDATE jenis_barang SET icon = '✨' WHERE nama_jenis = 'Lifestyle';
UPDATE jenis_barang SET icon = '🐕' WHERE nama_jenis = 'Pet Foods';

-- Verifikasi perubahan
SELECT id, nama_jenis, icon, icon_color FROM jenis_barang ORDER BY id;