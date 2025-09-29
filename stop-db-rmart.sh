#!/bin/bash

echo "🛑 Stopping DB_Rmart PostgreSQL Database..."

# Stop the container
docker-compose -f docker-compose-db.yml down

echo "✅ DB_Rmart database stopped successfully!"
echo ""
echo "To start again, run: ./start-db-rmart.sh"