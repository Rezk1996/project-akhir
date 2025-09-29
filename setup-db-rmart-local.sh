#!/bin/bash

echo "🚀 Setting up DB_Rmart PostgreSQL Database (Local Installation)"
echo ""

# Check if PostgreSQL is installed
if command -v psql &> /dev/null; then
    echo "✅ PostgreSQL is installed"
    
    # Check if PostgreSQL service is running
    if pgrep -x "postgres" > /dev/null; then
        echo "✅ PostgreSQL service is running"
    else
        echo "❌ PostgreSQL service is not running"
        echo "Starting PostgreSQL service..."
        brew services start postgresql@14 2>/dev/null || brew services start postgresql 2>/dev/null || sudo systemctl start postgresql
    fi
    
    # Create database
    echo "📊 Creating DB_Rmart database..."
    createdb DB_Rmart 2>/dev/null || echo "Database DB_Rmart already exists"
    
    # Run initialization scripts
    echo "🔧 Running database initialization..."
    if [ -f "Ecommerce/init_db.sql" ]; then
        psql -d DB_Rmart -f Ecommerce/init_db.sql
        echo "✅ Database schema created"
    fi
    
    if [ -f "Ecommerce/sample_data.sql" ]; then
        psql -d DB_Rmart -f Ecommerce/sample_data.sql 2>/dev/null
        echo "✅ Sample data loaded"
    fi
    
    echo ""
    echo "✅ DB_Rmart database is ready!"
    echo "📊 Database Info:"
    echo "   - Host: localhost"
    echo "   - Port: 5432"
    echo "   - Database: DB_Rmart"
    echo "   - Username: $(whoami)"
    echo ""
    echo "🔗 Connection String: jdbc:postgresql://localhost:5432/DB_Rmart"
    
else
    echo "❌ PostgreSQL is not installed"
    echo ""
    echo "Please install PostgreSQL first:"
    echo "  macOS: brew install postgresql@14"
    echo "  Ubuntu: sudo apt-get install postgresql postgresql-contrib"
    echo ""
    echo "Or use Docker (make sure Docker Desktop is running):"
    echo "  bash start-db-rmart.sh"
fi