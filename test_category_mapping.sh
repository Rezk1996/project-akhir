#!/bin/bash

echo "=== Testing Category Mapping Issue ==="
echo

# Test 1: Check database directly
echo "1. Database check - Products with categories:"
psql -d rmart_db -c "SELECT p.id, p.name, p.category_id, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id LIMIT 3;"
echo

# Test 2: Test ecommerce API
echo "2. Testing Ecommerce API response:"
curl -s "http://localhost:8191/api/products" | jq '.data.products[0] | {id, name, categoryId, category}' 2>/dev/null || echo "API not responding or jq not installed"
echo

# Test 3: Test admin API
echo "3. Testing Admin API response:"
curl -s "http://localhost:8191/api/admin/products" | jq '.data.products[0] | {id, name, categoryId, category}' 2>/dev/null || echo "Admin API not responding or jq not installed"
echo

# Test 4: Check categories endpoint
echo "4. Testing Categories endpoint:"
curl -s "http://localhost:8191/api/categories" | jq '.data[0] | {id, name}' 2>/dev/null || echo "Categories API not responding"
echo

echo "=== Test Complete ==="