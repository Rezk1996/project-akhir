#!/bin/bash

echo "=== Testing Category Fix ==="
echo

# Test 1: Check categories in database
echo "1. Checking categories in database:"
psql -d rmart_db -c "SELECT id, name FROM categories ORDER BY id;"
echo

# Test 2: Check products with their category_id
echo "2. Checking products with category_id:"
psql -d rmart_db -c "SELECT id, name, category_id FROM products WHERE category_id IS NOT NULL LIMIT 5;"
echo

# Test 3: Test API endpoint for products
echo "3. Testing API endpoint for products:"
curl -s "http://localhost:8191/api/products" | jq '.data.products[0] | {id, name, category, categoryId}' 2>/dev/null || echo "Backend not running or jq not installed"
echo

# Test 4: Test API endpoint for categories
echo "4. Testing API endpoint for categories:"
curl -s "http://localhost:8191/api/categories" | jq '.data[0] | {id, name}' 2>/dev/null || echo "Backend not running or jq not installed"
echo

echo "=== Test Complete ==="