#!/bin/bash

echo "🛒 Starting R-Mart System..."

# Kill existing processes
echo "🔄 Stopping existing processes..."
pkill -f java
pkill -f node
sleep 3

# Start database
echo "🐳 Starting database..."
cd Ecommerce && docker-compose up -d
sleep 5

# Start backend
echo "🚀 Starting backend..."
cd Backend
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/DB_Rmart
export SPRING_DATASOURCE_USERNAME=postgres
export SPRING_DATASOURCE_PASSWORD=postgres
java -jar target/restapi.jar > backend.log 2>&1 &
sleep 10

# Test backend
echo "🧪 Testing backend..."
curl -s http://localhost:8191/api/products | head -c 100

# Start dashboard
echo "📊 Starting dashboard admin..."
cd ../../../Dashboard_Admin
npm start > dashboard.log 2>&1 &
sleep 5

echo "✅ R-Mart System Started!"
echo "🌐 Dashboard Admin: http://localhost:3001"
echo "🔐 Login: admin@rmart.com / admin123"