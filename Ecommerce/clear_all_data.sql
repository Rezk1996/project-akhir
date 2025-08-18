-- Script untuk menghapus semua data dummy termasuk kategori
-- Untuk web retail seperti Alfamart/Indomaret

-- Hapus semua data terkait produk dan kategori
DELETE FROM cart_items;
DELETE FROM transaction_items;
DELETE FROM order_items;
DELETE FROM reviews;
DELETE FROM products;
DELETE FROM categories;

-- Reset sequence
ALTER SEQUENCE products_id_seq RESTART WITH 1;
ALTER SEQUENCE categories_id_seq RESTART WITH 1;

-- Tampilkan konfirmasi
SELECT 'Semua data produk dan kategori dummy telah dihapus. Database siap untuk data retail.' as status;