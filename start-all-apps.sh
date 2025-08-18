#!/bin/bash

echo "🚀 Starting all applications..."

# Function to check if port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Port $1 is already in use"
        return 1
    else
        return 0
    fi
}

# Check required ports
echo "📋 Checking ports..."
check_port 8191 || echo "Backend might already be running"
check_port 3000 || echo "Frontend might already be running"  
check_port 3001 || echo "Admin Dashboard might already be running"

# Start backend
echo "🔧 Starting Backend (Spring Boot)..."
cd Ecommerce/Backend
gnome-terminal --tab --title="Backend" -- bash -c "mvn spring-boot:run; exec bash" &
cd ../..

# Wait a bit for backend to start
sleep 5

# Start frontend ecommerce
echo "🛒 Starting Frontend Ecommerce..."
cd Ecommerce/Frontend/frontend
gnome-terminal --tab --title="Frontend" -- bash -c "npm start; exec bash" &
cd ../../..

# Start admin dashboard
echo "👨‍💼 Starting Admin Dashboard..."
cd Dashboard_Admin
gnome-terminal --tab --title="Admin Dashboard" -- bash -c "npm start; exec bash" &
cd ..

echo "✅ All applications are starting..."
echo ""
echo "📱 Applications will be available at:"
echo "   🔧 Backend API: http://localhost:8191"
echo "   🛒 Frontend Ecommerce: http://localhost:3000"
echo "   👨‍💼 Admin Dashboard: http://localhost:3001"
echo ""
echo "🔑 Admin Login:"
echo "   Email: admin@rmart.com"
echo "   Password: admin123"
echo ""
echo "⏳ Please wait for all applications to fully load..."