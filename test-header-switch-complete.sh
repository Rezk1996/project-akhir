#!/bin/bash

echo "🔧 Complete Header Switch Test"
echo "============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check services
echo -e "${BLUE}Checking services...${NC}"

if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${RED}❌ Frontend not running${NC}"
    exit 1
fi

if ! curl -s http://localhost:8191/api/products > /dev/null 2>&1; then
    echo -e "${RED}❌ Backend not running${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All services running${NC}"

# Create test user in database
echo -e "${BLUE}Creating test user...${NC}"
if command -v psql &> /dev/null; then
    psql -d DB_Rmart -f create-test-user.sql > /dev/null 2>&1
    echo -e "${GREEN}✅ Test user created${NC}"
else
    echo -e "${YELLOW}⚠️ psql not found, please create test user manually${NC}"
fi

echo ""
echo -e "${BLUE}🧪 Test Steps:${NC}"
echo "1. Check debug panel shows 'NOT LOGGED IN'"
echo "2. Use test login with: test@example.com / password123"
echo "3. Verify header changes from 'Masuk atau Daftar' to profile icon"
echo "4. Check debug panel shows 'LOGGED IN'"
echo ""

# Open test files
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🚀 Opening test files...${NC}"
    open test-login-flow.html
    sleep 1
    open http://localhost:3000
else
    echo -e "${YELLOW}Open these files:${NC}"
    echo "Test: file://$(pwd)/test-login-flow.html"
    echo "Frontend: http://localhost:3000"
fi

echo ""
echo -e "${GREEN}✅ Complete test setup ready!${NC}"
echo -e "${BLUE}Test Credentials: test@example.com / password123${NC}"