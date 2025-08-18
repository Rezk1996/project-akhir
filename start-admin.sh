#!/bin/bash

echo "🚀 Starting Rmart Admin Dashboard..."

# Check if node_modules exists
if [ ! -d "Dashboard_Admin/node_modules" ]; then
    echo "📦 Installing dependencies..."
    cd Dashboard_Admin
    npm install
    cd ..
fi

# Start admin dashboard
echo "🌐 Starting admin dashboard on http://localhost:3000"
cd Dashboard_Admin
npm start