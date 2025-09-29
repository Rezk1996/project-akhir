#!/bin/bash

echo "🔧 Fixing All R-Mart Issues..."

# 1. Stop all processes
echo "1. Stopping all processes..."
pkill -f spring-boot
pkill -f "npm start"

# 2. Create test users
echo "2. Creating test users..."
psql -d rmart_db -f create-test-user.sql

# 3. Clean and restart backend
echo "3. Restarting backend..."
cd Ecommerce/Backend
mvn clean compile &
sleep 10
mvn spring-boot:run &
BACKEND_PID=$!

# 4. Wait for backend to start
echo "4. Waiting for backend to start..."
sleep 15

# 5. Test backend login
echo "5. Testing backend login..."
curl -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "customer@test.com", "password": "customer123"}' \
  | jq .

# 6. Restart frontend
echo "6. Restarting frontend..."
cd ../Frontend/frontend
npm start &
FRONTEND_PID=$!

echo "✅ All fixes applied!"
echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"
echo ""
echo "Test credentials:"
echo "Customer: customer@test.com / customer123"
echo "Admin: admin@test.com / admin123"
echo ""
echo "Open: http://localhost:3000"