#!/bin/bash

echo "🚀 Starting DB_Rmart PostgreSQL Database in Docker..."

# Stop existing container if running
echo "Stopping existing container..."
docker-compose -f docker-compose-db.yml down

# Remove old volume if exists (optional - uncomment if you want fresh database)
# echo "Removing old database volume..."
# docker volume rm projectweb_db_rmart_data

# Start PostgreSQL container
echo "Starting PostgreSQL container..."
docker-compose -f docker-compose-db.yml up -d

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Check if database is running
echo "Checking database status..."
docker-compose -f docker-compose-db.yml ps

# Test database connection
echo "Testing database connection..."
docker exec db_rmart_postgres psql -U postgres -d DB_Rmart -c "SELECT 'Database DB_Rmart is ready!' as status;"

echo "✅ DB_Rmart database is now running!"
echo "📊 Database Info:"
echo "   - Host: localhost"
echo "   - Port: 5432"
echo "   - Database: DB_Rmart"
echo "   - Username: postgres"
echo "   - Password: postgres"
echo ""
echo "🔗 Connection String: jdbc:postgresql://localhost:5432/DB_Rmart"
echo ""
echo "To stop the database, run: docker-compose -f docker-compose-db.yml down"