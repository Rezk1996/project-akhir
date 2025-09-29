#!/bin/bash

echo "=== Testing Image Access ==="
echo "Testing backend image endpoints..."

# Test static resource controller
echo -e "\n1. Testing static resource controller:"
curl -s "http://localhost:8191/uploads/test" || echo "Backend not running"

# Test debug endpoint
echo -e "\n2. Testing debug endpoint for test image:"
curl -s "http://localhost:8191/uploads/debug/1756729771820_test-upload.jpg" | python3 -m json.tool 2>/dev/null || echo "Debug endpoint failed"

# Test actual image access
echo -e "\n3. Testing actual image access:"
curl -I "http://localhost:8191/uploads/images/1756729771820_test-upload.jpg" 2>/dev/null | head -1 || echo "Image access failed"

# Test product API image URLs
echo -e "\n4. Testing product API:"
curl -s "http://localhost:8191/api/products" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data.get('status') and 'data' in data and 'products' in data['data']:
        products = data['data']['products'][:3]  # First 3 products
        for p in products:
            print(f'Product: {p.get(\"name\", \"Unknown\")}')
            print(f'Image URL: {p.get(\"image\", \"No image\")}')
            print('---')
    else:
        print('No products found or API error')
except:
    print('Failed to parse API response')
" 2>/dev/null || echo "Product API test failed"

echo -e "\n=== Test Complete ==="