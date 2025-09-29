#!/bin/bash

echo "🔧 Setting up PostgreSQL Database for R-Mart..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL not found. Installing via Homebrew..."
    brew install postgresql
fi

# Start PostgreSQL service
echo "🚀 Starting PostgreSQL service..."
brew services start postgresql

# Wait for PostgreSQL to start
sleep 3

# Create database
echo "📊 Creating database DB_Rmart..."
createdb DB_Rmart 2>/dev/null || echo "Database already exists"

# Create user and set password
echo "👤 Setting up database user..."
psql -d DB_Rmart -c "CREATE USER postgres WITH PASSWORD 'postgres';" 2>/dev/null || echo "User already exists"
psql -d DB_Rmart -c "ALTER USER postgres CREATEDB;" 2>/dev/null
psql -d DB_Rmart -c "GRANT ALL PRIVILEGES ON DATABASE \"DB_Rmart\" TO postgres;" 2>/dev/null

echo "✅ Database setup completed!"
echo "📍 Database URL: jdbc:postgresql://localhost:5432/DB_Rmart"
echo "👤 Username: postgres"
echo "🔑 Password: postgres"