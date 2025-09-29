#!/bin/bash

echo "🔐 Testing Backend Login Endpoint"
echo "================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if backend is running
if ! curl -s http://localhost:8191/api/products > /dev/null 2>&1; then
    echo -e "${RED}❌ Backend not running on port 8191${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Backend is running${NC}"
echo ""

# Test login endpoint
echo -e "${BLUE}Testing login endpoint...${NC}"

# Create test user first (if not exists)
echo -e "${YELLOW}Creating test user...${NC}"
curl -s -X POST http://localhost:8191/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com", 
    "password": "password123"
  }' > /dev/null 2>&1

# Test login
echo -e "${BLUE}Testing login...${NC}"
RESPONSE=$(curl -s -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }')

echo "Login Response:"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"

# Check if login was successful
if echo "$RESPONSE" | grep -q '"status":true'; then
    echo -e "${GREEN}✅ Login endpoint working correctly${NC}"
else
    echo -e "${RED}❌ Login endpoint failed${NC}"
fi

echo ""
echo -e "${BLUE}Test credentials:${NC}"
echo "Email: test@example.com"
echo "Password: password123"