#!/bin/bash

# Test Registration Script
echo "=== Testing Registration API ==="

# Test 1: Valid registration
echo "Test 1: Valid registration with new email"
TIMESTAMP=$(date +%s)
EMAIL="user${TIMESTAMP}@example.com"

curl -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"Test User ${TIMESTAMP}\",
    \"email\": \"${EMAIL}\",
    \"password\": \"password123\"
  }" | python3 -m json.tool

echo -e "\n"

# Test 2: Duplicate email
echo "Test 2: Duplicate email registration"
curl -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"Duplicate User\",
    \"email\": \"${EMAIL}\",
    \"password\": \"password123\"
  }" | python3 -m json.tool

echo -e "\n"

# Test 3: Invalid email
echo "Test 3: Invalid email format"
curl -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Invalid Email User",
    "email": "invalid-email",
    "password": "password123"
  }' | python3 -m json.tool

echo -e "\n"

# Test 4: Short password
echo "Test 4: Password too short"
curl -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Short Password User",
    "email": "shortpass@example.com",
    "password": "123"
  }' | python3 -m json.tool

echo -e "\n"

# Test 5: Missing name
echo "Test 5: Missing name"
curl -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "noname@example.com",
    "password": "password123"
  }' | python3 -m json.tool

echo -e "\n=== Test Complete ==="