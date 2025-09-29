#!/bin/bash

echo "🛒 Testing Cart Functionality Integration"
echo "========================================"

# Check if backend is running
echo "1. Checking Backend Status..."
if curl -s http://localhost:8191/api/products > /dev/null; then
    echo "✅ Backend is running on port 8191"
else
    echo "❌ Backend is not running. Start with: cd Ecommerce/Backend && mvn spring-boot:run"
    exit 1
fi

# Check if frontend is running
echo "2. Checking Frontend Status..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend is running on port 3000"
else
    echo "❌ Frontend is not running. Start with: cd Ecommerce/Frontend/frontend && npm start"
    exit 1
fi

# Test cart endpoints
echo "3. Testing Cart API Endpoints..."

# Test cart count endpoint (should require auth)
echo "   - Testing cart count endpoint..."
CART_COUNT_RESPONSE=$(curl -s -w "%{http_code}" http://localhost:8191/api/cart/count)
if [[ $CART_COUNT_RESPONSE == *"401"* ]]; then
    echo "   ✅ Cart count endpoint correctly requires authentication"
else
    echo "   ❌ Cart count endpoint should require authentication"
fi

# Test add to cart endpoint (should require auth)
echo "   - Testing add to cart endpoint..."
ADD_CART_RESPONSE=$(curl -s -w "%{http_code}" -X POST http://localhost:8191/api/cart \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "productId=1&quantity=1")
if [[ $ADD_CART_RESPONSE == *"401"* ]]; then
    echo "   ✅ Add to cart endpoint correctly requires authentication"
else
    echo "   ❌ Add to cart endpoint should require authentication"
fi

echo "4. Frontend Integration Test..."
echo "   Open http://localhost:3000 and test:"
echo "   - Click 'Add to Cart' on any product"
echo "   - Check cart icon shows item count"
echo "   - Verify cart page shows added items"

echo "5. Admin Dashboard Integration..."
echo "   Open http://localhost:3001 and test:"
echo "   - Login as admin"
echo "   - Add/edit products"
echo "   - Verify changes appear in frontend"

echo ""
echo "🎉 Cart Integration Setup Complete!"
echo "Open test-cart-integration.html for detailed testing"