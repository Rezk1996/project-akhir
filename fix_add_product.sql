-- Quick fix: Ensure tables exist and have proper data
SELECT 'Categories available:' as info;
SELECT id, nama_jenis FROM jenis_barang;

SELECT 'Products count:' as info;
SELECT COUNT(*) as total_products FROM barang;

-- Test insert a sample product
INSERT INTO barang (nama_barang, jenis_id, harga_jual, stok, gambar) 
VALUES ('Test Product', 1, 50000, 10, 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400')
ON CONFLICT DO NOTHING;

SELECT 'Test completed' as status;