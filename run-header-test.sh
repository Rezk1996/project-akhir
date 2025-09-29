#!/bin/bash

echo "🧪 Running Header Functionality Test"
echo "==================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}Checking system status...${NC}"

# Check if frontend is running
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend running on port 3000${NC}"
else
    echo -e "${RED}❌ Frontend not running${NC}"
    echo -e "${YELLOW}Start with: cd Ecommerce/Frontend/frontend && npm start${NC}"
    exit 1
fi

# Check if backend is running
if curl -s http://localhost:8191/api/products > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend running on port 8191${NC}"
else
    echo -e "${RED}❌ Backend not running${NC}"
    echo -e "${YELLOW}Start with: cd Ecommerce/Backend && mvn spring-boot:run${NC}"
    exit 1
fi

echo ""
echo -e "${PURPLE}🎯 Test Objectives:${NC}"
echo "1. Verify header shows 'Masuk atau Daftar' when logged out"
echo "2. Verify header shows 'Profile | Logout' when logged in"
echo "3. Test login/logout button functionality"
echo "4. Check real-time header updates"
echo ""

echo -e "${BLUE}🧪 Test Steps:${NC}"
echo "1. Use test panel to simulate login/logout"
echo "2. Check header preview in test panel"
echo "3. Verify actual header on frontend"
echo "4. Test real login flow"
echo ""

# Open test file and frontend
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🚀 Opening test panel and frontend...${NC}"
    open test-header-functionality.html
    sleep 2
    open http://localhost:3000
else
    echo -e "${YELLOW}Open these in your browser:${NC}"
    echo "Test Panel: file://$(pwd)/test-header-functionality.html"
    echo "Frontend: http://localhost:3000"
fi

echo ""
echo -e "${GREEN}✅ Header functionality test ready!${NC}"
echo -e "${BLUE}📌 Watch the header preview in test panel and compare with actual frontend${NC}"
echo -e "${PURPLE}🔍 Expected: Header buttons should change based on login status${NC}"