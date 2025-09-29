#!/bin/bash

echo "🧪 Testing Header Login Status Fix"
echo "=================================="

# Check if frontend is running
if ! curl -s http://localhost:3000 > /dev/null; then
    echo "❌ Frontend is not running on port 3000"
    echo "Please start the frontend first:"
    echo "cd Ecommerce/Frontend/frontend && npm start"
    exit 1
fi

echo "✅ Frontend is running on port 3000"

# Check if backend is running
if ! curl -s http://localhost:8191/api/products > /dev/null; then
    echo "❌ Backend is not running on port 8191"
    echo "Please start the backend first:"
    echo "cd Ecommerce/Backend && mvn spring-boot:run"
    exit 1
fi

echo "✅ Backend is running on port 8191"

echo ""
echo "🔍 Test Instructions:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Check the header - should show 'Masuk atau Daftar' when not logged in"
echo "3. Login with valid credentials"
echo "4. Check the header - should show profile icon (👤) when logged in"
echo "5. Refresh the page - status should persist"
echo "6. Logout - should show 'Masuk atau Daftar' again"
echo ""
echo "🧪 You can also use the test file:"
echo "open test-header-login-status.html"
echo ""

# Open test file if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🚀 Opening test file..."
    open test-header-login-status.html
fi

echo "✅ Test setup complete!"