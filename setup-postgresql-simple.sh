#!/bin/bash

echo "🔧 Setting up PostgreSQL (Simple Method)..."

# Uninstall existing PostgreSQL
brew services stop postgresql@14 2>/dev/null
brew uninstall postgresql@14 2>/dev/null

# Install fresh PostgreSQL
echo "📦 Installing PostgreSQL..."
brew install postgresql@14

# Initialize database
echo "🔧 Initializing PostgreSQL..."
/opt/homebrew/bin/initdb -D /opt/homebrew/var/postgresql@14

# Start PostgreSQL
echo "🚀 Starting PostgreSQL..."
brew services start postgresql@14

# Wait for startup
sleep 5

# Create database
echo "📊 Creating database..."
/opt/homebrew/bin/createdb DB_Rmart

# Initialize schema
echo "🔧 Setting up schema..."
/opt/homebrew/bin/psql -d DB_Rmart -f init-database.sql

# Test connection
echo "🔍 Testing connection..."
if /opt/homebrew/bin/psql -d DB_Rmart -c "SELECT COUNT(*) FROM users;" > /dev/null 2>&1; then
    echo "✅ Database connection: SUCCESS!"
    echo "📊 Database: DB_Rmart"
    echo "🌐 URL: jdbc:postgresql://localhost:5432/DB_Rmart"
else
    echo "❌ Database connection: FAILED"
fi

echo "🏁 Setup completed!"