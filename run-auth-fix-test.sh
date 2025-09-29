#!/bin/bash

echo "🔧 Running Auth Fix Test"
echo "======================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check frontend
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend running on port 3000${NC}"
else
    echo -e "${RED}❌ Frontend not running${NC}"
    echo -e "${YELLOW}Start with: cd Ecommerce/Frontend/frontend && npm start${NC}"
    exit 1
fi

# Check backend
if curl -s http://localhost:8191/api/products > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend running on port 8191${NC}"
else
    echo -e "${RED}❌ Backend not running${NC}"
    echo -e "${YELLOW}Start with: cd Ecommerce/Backend && mvn spring-boot:run${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}🧪 Test Steps:${NC}"
echo "1. Use test file to simulate login/logout"
echo "2. Check header behavior on frontend"
echo "3. Verify debug panel shows correct status"
echo "4. Test actual login flow"
echo ""

# Open test file and frontend
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🚀 Opening test file and frontend...${NC}"
    open test-auth-fix.html
    sleep 2
    open http://localhost:3000
else
    echo -e "${YELLOW}Open these in your browser:${NC}"
    echo "Test file: file://$(pwd)/test-auth-fix.html"
    echo "Frontend: http://localhost:3000"
fi

echo ""
echo -e "${GREEN}✅ Auth fix test ready!${NC}"
echo -e "${BLUE}Look for the debug panel in the top-right corner of the frontend${NC}"