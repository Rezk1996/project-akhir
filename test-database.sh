#!/bin/bash

echo "🔍 Testing Database Connection..."

# Test PostgreSQL connection
echo "📊 Testing PostgreSQL connection..."
if psql -d DB_Rmart -c "SELECT version();" > /dev/null 2>&1; then
    echo "✅ PostgreSQL connection: OK"
else
    echo "❌ PostgreSQL connection: FAILED"
    exit 1
fi

# Test tables exist
echo "📋 Checking database tables..."
TABLES=$(psql -d DB_Rmart -t -c "SELECT table_name FROM information_schema.tables WHERE table_schema='public';" | tr -d ' ' | grep -v '^$')

for table in users categories products cart_items orders order_items; do
    if echo "$TABLES" | grep -q "^$table$"; then
        echo "✅ Table $table: EXISTS"
    else
        echo "❌ Table $table: MISSING"
    fi
done

# Test sample data
echo "📊 Checking sample data..."
USER_COUNT=$(psql -d DB_Rmart -t -c "SELECT COUNT(*) FROM users;" | tr -d ' ')
PRODUCT_COUNT=$(psql -d DB_Rmart -t -c "SELECT COUNT(*) FROM products;" | tr -d ' ')
CATEGORY_COUNT=$(psql -d DB_Rmart -t -c "SELECT COUNT(*) FROM categories;" | tr -d ' ')

echo "👤 Users: $USER_COUNT"
echo "📦 Products: $PRODUCT_COUNT"
echo "📂 Categories: $CATEGORY_COUNT"

# Test backend connection
echo "🔧 Testing Backend API..."
if curl -s http://localhost:8191/api/health > /dev/null 2>&1; then
    echo "✅ Backend API: RUNNING"
else
    echo "❌ Backend API: NOT RUNNING"
fi

echo "🏁 Database test completed!"