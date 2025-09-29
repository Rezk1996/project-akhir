#!/bin/bash

echo "🚀 Starting R-Mart Database with Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Stop existing containers if running
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose-database.yml down

# Remove old volumes if needed (uncomment if you want fresh database)
# echo "🗑️ Removing old database volumes..."
# docker volume rm projectweb_rmart_postgres_data 2>/dev/null || true

# Start database services
echo "🐘 Starting PostgreSQL database..."
docker-compose -f docker-compose-database.yml up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Check database health
echo "🔍 Checking database connection..."
for i in {1..30}; do
    if docker exec rmart_database pg_isready -U postgres -d DB_Rmart > /dev/null 2>&1; then
        echo "✅ Database is ready!"
        break
    fi
    echo "⏳ Waiting for database... ($i/30)"
    sleep 2
done

# Show connection info
echo ""
echo "🎉 R-Mart Database is running!"
echo "📊 Database Connection Info:"
echo "   Host: localhost"
echo "   Port: 5432"
echo "   Database: DB_Rmart"
echo "   Username: postgres"
echo "   Password: postgres"
echo ""
echo "🔧 pgAdmin Web Interface:"
echo "   URL: http://localhost:8080"
echo "   Email: admin@rmart.com"
echo "   Password: admin123"
echo ""
echo "📝 To connect from your application, use:"
echo "   jdbc:postgresql://localhost:5432/DB_Rmart"
echo ""
echo "🛑 To stop the database:"
echo "   docker-compose -f docker-compose-database.yml down"
echo ""
echo "📋 To view logs:"
echo "   docker-compose -f docker-compose-database.yml logs -f"