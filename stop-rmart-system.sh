#!/bin/bash

echo "🛑 Stopping R-Mart E-commerce System"
echo "===================================="

# Function to stop process by PID file
stop_by_pid() {
    local service_name=$1
    local pid_file=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo "🛑 Stopping $service_name (PID: $pid)..."
            kill "$pid"
            rm -f "$pid_file"
            echo "✅ $service_name stopped"
        else
            echo "⚠️  $service_name PID file exists but process not running"
            rm -f "$pid_file"
        fi
    else
        echo "ℹ️  $service_name not running (no PID file)"
    fi
}

# Function to stop process by port
stop_by_port() {
    local service_name=$1
    local port=$2
    
    local pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        echo "🛑 Stopping $service_name on port $port (PID: $pid)..."
        kill "$pid"
        echo "✅ $service_name stopped"
    else
        echo "ℹ️  No process running on port $port"
    fi
}

# Stop all services
echo "🔄 Stopping all R-Mart services..."

# Stop backend
stop_by_pid "Backend" "backend.pid"
stop_by_port "Backend" "8191"

# Stop frontend
stop_by_pid "Frontend" "frontend.pid"
stop_by_port "Frontend" "3000"

# Stop dashboard
stop_by_pid "Dashboard" "dashboard.pid"
stop_by_port "Dashboard" "3001"

# Stop database (optional - comment out if you want to keep it running)
echo ""
echo "📊 Database options:"
echo "   Database will remain running for other uses"
echo "   To stop PostgreSQL: brew services stop postgresql@14"

echo ""
echo "✅ R-Mart system stopped successfully!"
echo ""
echo "📋 Cleanup completed:"
echo "   - All application processes stopped"
echo "   - PID files removed"
echo "   - Ports freed: 3000, 3001, 8191"
echo ""
echo "🔄 To restart: bash run-rmart-system.sh"