#!/bin/bash

echo "🛑 Stopping R-Mart E-commerce Project..."

# Stop Backend (Spring Boot)
echo "🔧 Stopping Backend..."
lsof -ti:8191 | xargs kill 2>/dev/null || echo "Backend not running"

# Stop Frontend (React)
echo "🌐 Stopping Frontend..."
lsof -ti:3000 | xargs kill 2>/dev/null || echo "Frontend not running"

# Stop Dashboard (React)
echo "📊 Stopping Dashboard..."
lsof -ti:3001 | xargs kill 2>/dev/null || echo "Dashboard not running"

# Optional: Stop PostgreSQL container
read -p "🗄️  Stop PostgreSQL container? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗄️  Stopping PostgreSQL..."
    docker stop rmart_postgres
else
    echo "🗄️  PostgreSQL container kept running"
fi

echo "✅ All services stopped!"