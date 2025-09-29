-- Update Category Icons dengan Icon yang Lebih Representatif
-- Script untuk mengganti icon kategori produk dengan emoji yang lebih sesuai

-- Tambah kolom icon jika belum ada
ALTER TABLE categories ADD COLUMN IF NOT EXISTS icon VARCHAR(10);

-- Update icon untuk setiap kategori
UPDATE categories SET icon = '🍳' WHERE name = 'Kebutuhan Dapur';
UPDATE categories SET icon = '👶' WHERE name = 'Kebutuhan Ibu & Anak';
UPDATE categories SET icon = '🧴' WHERE name = 'Personal Care';
UPDATE categories SET icon = '🏠' WHERE name = 'Kebutuhan Rumah';
UPDATE categories SET icon = '🍽️' WHERE name = 'Makanan';
UPDATE categories SET icon = '🥤' WHERE name = 'Minuman';
UPDATE categories SET icon = '🥬' WHERE name = 'Produk Segar & Beku';
UPDATE categories SET icon = '💊' WHERE name = 'Kebutuhan Kesehatan';
UPDATE categories SET icon = '✨' WHERE name = 'Lifestyle';
UPDATE categories SET icon = '🐕' WHERE name = 'Pet Foods';

-- Verifikasi perubahan
SELECT id, name, icon, icon_color FROM categories ORDER BY id;