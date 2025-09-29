#!/bin/bash

echo "Testing Cart Functionality..."
echo "================================"

# Test 1: Get Cart
echo "1. Testing GET /api/cart"
curl -s -X GET "http://localhost:8191/api/cart" \
  -H "Authorization: Bearer test-token" | jq .

echo -e "\n"

# Test 2: Add to Cart
echo "2. Testing POST /api/cart (Add to cart)"
curl -s -X POST "http://localhost:8191/api/cart?productId=1&quantity=1" \
  -H "Authorization: Bearer test-token" | jq .

echo -e "\n"

# Test 3: Get Cart Count
echo "3. Testing GET /api/cart/count"
curl -s -X GET "http://localhost:8191/api/cart/count" \
  -H "Authorization: Bearer test-token" | jq .

echo -e "\n"
echo "Test completed!"