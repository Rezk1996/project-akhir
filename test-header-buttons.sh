#!/bin/bash

echo "🧪 Testing Header Profile/Logout Buttons"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check services
if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${RED}❌ Frontend not running${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Frontend is running${NC}"

echo ""
echo -e "${BLUE}🧪 Test Steps:${NC}"
echo "1. Open debug tool to check auth state"
echo "2. Set login state and trigger auth change"
echo "3. Check frontend header for Profile/Logout buttons"
echo "4. Clear login state and check for 'Masuk atau Daftar'"
echo ""

# Open debug tool and frontend
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🚀 Opening debug tool and frontend...${NC}"
    open debug-header-state.html
    sleep 1
    open http://localhost:3000
else
    echo -e "${YELLOW}Open these files:${NC}"
    echo "Debug: file://$(pwd)/debug-header-state.html"
    echo "Frontend: http://localhost:3000"
fi

echo ""
echo -e "${GREEN}✅ Test setup ready!${NC}"
echo -e "${BLUE}Expected: Header should show 'Profile | Logout' when logged in${NC}"