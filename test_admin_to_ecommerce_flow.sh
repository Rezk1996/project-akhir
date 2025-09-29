#!/bin/bash

echo "=== Testing Admin to Ecommerce Product Flow ==="
echo

# Test 1: Check current product count
echo "1. Current product counts:"
ADMIN_COUNT=$(curl -s "http://localhost:8191/api/admin/products" | jq '.data.products | length' 2>/dev/null)
ECOMMERCE_COUNT=$(curl -s "http://localhost:8191/api/products" | jq '.data.products | length' 2>/dev/null)

echo "Admin products: $ADMIN_COUNT"
echo "Ecommerce products: $ECOMMERCE_COUNT"
echo

# Test 2: Create a test product via Admin API
echo "2. Creating test product via Admin API..."
TEST_PRODUCT='{
  "name": "Test Product Shell Script",
  "price": 25000,
  "stock": 100,
  "category": "Makanan",
  "description": "Test product created via shell script",
  "image": "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300",
  "rating": 4.5,
  "discount": 0,
  "sold": 0
}'

CREATE_RESPONSE=$(curl -s -X POST "http://localhost:8191/api/admin/products" \
  -H "Content-Type: application/json" \
  -d "$TEST_PRODUCT")

echo "Create response: $CREATE_RESPONSE"
echo

# Extract product ID from response
PRODUCT_ID=$(echo "$CREATE_RESPONSE" | jq -r '.data.id' 2>/dev/null)
echo "Created product ID: $PRODUCT_ID"
echo

# Test 3: Verify product appears in Admin API
echo "3. Verifying product in Admin API..."
ADMIN_PRODUCT=$(curl -s "http://localhost:8191/api/admin/products" | jq ".data.products[] | select(.id == $PRODUCT_ID)" 2>/dev/null)
if [ "$ADMIN_PRODUCT" != "" ]; then
    echo "✅ Product found in Admin API"
    echo "$ADMIN_PRODUCT" | jq '{id, name, category}' 2>/dev/null
else
    echo "❌ Product NOT found in Admin API"
fi
echo

# Test 4: Verify product appears in Ecommerce API
echo "4. Verifying product in Ecommerce API..."
ECOMMERCE_PRODUCT=$(curl -s "http://localhost:8191/api/products" | jq ".data.products[] | select(.id == $PRODUCT_ID)" 2>/dev/null)
if [ "$ECOMMERCE_PRODUCT" != "" ]; then
    echo "✅ Product found in Ecommerce API"
    echo "$ECOMMERCE_PRODUCT" | jq '{id, name, category}' 2>/dev/null
else
    echo "❌ Product NOT found in Ecommerce API"
fi
echo

# Test 5: Compare categories
echo "5. Category comparison:"
ADMIN_CATEGORY=$(echo "$ADMIN_PRODUCT" | jq -r '.category' 2>/dev/null)
ECOMMERCE_CATEGORY=$(echo "$ECOMMERCE_PRODUCT" | jq -r '.category' 2>/dev/null)

echo "Admin category: $ADMIN_CATEGORY"
echo "Ecommerce category: $ECOMMERCE_CATEGORY"

if [ "$ADMIN_CATEGORY" = "$ECOMMERCE_CATEGORY" ] && [ "$ADMIN_CATEGORY" != "null" ]; then
    echo "✅ Categories match!"
else
    echo "❌ Categories don't match!"
fi
echo

# Test 6: Final counts
echo "6. Final product counts:"
FINAL_ADMIN_COUNT=$(curl -s "http://localhost:8191/api/admin/products" | jq '.data.products | length' 2>/dev/null)
FINAL_ECOMMERCE_COUNT=$(curl -s "http://localhost:8191/api/products" | jq '.data.products | length' 2>/dev/null)

echo "Admin products: $FINAL_ADMIN_COUNT (was $ADMIN_COUNT)"
echo "Ecommerce products: $FINAL_ECOMMERCE_COUNT (was $ECOMMERCE_COUNT)"

if [ "$FINAL_ADMIN_COUNT" = "$FINAL_ECOMMERCE_COUNT" ]; then
    echo "✅ Product counts match!"
else
    echo "❌ Product counts don't match!"
fi
echo

echo "=== Test Complete ==="
echo "Open test_admin_product_creation.html for interactive testing"