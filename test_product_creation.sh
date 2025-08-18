#!/bin/bash

echo "Testing product creation..."

# Test 1: Get categories
echo "1. Testing categories endpoint:"
curl -X GET http://localhost:8191/api/admin/categories

echo -e "\n\n2. Testing product creation:"
curl -X POST http://localhost:8191/api/admin/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product Frontend",
    "price": 25000,
    "category": "Makanan",
    "stock": 10,
    "image": "https://example.com/test.jpg"
  }'

echo -e "\n\nTest completed!"