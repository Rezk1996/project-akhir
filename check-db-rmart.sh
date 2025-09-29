#!/bin/bash

echo "🔍 Checking DB_Rmart Database Status..."

# Check if container is running
if docker ps | grep -q "db_rmart_postgres"; then
    echo "✅ Container is running"
    
    # Check database connection
    echo "🔗 Testing database connection..."
    docker exec db_rmart_postgres psql -U postgres -d DB_Rmart -c "SELECT version();"
    
    # Show database tables
    echo "📋 Database tables:"
    docker exec db_rmart_postgres psql -U postgres -d DB_Rmart -c "\dt"
    
    # Show some sample data
    echo "📊 Sample data from barang table:"
    docker exec db_rmart_postgres psql -U postgres -d DB_Rmart -c "SELECT id, nama_barang, harga_jual, stok FROM barang LIMIT 5;"
    
else
    echo "❌ Container is not running"
    echo "To start the database, run: ./start-db-rmart.sh"
fi