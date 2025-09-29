#!/bin/bash

echo "🚀 Starting R-Mart PostgreSQL Database..."

# Start PostgreSQL container
docker-compose up -d postgres

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Check if database is running
if docker ps | grep -q "rmart_postgres"; then
    echo "✅ Database is running successfully!"
    echo "📊 Database URL: jdbc:postgresql://localhost:5432/rmart_db"
    echo "👤 Username: postgres"
    echo "🔑 Password: password"
    echo ""
    echo "🔗 Connection details:"
    echo "   Host: localhost"
    echo "   Port: 5432"
    echo "   Database: rmart_db"
else
    echo "❌ Failed to start database"
    exit 1
fi