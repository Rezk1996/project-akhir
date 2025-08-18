#!/bin/bash

# Script untuk memperbaiki ketidaksesuaian produk database dengan ecommerce

echo "🔧 Memperbaiki ketidaksesuaian produk database..."

# Jalankan script SQL perbaikan
if command -v psql &> /dev/null; then
    echo "📊 Menjalankan perbaikan database..."
    psql -d ecommerce_db -f /Users/user/Documents/ProjectWeb/Ecommerce/fix_product_database.sql
    
    if [ $? -eq 0 ]; then
        echo "✅ Perbaikan database berhasil!"
    else
        echo "❌ Gagal menjalankan perbaikan database"
        exit 1
    fi
else
    echo "⚠️  PostgreSQL client (psql) tidak ditemukan"
    echo "Silakan jalankan script SQL secara manual:"
    echo "psql -d ecommerce_db -f /Users/user/Documents/ProjectWeb/Ecommerce/fix_product_database.sql"
fi

# Restart backend untuk memuat perubahan
echo "🔄 Restarting backend..."
cd /Users/user/Documents/ProjectWeb/Ecommerce/Backend

# Kill existing backend process
pkill -f "spring-boot:run" 2>/dev/null || true
pkill -f "SpringbootApplication" 2>/dev/null || true

# Start backend
echo "🚀 Starting backend..."
nohup ./mvnw spring-boot:run > backend.log 2>&1 &

echo "✅ Perbaikan selesai!"
echo ""
echo "📋 Ringkasan perbaikan:"
echo "1. ✅ Menghapus SimpleProduct.java yang menyebabkan konflik"
echo "2. ✅ Memperbaiki Product.java agar sesuai dengan database schema"
echo "3. ✅ Menghapus method findByCategory yang tidak konsisten"
echo "4. ✅ Menambahkan relasi JPA yang benar antara Product dan Category"
echo "5. ✅ Menambahkan method untuk populate category name"
echo "6. ✅ Membersihkan dan memperbaiki data produk di database"
echo ""
echo "🔍 Untuk memeriksa status backend:"
echo "tail -f /Users/user/Documents/ProjectWeb/Ecommerce/Backend/backend.log"