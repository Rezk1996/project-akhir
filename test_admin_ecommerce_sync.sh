#!/bin/bash

echo "=== Testing Admin Dashboard & Ecommerce Sync ==="
echo

# Test 1: Check legacy tables
echo "1. Checking legacy tables (barang & jenis_barang):"
echo "Barang count:"
psql -d rmart_db -c "SELECT COUNT(*) FROM barang;" 2>/dev/null || echo "Legacy barang table not found"
echo "Jenis Barang count:"
psql -d rmart_db -c "SELECT COUNT(*) FROM jenis_barang;" 2>/dev/null || echo "Legacy jenis_barang table not found"
echo

# Test 2: Check new tables
echo "2. Checking new tables (products & categories):"
echo "Products count:"
psql -d rmart_db -c "SELECT COUNT(*) FROM products;" 2>/dev/null || echo "Products table not found"
echo "Categories count:"
psql -d rmart_db -c "SELECT COUNT(*) FROM categories;" 2>/dev/null || echo "Categories table not found"
echo

# Test 3: Test Admin API
echo "3. Testing Admin API (/api/admin/products):"
curl -s "http://localhost:8191/api/admin/products" | jq '.data.products | length' 2>/dev/null || echo "Admin API not responding or jq not installed"
echo

# Test 4: Test Ecommerce API
echo "4. Testing Ecommerce API (/api/products):"
curl -s "http://localhost:8191/api/products" | jq '.data.products | length' 2>/dev/null || echo "Ecommerce API not responding or jq not installed"
echo

# Test 5: Compare first product from both APIs
echo "5. Comparing first product from both APIs:"
echo "Admin API first product:"
curl -s "http://localhost:8191/api/admin/products" | jq '.data.products[0] | {id, name, category}' 2>/dev/null || echo "Admin API not responding"
echo "Ecommerce API first product:"
curl -s "http://localhost:8191/api/products" | jq '.data.products[0] | {id, name, category}' 2>/dev/null || echo "Ecommerce API not responding"
echo

echo "=== Test Complete ==="