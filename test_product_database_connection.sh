#!/bin/bash

echo "=== Testing Product Database Connection ==="
echo "Date: $(date)"
echo ""

# Test 1: Backend Health Check
echo "1. Testing Backend Health..."
curl -s "http://localhost:8191/api/sample/health" | jq '.' 2>/dev/null || echo "Backend not responding or JSON parsing failed"
echo ""

# Test 2: Products API
echo "2. Testing Products API..."
response=$(curl -s "http://localhost:8191/api/products")
echo "$response" | jq '.' 2>/dev/null || echo "Products API failed or invalid JSON"
echo ""

# Test 3: Count products
echo "3. Counting products..."
count=$(echo "$response" | jq '.data.totalElements' 2>/dev/null)
echo "Total products found: $count"
echo ""

# Test 4: Categories API
echo "4. Testing Categories API..."
cat_response=$(curl -s "http://localhost:8191/api/categories")
echo "$cat_response" | jq '.' 2>/dev/null || echo "Categories API failed"
echo ""

# Test 5: Count categories
echo "5. Counting categories..."
cat_count=$(echo "$cat_response" | jq '.data | length' 2>/dev/null)
echo "Total categories found: $cat_count"
echo ""

# Test 6: Database direct check (if psql available)
echo "6. Direct Database Check..."
if command -v psql &> /dev/null; then
    echo "Checking products table..."
    psql -h localhost -U postgres -d rmart_db -c "SELECT COUNT(*) as product_count FROM products;" 2>/dev/null || echo "Database connection failed"
    echo ""
    echo "Checking categories table..."
    psql -h localhost -U postgres -d rmart_db -c "SELECT COUNT(*) as category_count FROM categories;" 2>/dev/null || echo "Database connection failed"
else
    echo "psql not available, skipping direct database check"
fi

echo ""
echo "=== Test Complete ==="