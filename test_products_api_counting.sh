#!/bin/bash

# Test Products API and Count Results
# This script tests all product endpoints and counts the results

echo "🧪 Testing Products API and Counting Results"
echo "============================================="

BASE_URL="http://localhost:8191/api"
RESULTS_FILE="api_test_results.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test API endpoint and count results
test_endpoint() {
    local endpoint="$1"
    local description="$2"
    local expected_field="$3"
    
    echo -e "\n${BLUE}Testing: $description${NC}"
    echo "Endpoint: $endpoint"
    
    response=$(curl -s -w "\n%{http_code}" "$endpoint")
    http_code=$(echo "$response" | tail -n1)
    json_response=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "200" ]; then
        echo -e "${GREEN}✅ HTTP Status: $http_code${NC}"
        
        # Parse JSON and count results
        if command -v jq &> /dev/null; then
            # Count using jq
            if [ "$expected_field" = "products" ]; then
                count=$(echo "$json_response" | jq -r '.data.products | length // 0')
                total=$(echo "$json_response" | jq -r '.data.totalElements // 0')
                echo -e "${GREEN}📊 Products Count: $count${NC}"
                echo -e "${GREEN}📊 Total Elements: $total${NC}"
            elif [ "$expected_field" = "categories" ]; then
                count=$(echo "$json_response" | jq -r '.data | length // 0')
                echo -e "${GREEN}📊 Categories Count: $count${NC}"
            elif [ "$expected_field" = "single" ]; then
                name=$(echo "$json_response" | jq -r '.data.name // "N/A"')
                category=$(echo "$json_response" | jq -r '.data.category // "N/A"')
                echo -e "${GREEN}📊 Product Name: $name${NC}"
                echo -e "${GREEN}📊 Category: $category${NC}"
            fi
            
            # Show sample data
            echo -e "${YELLOW}📋 Sample Response:${NC}"
            echo "$json_response" | jq '.' | head -20
        else
            # Count without jq (basic counting)
            if [[ "$json_response" == *"products"* ]]; then
                count=$(echo "$json_response" | grep -o '"id"' | wc -l)
                echo -e "${GREEN}📊 Estimated Count: $count${NC}"
            fi
            echo -e "${YELLOW}📋 Raw Response (first 500 chars):${NC}"
            echo "$json_response" | head -c 500
        fi
    else
        echo -e "${RED}❌ HTTP Status: $http_code${NC}"
        echo -e "${RED}Error Response: $json_response${NC}"
    fi
    
    echo "----------------------------------------"
}

# Check if backend is running
echo "🔍 Checking if backend is running..."
if ! curl -s "$BASE_URL/products" > /dev/null; then
    echo -e "${RED}❌ Backend is not running on port 8191${NC}"
    echo "Please start the backend first:"
    echo "cd Ecommerce/Backend && mvn spring-boot:run"
    exit 1
fi

echo -e "${GREEN}✅ Backend is running${NC}"

# Test all product endpoints
echo -e "\n🚀 Starting API Tests..."

# 1. Test all products
test_endpoint "$BASE_URL/products" "Get All Products" "products"

# 2. Test products with category filter
test_endpoint "$BASE_URL/products?category=Makanan" "Filter by Category (Makanan)" "products"

# 3. Test products with search
test_endpoint "$BASE_URL/products?search=susu" "Search Products (susu)" "products"

# 4. Test products with both category and search
test_endpoint "$BASE_URL/products?category=Minuman&search=teh" "Category + Search Filter" "products"

# 5. Test categories endpoint
test_endpoint "$BASE_URL/categories" "Get All Categories" "categories"

# 6. Test products by category path
test_endpoint "$BASE_URL/products/category/Makanan" "Products by Category Path" "products"

# 7. Test single product (assuming ID 1 exists)
test_endpoint "$BASE_URL/products/1" "Get Single Product (ID: 1)" "single"

# 8. Test refresh products
test_endpoint "$BASE_URL/products/refresh" "Refresh Products" "refresh"

# 9. Test image test endpoint
test_endpoint "$BASE_URL/images/test" "Image Test Endpoint" "test"

# Summary
echo -e "\n${BLUE}📊 TEST SUMMARY${NC}"
echo "================="

# Get final counts
echo "Getting final product and category counts..."

if command -v jq &> /dev/null; then
    # Get total products
    products_response=$(curl -s "$BASE_URL/products")
    total_products=$(echo "$products_response" | jq -r '.data.totalElements // 0')
    
    # Get total categories
    categories_response=$(curl -s "$BASE_URL/categories")
    total_categories=$(echo "$categories_response" | jq -r '.data | length // 0')
    
    echo -e "${GREEN}📦 Total Products in Database: $total_products${NC}"
    echo -e "${GREEN}🏷️  Total Categories in Database: $total_categories${NC}"
    
    # Test specific category counts
    echo -e "\n${YELLOW}📊 Products by Category:${NC}"
    categories=$(echo "$categories_response" | jq -r '.data[].name')
    
    while IFS= read -r category; do
        if [ ! -z "$category" ] && [ "$category" != "null" ]; then
            cat_response=$(curl -s "$BASE_URL/products?category=$category")
            cat_count=$(echo "$cat_response" | jq -r '.data.totalElements // 0')
            echo -e "${BLUE}  - $category: $cat_count products${NC}"
        fi
    done <<< "$categories"
    
else
    echo -e "${YELLOW}⚠️  Install 'jq' for detailed JSON parsing${NC}"
    echo "brew install jq  # on macOS"
fi

# Save results to file
echo -e "\n💾 Saving results to $RESULTS_FILE..."
{
    echo "{"
    echo "  \"timestamp\": \"$(date -Iseconds)\","
    echo "  \"backend_url\": \"$BASE_URL\","
    echo "  \"tests_completed\": true"
    echo "}"
} > "$RESULTS_FILE"

echo -e "${GREEN}✅ API testing completed!${NC}"
echo -e "${BLUE}Results saved to: $RESULTS_FILE${NC}"

# Quick verification
echo -e "\n🔍 Quick Verification Commands:"
echo "curl -s \"$BASE_URL/products\" | jq '.data.totalElements'"
echo "curl -s \"$BASE_URL/categories\" | jq '.data | length'"
echo "curl -s \"$BASE_URL/products?category=Makanan\" | jq '.data.totalElements'"