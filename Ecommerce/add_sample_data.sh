#!/bin/bash

echo "Adding sample data to Rmart..."

# Add categories
curl -X POST http://localhost:8191/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Electronics", "image": "https://cdn-icons-png.flaticon.com/512/2553/2553645.png", "iconColor": "#3498db"}'

curl -X POST http://localhost:8191/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Fashion", "image": "https://cdn-icons-png.flaticon.com/512/2553/2553644.png", "iconColor": "#e74c3c"}'

curl -X POST http://localhost:8191/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Books", "image": "https://cdn-icons-png.flaticon.com/512/2232/2232688.png", "iconColor": "#f39c12"}'

echo "Sample data added successfully!"