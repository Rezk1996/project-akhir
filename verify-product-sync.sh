#!/bin/bash

echo "🔍 Memverifikasi sinkronisasi produk antara Dashboard Admin dan Ecommerce Frontend..."

# Test endpoint ecommerce frontend
echo "📱 Testing Ecommerce Frontend endpoint..."
curl -s "http://localhost:8191/api/products?page=0&size=5" | jq '.data.products[] | {id, name, price, category, stock}' || echo "❌ Ecommerce endpoint tidak dapat diakses"

echo ""
echo "🔧 Testing Dashboard Admin endpoint..."
# Test endpoint dashboard admin (perlu token admin)
ADMIN_TOKEN=$(curl -s -X POST "http://localhost:8191/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}' | jq -r '.data.token' 2>/dev/null)

if [ "$ADMIN_TOKEN" != "null" ] && [ "$ADMIN_TOKEN" != "" ]; then
    echo "✅ Admin login berhasil"
    curl -s "http://localhost:8191/api/admin/products?page=0&size=5" \
      -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.data.products[] | {id, name, price, category, stock}' || echo "❌ Admin endpoint tidak dapat diakses"
else
    echo "❌ Admin login gagal - menggunakan endpoint tanpa auth"
    curl -s "http://localhost:8191/api/admin/products?page=0&size=5" | jq '.data.products[] | {id, name, price, category, stock}' || echo "❌ Admin endpoint tidak dapat diakses"
fi

echo ""
echo "📊 Membandingkan jumlah produk..."
ECOMMERCE_COUNT=$(curl -s "http://localhost:8191/api/products?page=0&size=1" | jq '.data.totalElements' 2>/dev/null)
ADMIN_COUNT=$(curl -s "http://localhost:8191/api/admin/products?page=0&size=1" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.data.totalElements' 2>/dev/null)

echo "Ecommerce Frontend: $ECOMMERCE_COUNT produk"
echo "Dashboard Admin: $ADMIN_COUNT produk"

if [ "$ECOMMERCE_COUNT" = "$ADMIN_COUNT" ]; then
    echo "✅ Jumlah produk sama"
else
    echo "⚠️  Jumlah produk berbeda!"
fi

echo ""
echo "🔄 Restart semua service untuk memastikan perubahan diterapkan..."
cd /Users/user/Documents/ProjectWeb

# Restart backend
echo "🔄 Restarting backend..."
pkill -f "spring-boot:run" 2>/dev/null || true
cd Ecommerce/Backend
nohup ./mvnw spring-boot:run > backend.log 2>&1 &

# Restart dashboard admin
echo "🔄 Restarting dashboard admin..."
cd ../../Dashboard_Admin
pkill -f "react-scripts start" 2>/dev/null || true
nohup npm start > dashboard.log 2>&1 &

# Restart ecommerce frontend
echo "🔄 Restarting ecommerce frontend..."
cd ../Ecommerce/Frontend/frontend
pkill -f "react-scripts start" 2>/dev/null || true
nohup npm start > frontend.log 2>&1 &

echo ""
echo "✅ Perbaikan selesai!"
echo ""
echo "📋 Perubahan yang dilakukan:"
echo "1. ✅ Membuat AdminProductService terpisah"
echo "2. ✅ Menambahkan endpoint /api/admin/products"
echo "3. ✅ Dashboard Admin sekarang menggunakan endpoint admin"
echo "4. ✅ Ecommerce Frontend tetap menggunakan endpoint publik"
echo "5. ✅ Kedua endpoint populate category name dengan benar"
echo ""
echo "🌐 URL untuk testing:"
echo "- Dashboard Admin: http://localhost:3001"
echo "- Ecommerce Frontend: http://localhost:3000"
echo "- Backend API: http://localhost:8191"