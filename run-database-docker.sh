#!/bin/bash

echo "🚀 Starting R-Mart Database with Docker..."

# Wait for Docker to be ready
echo "Waiting for Docker to be ready..."
while ! docker info > /dev/null 2>&1; do
    echo "Docker is not ready yet, waiting..."
    sleep 5
done

echo "✅ Docker is ready!"

# Stop existing container if running
echo "Stopping existing container..."
docker stop rmart_postgres 2>/dev/null || true
docker rm rmart_postgres 2>/dev/null || true

# Run PostgreSQL container directly
echo "Starting PostgreSQL container..."
docker run -d \
  --name rmart_postgres \
  -e POSTGRES_DB=DB_Rmart \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:14

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 15

# Check if container is running
if docker ps | grep -q rmart_postgres; then
    echo "✅ Database container is running!"
    
    # Test connection
    echo "Testing database connection..."
    docker exec rmart_postgres pg_isready -U postgres -d DB_Rmart
    
    if [ $? -eq 0 ]; then
        echo "✅ Database DB_Rmart is ready!"
        
        # Restore backup if exists
        if [ -f "backups/DB_Rmart_backup_20250810_150330.sql" ]; then
            echo "Restoring database from backup..."
            docker exec -i rmart_postgres psql -U postgres -d DB_Rmart < backups/DB_Rmart_backup_20250810_150330.sql
            echo "✅ Database restored successfully!"
        fi
        
        echo ""
        echo "📊 Database Info:"
        echo "   Host: localhost"
        echo "   Port: 5432"
        echo "   Database: DB_Rmart"
        echo "   Username: postgres"
        echo "   Password: postgres"
        echo ""
        echo "🔗 Connection String: postgresql://postgres:postgres@localhost:5432/DB_Rmart"
    else
        echo "❌ Database connection failed!"
        exit 1
    fi
else
    echo "❌ Failed to start database container!"
    exit 1
fi