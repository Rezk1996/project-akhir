#!/bin/bash

echo "🐳 Setting up Docker Database for R-Mart..."

# Stop existing containers
echo "Stopping existing containers..."
docker-compose down

# Remove existing volume (optional - uncomment if you want fresh start)
# docker volume rm projectweb_postgres_data

# Start PostgreSQL container
echo "Starting PostgreSQL container..."
docker-compose up -d postgres

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Check if container is running
if docker ps | grep -q rmart_postgres; then
    echo "✅ PostgreSQL container is running"
    
    # Import existing backup
    echo "Importing database backup..."
    docker exec -i rmart_postgres psql -U postgres -d DB_Rmart < backups/DB_Rmart_backup_20250810_150330.sql
    
    echo "✅ Database setup complete!"
    echo ""
    echo "📊 Database Info:"
    echo "- Container: rmart_postgres"
    echo "- Database: DB_Rmart"
    echo "- Host: localhost:5432"
    echo "- Username: postgres"
    echo "- Password: password"
    echo ""
    echo "🔧 Useful commands:"
    echo "- Check status: docker-compose ps"
    echo "- View logs: docker-compose logs postgres"
    echo "- Connect to DB: docker exec -it rmart_postgres psql -U postgres -d DB_Rmart"
    echo "- Stop: docker-compose down"
else
    echo "❌ Failed to start PostgreSQL container"
    docker-compose logs postgres
fi