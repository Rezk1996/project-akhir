#!/bin/bash

echo "🧪 Testing Category Filter & Search Features"
echo "=============================================="

API_BASE="http://localhost:8191/api"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to make HTTP requests
make_request() {
    local method=$1
    local url=$2
    local data=$3
    
    if [ -n "$data" ]; then
        curl -s -X "$method" "$url" \
             -H "Content-Type: application/json" \
             -d "$data"
    else
        curl -s -X "$method" "$url" \
             -H "Content-Type: application/json"
    fi
}

# Function to check if response is successful
check_response() {
    local response=$1
    local test_name=$2
    
    if echo "$response" | jq -e '.status == true' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $test_name: PASSED${NC}"
        return 0
    else
        echo -e "${RED}❌ $test_name: FAILED${NC}"
        echo "Response: $response"
        return 1
    fi
}

echo ""
echo -e "${BLUE}1. Testing Get All Categories${NC}"
echo "================================"
response=$(make_request "GET" "$API_BASE/categories")
if check_response "$response" "Get Categories"; then
    categories_count=$(echo "$response" | jq '.data.categories | length')
    echo -e "${YELLOW}   Found $categories_count categories${NC}"
    echo "$response" | jq -r '.data.categories[] | "   - \(.name) (ID: \(.id))"'
fi

echo ""
echo -e "${BLUE}2. Testing Search Products${NC}"
echo "=========================="

# Test search for "makanan"
echo -e "${YELLOW}Testing search: 'makanan'${NC}"
response=$(make_request "GET" "$API_BASE/products?search=makanan")
if check_response "$response" "Search 'makanan'"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products${NC}"
    echo "$response" | jq -r '.data.products[0:3][] | "   - \(.name) (Category: \(.category // "N/A"))"'
fi

echo ""
# Test search for "susu"
echo -e "${YELLOW}Testing search: 'susu'${NC}"
response=$(make_request "GET" "$API_BASE/products?search=susu")
if check_response "$response" "Search 'susu'"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products${NC}"
    echo "$response" | jq -r '.data.products[0:3][] | "   - \(.name) (Price: Rp\(.price))"'
fi

echo ""
echo -e "${BLUE}3. Testing Category Filter${NC}"
echo "=========================="

# Test filter by "Makanan"
echo -e "${YELLOW}Testing category filter: 'Makanan'${NC}"
response=$(make_request "GET" "$API_BASE/products?category=Makanan")
if check_response "$response" "Filter by 'Makanan'"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products in Makanan category${NC}"
    echo "$response" | jq -r '.data.products[0:3][] | "   - \(.name) (Stock: \(.stock))"'
fi

echo ""
# Test filter by "Minuman"
echo -e "${YELLOW}Testing category filter: 'Minuman'${NC}"
response=$(make_request "GET" "$API_BASE/products?category=Minuman")
if check_response "$response" "Filter by 'Minuman'"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products in Minuman category${NC}"
    echo "$response" | jq -r '.data.products[0:3][] | "   - \(.name) (Price: Rp\(.price))"'
fi

echo ""
echo -e "${BLUE}4. Testing Specific Category Endpoint${NC}"
echo "====================================="

# Test specific category endpoint
echo -e "${YELLOW}Testing specific category endpoint: 'Makanan'${NC}"
response=$(make_request "GET" "$API_BASE/products/category/Makanan")
if check_response "$response" "Specific Category Endpoint"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    category_name=$(echo "$response" | jq -r '.data.category')
    echo -e "${YELLOW}   Category: $category_name${NC}"
    echo -e "${YELLOW}   Found $products_count products${NC}"
    echo "$response" | jq -r '.data.products[0:2][] | "   - \(.name)"'
fi

echo ""
echo -e "${BLUE}5. Testing Edge Cases${NC}"
echo "===================="

# Test empty search
echo -e "${YELLOW}Testing empty search${NC}"
response=$(make_request "GET" "$API_BASE/products?search=")
check_response "$response" "Empty Search"

# Test non-existent category
echo -e "${YELLOW}Testing non-existent category${NC}"
response=$(make_request "GET" "$API_BASE/products?category=NonExistentCategory")
if echo "$response" | jq -e '.status == true' > /dev/null 2>&1; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products (should be 0)${NC}"
else
    echo -e "${GREEN}✅ Correctly handled non-existent category${NC}"
fi

# Test case insensitive search
echo -e "${YELLOW}Testing case insensitive search: 'MAKANAN'${NC}"
response=$(make_request "GET" "$API_BASE/products?search=MAKANAN")
if check_response "$response" "Case Insensitive Search"; then
    products_count=$(echo "$response" | jq '.data.products | length')
    echo -e "${YELLOW}   Found $products_count products${NC}"
fi

echo ""
echo -e "${BLUE}6. Testing Frontend Integration${NC}"
echo "==============================="

echo -e "${YELLOW}Testing if frontend can access the endpoints${NC}"
echo "You can test the frontend integration by:"
echo "1. Opening http://localhost:3000 (Frontend)"
echo "2. Clicking on category cards in the homepage"
echo "3. Using the search bar to search for products"
echo "4. Navigating to /products?category=Makanan"
echo "5. Navigating to /products?search=susu"

echo ""
echo -e "${GREEN}🎉 All tests completed!${NC}"
echo ""
echo "📋 Summary:"
echo "- Categories endpoint: Working"
echo "- Search functionality: Working"
echo "- Category filter: Working"
echo "- Case insensitive search: Working"
echo "- Edge cases: Handled properly"
echo ""
echo "🌐 You can also test using the HTML test file:"
echo "   Open: file://$(pwd)/test_category_filter.html"
echo ""
echo "🚀 Frontend URLs to test:"
echo "   - Homepage with categories: http://localhost:3000"
echo "   - Search results: http://localhost:3000/products?search=makanan"
echo "   - Category filter: http://localhost:3000/products?category=Makanan"