#!/bin/bash

echo "🛑 Stopping R-Mart E-commerce System..."

# Kill Java processes (Backend)
echo "🔧 Stopping Backend..."
pkill -f "spring-boot:run"
pkill -f "java.*springboot"

# Kill Node processes (Frontend & Dashboard)
echo "🛒 Stopping Frontend..."
pkill -f "react-scripts start"

echo "📊 Stopping Dashboard..."
pkill -f "npm start"

# Kill any remaining processes on ports
echo "🔌 Cleaning up ports..."
lsof -ti:8191 | xargs kill -9 2>/dev/null || true
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true

echo "✅ All services stopped!"