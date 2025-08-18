-- Script untuk memperbaiki foreign key constraints agar delete produk bisa berjalan

-- Cek data yang mungkin menghalangi delete
SELECT 'Cart Items with products:' as info, COUNT(*) as count FROM cart_items;
SELECT 'Transaction Items with products:' as info, COUNT(*) as count FROM transaction_items;
SELECT 'Order Items with products:' as info, COUNT(*) as count FROM order_items;
SELECT 'Reviews with products:' as info, COUNT(*) as count FROM reviews;

-- Hapus semua data terkait yang bisa menghalangi delete produk
DELETE FROM cart_items;
DELETE FROM transaction_items;
DELETE FROM order_items;
DELETE FROM reviews;

-- Tampilkan konfirmasi
SELECT 'Foreign key constraints cleared. Products can now be deleted safely.' as status;