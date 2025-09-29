#!/bin/bash

echo "🚀 Starting R-Mart E-commerce System..."

# Setup database
echo "📊 Setting up database..."
chmod +x setup-database.sh
./setup-database.sh

# Initialize database schema
echo "🔧 Initializing database schema..."
psql -d DB_Rmart -f init-database.sql

# Start Backend
echo "🔧 Starting Backend (Port 8191)..."
cd Ecommerce/Backend
mvn clean install -DskipTests
nohup mvn spring-boot:run > ../../backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"
cd ../..

# Wait for backend to start
echo "⏳ Waiting for backend to start..."
sleep 15

# Start Frontend E-commerce
echo "🛒 Starting E-commerce Frontend (Port 3000)..."
cd Ecommerce/Frontend/frontend
npm install
nohup npm start > ../../../frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"
cd ../../..

# Start Admin Dashboard
echo "📊 Starting Admin Dashboard (Port 3001)..."
cd Dashboard_Admin
npm install
nohup npm start > ../dashboard.log 2>&1 &
DASHBOARD_PID=$!
echo "Dashboard PID: $DASHBOARD_PID"
cd ..

echo "✅ All services started!"
echo ""
echo "🌐 Access URLs:"
echo "   E-commerce: http://localhost:3000"
echo "   Admin Dashboard: http://localhost:3001"
echo "   Backend API: http://localhost:8191"
echo ""
echo "👤 Login Credentials:"
echo "   Admin: admin@rmart.com / admin123"
echo "   User: user@rmart.com / user123"
echo ""
echo "📝 Logs:"
echo "   Backend: tail -f backend.log"
echo "   Frontend: tail -f frontend.log"
echo "   Dashboard: tail -f dashboard.log"
echo ""
echo "🛑 To stop all services: ./stop-rmart.sh"