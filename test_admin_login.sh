#!/bin/bash

echo "🧪 Testing Admin Login Issue"
echo "============================"

API_BASE="http://localhost:8191/api"

echo "1. Testing backend connectivity..."
curl -s "$API_BASE/auth/check-email?email=test@test.com" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Backend not running. Start with: cd Ecommerce/Backend && mvn spring-boot:run"
    exit 1
fi
echo "✅ Backend is running"

echo ""
echo "2. Creating admin user via API..."
echo "--------------------------------"
curl -X POST "$API_BASE/auth/create-admin" \
  -H "Content-Type: application/json" \
  -w "\nHTTP Status: %{http_code}\n" \
  2>/dev/null | jq '.' || echo "Admin creation attempted"

echo ""
echo "3. Testing login with admin@rmart.com / admin123..."
echo "--------------------------------------------------"
curl -X POST "$API_BASE/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@rmart.com",
    "password": "admin123"
  }' \
  -w "\nHTTP Status: %{http_code}\n" \
  2>/dev/null | jq '.' || echo "Login response received"

echo ""
echo "4. Testing with different password formats..."
echo "--------------------------------------------"

# Test with plain password
echo "Testing plain password..."
curl -s -X POST "$API_BASE/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@rmart.com",
    "password": "admin123"
  }' | jq '.message' 2>/dev/null || echo "Plain password test done"

echo ""
echo "5. Manual database check command:"
echo "psql -d rmart_db -c \"SELECT id, name, email, role, password FROM users WHERE email = 'admin@rmart.com';\""

echo ""
echo "6. If still failing, run this SQL to create admin user:"
echo "psql -d rmart_db -f create_admin_user.sql"