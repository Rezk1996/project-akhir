#!/bin/bash

echo "Starting Rmart Ecommerce Frontend..."
echo "===================================="

# Navigate to frontend directory
cd Frontend/frontend

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm first."
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

echo "Starting React development server..."
echo "Frontend will be available at: http://localhost:3000"
echo ""

# Start the React development server
npm start