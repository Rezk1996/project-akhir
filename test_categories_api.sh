#!/bin/bash

echo "🧪 Testing Categories API for Admin Dashboard"
echo "============================================="

API_BASE="http://localhost:8191/api"

echo "1. Testing GET /api/admin/categories"
echo "-----------------------------------"
curl -X GET "$API_BASE/admin/categories" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n" \
  2>/dev/null | jq '.' || echo "Response received (not JSON formatted)"

echo -e "\n2. Testing POST /api/admin/categories (Create new category)"
echo "--------------------------------------------------------"
curl -X POST "$API_BASE/admin/categories" \
  -H "Content-Type: application/json" \
  -d '{
    "namaJenis": "Test Category",
    "image": "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400",
    "iconColor": "#FF6B6B"
  }' \
  -w "\nStatus: %{http_code}\n" \
  2>/dev/null | jq '.' || echo "Response received (not JSON formatted)"

echo -e "\n3. Adding Indonesian Categories"
echo "------------------------------"

categories=(
  '{"namaJenis": "Makanan", "image": "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400", "iconColor": "#FF6B6B"}'
  '{"namaJenis": "Minuman & Beverage", "image": "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400", "iconColor": "#4ECDC4"}'
  '{"namaJenis": "Kebutuhan Ibu & Anak", "image": "https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400", "iconColor": "#45B7D1"}'
  '{"namaJenis": "Personal Care", "image": "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400", "iconColor": "#96CEB4"}'
  '{"namaJenis": "Household", "image": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400", "iconColor": "#FFEAA7"}'
)

for category in "${categories[@]}"; do
  echo "Adding category: $(echo $category | jq -r '.namaJenis')"
  curl -X POST "$API_BASE/admin/categories" \
    -H "Content-Type: application/json" \
    -d "$category" \
    -w "\nStatus: %{http_code}\n" \
    2>/dev/null | jq '.message' || echo "Added"
  echo ""
done

echo -e "\n4. Final check - GET all categories"
echo "----------------------------------"
curl -X GET "$API_BASE/admin/categories" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n" \
  2>/dev/null | jq '.data.categories[] | {id, name, iconColor}' || echo "Categories retrieved"

echo -e "\n✅ Categories API Test Complete!"
echo "Now check the Admin Dashboard Categories page at: http://localhost:3001"