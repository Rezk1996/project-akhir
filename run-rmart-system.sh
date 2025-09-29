#!/bin/bash

echo "🚀 R-Mart E-commerce System Launcher"
echo "===================================="

# Function to check if a port is in use
check_port() {
    lsof -i :$1 > /dev/null 2>&1
    return $?
}

# Function to start database
start_database() {
    echo "📊 Starting Database..."
    
    # Test if PostgreSQL is already running
    if psql -d DB_Rmart -c "SELECT 1;" > /dev/null 2>&1; then
        echo "✅ Database DB_Rmart is already running!"
    else
        echo "🔄 Starting PostgreSQL..."
        bash start-database.sh
    fi
}

# Function to start backend
start_backend() {
    echo ""
    echo "🔧 Starting Backend (Spring Boot)..."
    
    if check_port 8191; then
        echo "✅ Backend already running on port 8191"
    else
        echo "🚀 Starting Spring Boot backend..."
        cd Ecommerce/Backend
        nohup mvn spring-boot:run > ../../backend.log 2>&1 &
        echo $! > ../../backend.pid
        cd ../..
        echo "⏳ Backend starting... (check backend.log for details)"
    fi
}

# Function to start frontend
start_frontend() {
    echo ""
    echo "🎨 Starting Frontend (React E-commerce)..."
    
    if check_port 3000; then
        echo "✅ Frontend already running on port 3000"
    else
        echo "🚀 Starting React frontend..."
        cd Ecommerce/Frontend/frontend
        nohup npm start > ../../../frontend.log 2>&1 &
        echo $! > ../../../frontend.pid
        cd ../../..
        echo "⏳ Frontend starting... (check frontend.log for details)"
    fi
}

# Function to start admin dashboard
start_dashboard() {
    echo ""
    echo "📊 Starting Admin Dashboard..."
    
    if check_port 3001; then
        echo "✅ Dashboard already running on port 3001"
    else
        echo "🚀 Starting Admin Dashboard..."
        cd Dashboard_Admin
        nohup npm start > ../dashboard.log 2>&1 &
        echo $! > ../dashboard.pid
        cd ..
        echo "⏳ Dashboard starting... (check dashboard.log for details)"
    fi
}

# Function to show system status
show_status() {
    echo ""
    echo "🎉 R-Mart System Status"
    echo "======================"
    
    # Database status
    if psql -d DB_Rmart -c "SELECT 1;" > /dev/null 2>&1; then
        echo "✅ Database: Running (PostgreSQL - DB_Rmart)"
    else
        echo "❌ Database: Not running"
    fi
    
    # Backend status
    if check_port 8191; then
        echo "✅ Backend: Running (http://localhost:8191)"
    else
        echo "❌ Backend: Not running"
    fi
    
    # Frontend status
    if check_port 3000; then
        echo "✅ Frontend: Running (http://localhost:3000)"
    else
        echo "❌ Frontend: Not running"
    fi
    
    # Dashboard status
    if check_port 3001; then
        echo "✅ Dashboard: Running (http://localhost:3001)"
    else
        echo "❌ Dashboard: Not running"
    fi
    
    echo ""
    echo "🔗 Quick Links:"
    echo "   🛒 E-commerce: http://localhost:3000"
    echo "   📊 Admin Dashboard: http://localhost:3001"
    echo "   🔧 Backend API: http://localhost:8191"
    echo ""
    echo "📋 Useful Commands:"
    echo "   Stop all: bash stop-rmart-system.sh"
    echo "   View logs: tail -f backend.log frontend.log dashboard.log"
    echo "   Database: psql -d DB_Rmart"
}

# Main execution
echo "🔍 Checking system requirements..."

# Check if required tools are installed
if ! command -v psql > /dev/null 2>&1; then
    echo "❌ PostgreSQL not found. Please install PostgreSQL first."
    exit 1
fi

if ! command -v mvn > /dev/null 2>&1; then
    echo "❌ Maven not found. Please install Maven first."
    exit 1
fi

if ! command -v npm > /dev/null 2>&1; then
    echo "❌ Node.js/npm not found. Please install Node.js first."
    exit 1
fi

echo "✅ All requirements met!"
echo ""

# Start all services
start_database
start_backend
start_frontend
start_dashboard

# Wait a moment for services to start
echo ""
echo "⏳ Waiting for services to initialize..."
sleep 10

# Show final status
show_status

echo "🎊 R-Mart system is ready to use!"