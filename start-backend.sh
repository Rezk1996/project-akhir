#!/bin/bash

echo "🚀 Starting R-Mart Backend (Spring Boot)..."

# Check if backend is already running
if lsof -i :8191 > /dev/null 2>&1; then
    echo "✅ Backend already running on port 8191"
    echo "🔗 Backend URL: http://localhost:8191"
    exit 0
fi

# Navigate to backend directory
cd Ecommerce/Backend

echo "📦 Building backend..."
mvn clean compile -q

echo "🔧 Starting Spring Boot application..."
nohup mvn spring-boot:run > ../../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../../backend.pid

echo "⏳ Waiting for backend to start..."
sleep 15

# Check if backend is running
if lsof -i :8191 > /dev/null 2>&1; then
    echo "✅ Backend started successfully!"
    echo "🔗 Backend URL: http://localhost:8191"
    echo "📋 PID: $BACKEND_PID"
    echo "📄 Logs: tail -f backend.log"
else
    echo "❌ Backend failed to start. Check backend.log for details."
    exit 1
fi