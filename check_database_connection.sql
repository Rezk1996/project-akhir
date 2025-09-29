-- Check database connection and data source
-- Verify which database is being used

-- Check current database
SELECT current_database();

-- Check if we're connected to DB_Rmart
\c DB_Rmart

-- Check products data from barang table (legacy)
SELECT 'BARANG TABLE' as source, id, nama_barang, harga_jual, stok, jenis_id 
FROM barang 
ORDER BY id 
LIMIT 10;

-- Check if products table exists (new schema)
SELECT 'PRODUCTS TABLE' as source, id, name, price, stock, category_id 
FROM products 
ORDER BY id 
LIMIT 10;

-- Check categories from jenis_barang table
SELECT 'JENIS_BARANG TABLE' as source, id, nama_jenis 
FROM jenis_barang 
ORDER BY id;

-- Check if categories table exists (new schema)
SELECT 'CATEGORIES TABLE' as source, id, name 
FROM categories 
ORDER BY id;