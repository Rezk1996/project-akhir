#!/bin/bash

echo "🚀 Starting R-Mart Database (Local PostgreSQL)..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install PostgreSQL manually."
        exit 1
    fi
    brew install postgresql@14
fi

# Start PostgreSQL service
echo "Starting PostgreSQL service..."
brew services start postgresql@14

# Wait for service to start
sleep 3

# Create database if not exists
echo "Creating database DB_Rmart..."
createdb DB_Rmart 2>/dev/null || echo "Database DB_Rmart already exists"

# Restore from backup
echo "Restoring database from backup..."
if [ -f "backups/DB_Rmart_backup_20250810_150330.sql" ]; then
    psql -d DB_Rmart -f backups/DB_Rmart_backup_20250810_150330.sql
    echo "✅ Database restored successfully!"
else
    echo "⚠️  Backup file not found, creating empty database..."
fi

# Test connection
echo "Testing database connection..."
psql -d DB_Rmart -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Database DB_Rmart is ready!"
    echo "📊 Database Info:"
    echo "   Host: localhost"
    echo "   Port: 5432"
    echo "   Database: DB_Rmart"
    echo "   Username: $(whoami)"
    echo ""
    echo "🔗 Connection String: postgresql://$(whoami)@localhost:5432/DB_Rmart"
else
    echo "❌ Database connection failed!"
    exit 1
fi