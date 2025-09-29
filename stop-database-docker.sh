#!/bin/bash

echo "🛑 Stopping R-Mart Database Docker containers..."

# Stop and remove containers
docker-compose -f docker-compose-database.yml down

echo "✅ Database containers stopped successfully!"
echo ""
echo "💡 Database data is preserved in Docker volumes."
echo "   To completely remove data, run:"
echo "   docker volume rm projectweb_rmart_postgres_data"