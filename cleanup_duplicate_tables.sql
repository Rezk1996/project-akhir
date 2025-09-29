-- Cleanup Script: Hapus Tabel Duplikat dan Tidak Terpakai
-- Hanya menyisakan tabel yang diperlukan untuk R-Mart E-commerce

-- Hapus tabel duplikat dan tidak terpakai
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS barang CASCADE;
DROP TABLE IF EXISTS categories_backup CASCADE;
DROP TABLE IF EXISTS coupons CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS detail_transaksi CASCADE;
DROP TABLE IF EXISTS diskon CASCADE;
DROP TABLE IF EXISTS expense CASCADE;
DROP TABLE IF EXISTS harga_beli CASCADE;
DROP TABLE IF EXISTS jenis_barang CASCADE;
DROP TABLE IF EXISTS keranjang CASCADE;
DROP TABLE IF EXISTS kuliner CASCADE;
DROP TABLE IF EXISTS point_member CASCADE;
DROP TABLE IF EXISTS product_images CASCADE;
DROP TABLE IF EXISTS purchase CASCADE;
DROP TABLE IF EXISTS restoran CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS shift_kerja CASCADE;
DROP TABLE IF EXISTS stok_keluar CASCADE;
DROP TABLE IF EXISTS stok_masuk CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS target_penjualan CASCADE;
DROP TABLE IF EXISTS tenaga_kerja CASCADE;
DROP TABLE IF EXISTS test_connection CASCADE;
DROP TABLE IF EXISTS transaksi CASCADE;
DROP TABLE IF EXISTS wishlists CASCADE;

-- Verifikasi tabel yang tersisa
SELECT 'Cleanup completed. Remaining tables:' as status;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;