#!/bin/bash

echo "=== Testing Product Synchronization ==="
echo "Langkah-langkah untuk menguji sinkronisasi produk:"
echo ""

echo "1. Pastikan backend berjalan di port 8191:"
echo "   cd Ecommerce/Backend && mvn spring-boot:run"
echo ""

echo "2. Jalankan Dashboard Admin di port 3001:"
echo "   cd Dashboard_Admin && npm start"
echo ""

echo "3. Jalankan Frontend Ecommerce di port 3000:"
echo "   cd Ecommerce/Frontend/frontend && npm start"
echo ""

echo "4. Test sinkronisasi:"
echo "   a. Buka Dashboard Admin: http://localhost:3001"
echo "   b. Login sebagai admin"
echo "   c. Tambah produk baru di halaman Products"
echo "   d. Buka Frontend Ecommerce: http://localhost:3000"
echo "   e. Refresh halaman untuk melihat produk baru"
echo ""

echo "=== Perbaikan yang telah dilakukan ==="
echo "✅ Port backend: 8191 (konsisten di semua aplikasi)"
echo "✅ Dashboard Admin menggunakan: /api/admin/products"
echo "✅ Frontend Ecommerce menggunakan: /api/products"
echo "✅ ProductContext diperbaiki untuk menggunakan API yang benar"
echo "✅ ProductProvider ditambahkan ke App.tsx"
echo "✅ HomePage dan ProductListPage diperbarui"
echo ""

echo "=== Endpoint yang digunakan ==="
echo "Backend API:"
echo "- GET /api/products (untuk frontend ecommerce)"
echo "- POST /api/admin/products (untuk dashboard admin)"
echo "- PUT /api/admin/products/{id} (untuk dashboard admin)"
echo "- DELETE /api/admin/products/{id} (untuk dashboard admin)"
echo ""

echo "Jika masih ada masalah, periksa:"
echo "1. Backend berjalan di port 8191"
echo "2. Database PostgreSQL berjalan"
echo "3. Tidak ada error di console browser"
echo "4. Network tab di browser untuk melihat API calls"