#!/bin/bash

echo "🔍 Checking R-Mart System Status..."
echo "=================================="

# Check Backend
echo "📡 Backend API (Port 8191):"
if curl -s http://localhost:8191/api/products > /dev/null; then
    echo "✅ Backend API is running"
    PRODUCTS=$(curl -s http://localhost:8191/api/products | grep -o '"totalElements":[0-9]*' | cut -d':' -f2)
    echo "📦 Products available: $PRODUCTS"
else
    echo "❌ Backend API is not responding"
fi

echo ""

# Check Frontend Ecommerce
echo "🛒 Frontend Ecommerce (Port 3000):"
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend Ecommerce is running"
else
    echo "❌ Frontend Ecommerce is not responding"
fi

echo ""

# Check Admin Dashboard
echo "📊 Admin Dashboard (Port 3001):"
if curl -s http://localhost:3001 > /dev/null; then
    echo "✅ Admin Dashboard is running"
else
    echo "❌ Admin Dashboard is not responding"
fi

echo ""

# Check Database
echo "🗄️ Database (Port 5432):"
if docker ps | grep -q "rmart_postgres"; then
    echo "✅ PostgreSQL Database is running"
    DB_PRODUCTS=$(docker exec rmart_postgres psql -U postgres -d DB_Rmart -t -c "SELECT COUNT(*) FROM barang;" 2>/dev/null | xargs)
    echo "📦 Products in database: $DB_PRODUCTS"
else
    echo "❌ PostgreSQL Database is not running"
fi

echo ""
echo "🌐 Access URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Admin:    http://localhost:3001"
echo "   API:      http://localhost:8191/api"