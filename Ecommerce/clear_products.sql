-- Script untuk menghapus semua data dummy produk
-- Jalankan script ini untuk membersihkan database dari produk dummy

-- Hapus semua data terkait produk (dalam urutan yang benar untuk menghindari constraint error)
DELETE FROM cart_items;
DELETE FROM transaction_items;
DELETE FROM order_items;
DELETE FROM reviews;
DELETE FROM products;

-- Reset sequence untuk ID produk agar dimulai dari 1 lagi
ALTER SEQUENCE products_id_seq RESTART WITH 1;

-- Tampilkan konfirmasi
SELECT 'Semua data produk dummy telah dihapus. Database siap untuk produk baru.' as status;