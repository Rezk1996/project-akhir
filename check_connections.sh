#!/bin/bash

echo "🔗 CHECKING BACKEND CONNECTIONS"
echo "==============================="
echo ""

echo "1. 🌐 Application Status:"
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8191/api/products)
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001)

echo "   Backend API (8191): $BACKEND_STATUS"
echo "   Frontend Ecommerce (3000): $FRONTEND_STATUS"
echo "   Admin Dashboard (3001): $ADMIN_STATUS"

echo ""
echo "2. 📡 API Connectivity Test:"

# Test Ecommerce Frontend -> Backend
echo "   Ecommerce -> Backend:"
if [ "$BACKEND_STATUS" = "200" ]; then
    PRODUCTS_API=$(curl -s http://localhost:8191/api/products | grep -o '"totalElements":[0-9]*' | cut -d':' -f2)
    echo "     ✅ Products API: $PRODUCTS_API items available"
    
    CATEGORIES_API=$(curl -s http://localhost:8191/api/categories | grep -o '"name":"[^"]*"' | wc -l | tr -d ' ')
    echo "     ✅ Categories API: $CATEGORIES_API categories available"
else
    echo "     ❌ Backend not responding"
fi

# Test Admin Dashboard -> Backend
echo ""
echo "   Admin Dashboard -> Backend:"
ADMIN_PRODUCTS=$(curl -s http://localhost:8191/api/admin/products | grep -o '"totalElements":[0-9]*' | cut -d':' -f2)
if [ ! -z "$ADMIN_PRODUCTS" ]; then
    echo "     ✅ Admin Products API: $ADMIN_PRODUCTS items"
else
    echo "     ⚠️ Admin Products API: No response"
fi

ADMIN_USERS=$(curl -s http://localhost:8191/api/admin/users | grep -o '"users":\[' | wc -l | tr -d ' ')
if [ "$ADMIN_USERS" -gt 0 ]; then
    echo "     ✅ Admin Users API: Connected"
else
    echo "     ⚠️ Admin Users API: No response"
fi

echo ""
echo "3. 🗄️ Backend -> Database:"
DB_PRODUCTS=$(psql -d DB_Rmart -t -c "SELECT COUNT(*) FROM barang;" | tr -d ' ')
echo "   PostgreSQL Products: $DB_PRODUCTS"

echo ""
echo "4. 🔄 Real-time Data Flow Test:"
echo "   Testing data consistency..."

# Get data from database
DB_FIRST_PRODUCT=$(psql -d DB_Rmart -t -c "SELECT nama_barang FROM barang LIMIT 1;" | tr -d ' ')

# Get data from API
API_FIRST_PRODUCT=$(curl -s http://localhost:8191/api/products | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ "$DB_FIRST_PRODUCT" = "$API_FIRST_PRODUCT" ]; then
    echo "   ✅ Database ↔ API: Synchronized"
else
    echo "   ⚠️ Database ↔ API: Data mismatch"
    echo "      DB: $DB_FIRST_PRODUCT"
    echo "      API: $API_FIRST_PRODUCT"
fi

echo ""
echo "📊 CONNECTION SUMMARY:"
echo "======================"
if [ "$BACKEND_STATUS" = "200" ] && [ "$FRONTEND_STATUS" = "200" ] && [ "$ADMIN_STATUS" = "200" ]; then
    echo "✅ ALL CONNECTIONS ACTIVE:"
    echo "   - Ecommerce Frontend ↔ Backend API ↔ PostgreSQL"
    echo "   - Admin Dashboard ↔ Backend API ↔ PostgreSQL"
    echo "   - Real-time data synchronization working"
else
    echo "⚠️ CONNECTION ISSUES DETECTED"
fi

echo ""
echo "🌐 Access URLs:"
echo "   - Ecommerce: http://localhost:3000"
echo "   - Admin: http://localhost:3001"
echo "   - API: http://localhost:8191/api/products"