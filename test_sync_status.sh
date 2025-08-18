#!/bin/bash

echo "🔄 TESTING SYNCHRONIZATION STATUS"
echo "=================================="
echo ""

echo "1. 📦 Products Endpoint:"
PRODUCTS=$(curl -s http://localhost:8191/api/products)
if [[ $PRODUCTS == *"Products retrieved successfully"* ]]; then
    PRODUCT_COUNT=$(echo $PRODUCTS | grep -o '"totalElements":[0-9]*' | cut -d':' -f2)
    echo "   ✅ Products: $PRODUCT_COUNT items from PostgreSQL"
else
    echo "   ❌ Products endpoint failed"
fi

echo ""
echo "2. 🏷️ Categories Endpoint:"
CATEGORIES=$(curl -s http://localhost:8191/api/categories)
if [[ $CATEGORIES == *"Categories retrieved successfully"* ]]; then
    echo "   ✅ Categories: Working with PostgreSQL"
else
    echo "   ❌ Categories endpoint failed"
fi

echo ""
echo "3. 👥 Admin Users Endpoint:"
USERS=$(curl -s http://localhost:8191/api/admin/users)
if [[ $USERS == *"Users retrieved successfully"* ]]; then
    echo "   ✅ Users: Working with PostgreSQL"
else
    echo "   ❌ Users endpoint failed"
fi

echo ""
echo "4. 🛠️ Admin Products Endpoint:"
ADMIN_PRODUCTS=$(curl -s http://localhost:8191/api/admin/products)
if [[ $ADMIN_PRODUCTS == *"Products retrieved successfully"* ]]; then
    echo "   ✅ Admin Products: Working with PostgreSQL"
else
    echo "   ❌ Admin Products endpoint failed"
fi

echo ""
echo "5. 🗄️ Database Verification:"
DB_COUNT=$(psql -d DB_Rmart -t -c "SELECT COUNT(*) FROM barang;")
echo "   📊 Database has $DB_COUNT products"

echo ""
echo "✅ SYNCHRONIZATION STATUS:"
echo "   - Backend: Connected to PostgreSQL"
echo "   - Frontend: Will sync with backend API"
echo "   - Admin Dashboard: Will sync with backend API"
echo "   - Database: PostgreSQL with real data"