#!/bin/bash

echo "🔍 Checking Docker status..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    echo "📥 Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running"
    echo "🚀 Please start Docker Desktop application"
    echo "💡 Look for Docker icon in your system tray/menu bar"
    exit 1
fi

echo "✅ Docker is running!"

# Check if database container exists
if docker ps -a --format "table {{.Names}}" | grep -q "rmart_database"; then
    if docker ps --format "table {{.Names}}" | grep -q "rmart_database"; then
        echo "✅ R-Mart database container is running"
        echo "📊 Connection info:"
        echo "   Host: localhost:5432"
        echo "   Database: DB_Rmart"
        echo "   Username: postgres"
        echo "   Password: postgres"
    else
        echo "⚠️  R-Mart database container exists but not running"
        echo "🚀 Start with: bash start-database-docker.sh"
    fi
else
    echo "ℹ️  R-Mart database container not found"
    echo "🚀 Create and start with: bash start-database-docker.sh"
fi

# Show running containers
echo ""
echo "🐳 Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"