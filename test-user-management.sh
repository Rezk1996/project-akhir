#!/bin/bash

echo "🧪 Testing User Management System Integration"
echo "============================================="

BASE_URL="http://localhost:8191/api"

# Test 1: Get all users
echo "📋 Test 1: Getting all users..."
curl -s -X GET "$BASE_URL/admin/users?page=0&size=5" \
  -H "Content-Type: application/json" | jq '.'

echo -e "\n"

# Test 2: Get user statistics
echo "📊 Test 2: Getting user statistics..."
curl -s -X GET "$BASE_URL/admin/users/stats" \
  -H "Content-Type: application/json" | jq '.'

echo -e "\n"

# Test 3: Get recent profile updates
echo "🔄 Test 3: Getting recent profile updates..."
curl -s -X GET "$BASE_URL/admin/users/recent-updates?limit=5" \
  -H "Content-Type: application/json" | jq '.'

echo -e "\n"

# Test 4: Get real-time updates
echo "⚡ Test 4: Getting real-time updates..."
curl -s -X GET "$BASE_URL/admin/user-updates/recent?limit=5" \
  -H "Content-Type: application/json" | jq '.'

echo -e "\n"

# Test 5: Simulate profile update from e-commerce
echo "🛒 Test 5: Simulating profile update from e-commerce..."
# First, let's get a user token (simulate login)
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "rezki@mail.com", "password": "password123"}')

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.token // empty')

if [ ! -z "$TOKEN" ]; then
  echo "✅ Login successful, updating profile..."
  
  # Update profile
  curl -s -X PUT "$BASE_URL/user/profile" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{
      "name": "Rezki Updated",
      "phone": "081234567890",
      "address": "Jl. Merdeka No. 123, Jakarta",
      "dateOfBirth": "1990-01-15",
      "gender": "male"
    }' | jq '.'
  
  echo -e "\n"
  
  # Check if update was recorded
  echo "🔍 Checking if update was recorded..."
  sleep 1
  curl -s -X GET "$BASE_URL/admin/user-updates/recent?limit=3" \
    -H "Content-Type: application/json" | jq '.'
else
  echo "❌ Login failed, skipping profile update test"
fi

echo -e "\n"

# Test 6: Test user role update
echo "👑 Test 6: Testing user role update..."
curl -s -X PUT "$BASE_URL/admin/users/2/role" \
  -H "Content-Type: application/json" \
  -d '{"role": "admin"}' | jq '.'

echo -e "\n"

echo "✅ User Management System Tests Completed!"
echo "Check the admin dashboard at http://localhost:3001 to see the results."