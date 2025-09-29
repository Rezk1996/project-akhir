#!/bin/bash

echo "🚀 Starting DB_Rmart with CONSISTENT data..."

# Stop any existing containers
docker-compose -f docker-compose-db-fixed.yml down

# Start with fixed configuration
docker-compose -f docker-compose-db-fixed.yml up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 15

# Test connection
echo "🔍 Testing database connection..."
docker exec db_rmart_postgres_fixed psql -U postgres -d DB_Rmart -c "SELECT 'Database is ready!' as status;"

echo "✅ DB_Rmart is now running with CONSISTENT data!"
echo "📊 Database Info:"
echo "   - Host: localhost"
echo "   - Port: 5432"
echo "   - Database: DB_Rmart"
echo "   - Username: postgres"
echo "   - Password: postgres"
echo ""
echo "🔗 Connection String: jdbc:postgresql://localhost:5432/DB_Rmart"
