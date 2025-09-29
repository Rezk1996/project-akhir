#!/bin/bash

echo "🔍 Checking R-Mart Database Status..."

# Check if container is running
if docker ps | grep -q rmart_postgres; then
    echo "✅ Database container is running"
    
    # Test connection
    docker exec rmart_postgres pg_isready -U postgres -d DB_Rmart
    
    if [ $? -eq 0 ]; then
        echo "✅ Database connection is healthy"
        
        # Show database info
        echo ""
        echo "📊 Database Statistics:"
        docker exec rmart_postgres psql -U postgres -d DB_Rmart -c "
        SELECT 
            schemaname,
            tablename,
            n_tup_ins as inserts,
            n_tup_upd as updates,
            n_tup_del as deletes
        FROM pg_stat_user_tables 
        WHERE schemaname = 'public'
        ORDER BY tablename;
        "
        
        echo ""
        echo "📋 Available Tables:"
        docker exec rmart_postgres psql -U postgres -d DB_Rmart -c "\dt"
        
    else
        echo "❌ Database connection failed"
    fi
else
    echo "❌ Database container is not running"
    echo "Run: bash run-database-docker.sh to start the database"
fi