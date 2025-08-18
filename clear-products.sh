#!/bin/bash

# Script untuk menghapus semua data dummy produk dari database
echo "🗑️  Menghapus semua data dummy produk..."

# Pastikan PostgreSQL berjalan
if ! pgrep -x "postgres" > /dev/null; then
    echo "❌ PostgreSQL tidak berjalan. Silakan jalankan PostgreSQL terlebih dahulu."
    exit 1
fi

# Jalankan script SQL untuk menghapus data produk
psql -d rmart_db -f Ecommerce/clear_products.sql

if [ $? -eq 0 ]; then
    echo "✅ Semua data dummy produk berhasil dihapus!"
    echo "📝 Database siap untuk produk baru Anda."
else
    echo "❌ Terjadi error saat menghapus data produk."
    exit 1
fi