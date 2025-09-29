#!/bin/bash

echo "Testing Login Backend API..."
echo "================================"

# Test 1: Login with admin credentials
echo "1. Testing login with admin@rmart.com"
curl -s -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@rmart.com", "password": "admin123"}' | jq .

echo -e "\n"

# Test 2: Login with wrong password
echo "2. Testing login with wrong password"
curl -s -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@rmart.com", "password": "wrongpass"}' | jq .

echo -e "\n"

# Test 3: Login with non-existent user
echo "3. Testing login with non-existent user"
curl -s -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "notfound@example.com", "password": "test123"}' | jq .

echo -e "\n"
echo "Backend login test completed!"