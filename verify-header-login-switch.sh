#!/bin/bash

echo "🔍 Verifying Header Login/Logout Switch"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if frontend is running
echo -e "${BLUE}Checking frontend status...${NC}"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend is running on port 3000${NC}"
else
    echo -e "${RED}❌ Frontend is not running on port 3000${NC}"
    echo -e "${YELLOW}Please start the frontend:${NC}"
    echo "cd Ecommerce/Frontend/frontend && npm start"
    exit 1
fi

# Check if backend is running
echo -e "${BLUE}Checking backend status...${NC}"
if curl -s http://localhost:8191/api/products > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is running on port 8191${NC}"
else
    echo -e "${RED}❌ Backend is not running on port 8191${NC}"
    echo -e "${YELLOW}Please start the backend:${NC}"
    echo "cd Ecommerce/Backend && mvn spring-boot:run"
    exit 1
fi

echo ""
echo -e "${BLUE}🧪 Test Instructions:${NC}"
echo "1. Open the test file to simulate login states"
echo "2. Check the frontend header behavior"
echo "3. Verify the login/logout switch works correctly"
echo ""

# Open test file if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🚀 Opening test file...${NC}"
    open test-login-header-switch.html
    echo -e "${GREEN}🌐 Opening frontend...${NC}"
    open http://localhost:3000
else
    echo -e "${YELLOW}📁 Open this file in your browser:${NC}"
    echo "file://$(pwd)/test-login-header-switch.html"
    echo ""
    echo -e "${YELLOW}🌐 Open the frontend:${NC}"
    echo "http://localhost:3000"
fi

echo ""
echo -e "${GREEN}✅ Verification setup complete!${NC}"
echo ""
echo -e "${BLUE}Expected Behavior:${NC}"
echo -e "${GREEN}• Logout State:${NC} Header shows 'Masuk atau Daftar' button"
echo -e "${GREEN}• Login State:${NC} Header shows profile icon (👤)"
echo -e "${GREEN}• Profile Menu:${NC} Clicking icon opens dropdown with user info"
echo -e "${GREEN}• Persistence:${NC} State persists after page refresh"