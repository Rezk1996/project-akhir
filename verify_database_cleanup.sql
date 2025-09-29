-- Verifikasi Database Cleanup
-- Script untuk memverifikasi bahwa database sudah bersih dari duplikasi

\echo '=== VERIFIKASI DATABASE CLEANUP ==='
\echo ''

-- 1. Cek tabel yang ada
\echo '1. TABEL YANG ADA:'
SELECT table_name, 
       CASE 
         WHEN table_name IN ('users', 'categories', 'products', 'carts', 'cart_items', 'orders', 'order_items', 'employees', 'shifts', 'attendance', 'newsletter_subscriptions') 
         THEN '✅ REQUIRED' 
         ELSE '❌ DUPLICATE/UNUSED' 
       END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY status DESC, table_name;

\echo ''
\echo '2. STRUKTUR TABEL UTAMA:'

-- 2. Verifikasi struktur users
\echo '--- USERS TABLE ---'
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public'
ORDER BY ordinal_position;

-- 3. Verifikasi struktur products  
\echo '--- PRODUCTS TABLE ---'
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'products' AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Verifikasi struktur categories
\echo '--- CATEGORIES TABLE ---'
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'categories' AND table_schema = 'public'
ORDER BY ordinal_position;

\echo ''
\echo '3. FOREIGN KEY CONSTRAINTS:'
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

\echo ''
\echo '=== CLEANUP COMPLETED ==='