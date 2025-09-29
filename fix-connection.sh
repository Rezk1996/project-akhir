#!/bin/bash

echo "🔧 Fixing Database Connection..."

# Stop existing PostgreSQL
brew services stop postgresql@14
brew services stop postgresql

# Start PostgreSQL
echo "🚀 Starting PostgreSQL..."
brew services start postgresql

# Wait for PostgreSQL to start
sleep 5

# Create database if not exists
echo "📊 Creating database..."
createdb DB_Rmart 2>/dev/null || echo "Database already exists"

# Initialize database
echo "🔧 Initializing database schema..."
psql -d DB_Rmart -f init-database.sql

# Test connection
echo "🔍 Testing connection..."
if psql -d DB_Rmart -c "SELECT COUNT(*) FROM users;" > /dev/null 2>&1; then
    echo "✅ Database connection: OK"
else
    echo "❌ Database connection: FAILED"
fi

echo "🏁 Fix completed!"