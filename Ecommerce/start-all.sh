#!/bin/bash

echo "🚀 Starting Rmart Ecommerce Application"
echo "======================================="
echo ""

# Function to check if a port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Port $1 is already in use"
        return 1
    else
        return 0
    fi
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 11+ first."
    exit 1
fi

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed. Please install Maven first."
    exit 1
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    exit 1
fi

echo "⚠️  Please make sure your database is configured in application.properties"

echo "✅ All prerequisites are met!"
echo ""

# Check if ports are available
echo "🔍 Checking ports..."
if ! check_port 8191; then
    echo "   Backend port 8191 is in use. Please stop the existing service."
    exit 1
fi

if ! check_port 3000; then
    echo "   Frontend port 3000 is in use. Please stop the existing service."
    exit 1
fi

echo "✅ Ports 8191 and 3000 are available!"
echo ""

# Start backend in background
echo "🔧 Starting Backend (Spring Boot)..."
cd Backend
mvn spring-boot:run > ../backend.log 2>&1 &
BACKEND_PID=$!
cd ..

echo "   Backend PID: $BACKEND_PID"
echo "   Backend logs: backend.log"

# Wait for backend to start
echo "⏳ Waiting for backend to start..."
sleep 10

# Check if backend is running
if ! curl -s http://localhost:8191/api/products > /dev/null; then
    echo "⚠️  Backend might not be ready yet. Check backend.log for details."
fi

# Start frontend
echo ""
echo "🎨 Starting Frontend (React)..."
cd Frontend/frontend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing frontend dependencies..."
    npm install
fi

echo "   Frontend will open in your browser automatically"
echo "   Frontend URL: http://localhost:3000"
echo "   Backend API: http://localhost:8191/api"
echo ""

# Start frontend (this will block)
npm start

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down applications..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo "   Backend stopped"
    fi
    echo "   Frontend stopped"
    echo "👋 Goodbye!"
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM