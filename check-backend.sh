#!/bin/bash

echo "Checking backend status..."

# Check if backend is running on port 8080
if curl -s http://localhost:8080/api/products > /dev/null; then
    echo "✅ Backend is running on port 8080"
    echo "Testing products endpoint..."
    curl -s http://localhost:8080/api/products | head -200
else
    echo "❌ Backend is not running on port 8080"
    echo "Please start the backend first:"
    echo "./start-backend.sh"
fi