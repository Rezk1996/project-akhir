#!/bin/bash

echo "=== Testing Mentos Category Fix ==="
echo

# Test 1: Verify Mentos in database
echo "1. Checking Mentos in database:"
psql -d rmart_db -c "SELECT p.id, p.name, p.category_id, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.name ILIKE '%mentos%';"
echo

# Test 2: Test Admin API for Mentos
echo "2. Testing Admin API for Mentos:"
curl -s "http://localhost:8191/api/admin/products" | jq '.data.products[] | select(.name | test("mentos"; "i")) | {id, name, category, categoryId}' 2>/dev/null || echo "Admin API not responding or jq not installed"
echo

# Test 3: Test Ecommerce API for Mentos
echo "3. Testing Ecommerce API for Mentos:"
curl -s "http://localhost:8191/api/products" | jq '.data.products[] | select(.name | test("mentos"; "i")) | {id, name, category, categoryId}' 2>/dev/null || echo "Ecommerce API not responding or jq not installed"
echo

# Test 4: Compare categories
echo "4. Category comparison:"
ADMIN_CATEGORY=$(curl -s "http://localhost:8191/api/admin/products" | jq -r '.data.products[] | select(.name | test("mentos"; "i")) | .category' 2>/dev/null)
ECOMMERCE_CATEGORY=$(curl -s "http://localhost:8191/api/products" | jq -r '.data.products[] | select(.name | test("mentos"; "i")) | .category' 2>/dev/null)

if [ "$ADMIN_CATEGORY" = "$ECOMMERCE_CATEGORY" ] && [ "$ADMIN_CATEGORY" != "null" ] && [ "$ADMIN_CATEGORY" != "" ]; then
    echo "✅ SUCCESS: Categories match - $ADMIN_CATEGORY"
else
    echo "❌ MISMATCH: Admin='$ADMIN_CATEGORY', Ecommerce='$ECOMMERCE_CATEGORY'"
fi
echo

echo "=== Test Complete ==="
echo "Open test_mentos_category.html for detailed comparison"