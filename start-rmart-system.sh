#!/bin/bash

echo "🚀 Starting Rmart System..."

# 1. Ensure database exists
echo "1️⃣ Ensuring database exists..."
./ensure-db-exists.sh

# 2. Start backend
echo "2️⃣ Starting backend..."
cd Ecommerce/Backend
lsof -ti:8191 | xargs kill -9 2>/dev/null || true
mvn spring-boot:run > backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend started with PID: $BACKEND_PID"

# 3. Start dashboard admin
echo "3️⃣ Starting dashboard admin..."
cd ../../Dashboard_Admin
lsof -ti:3001 | xargs kill -9 2>/dev/null || true
npm start > dashboard.log 2>&1 &
DASHBOARD_PID=$!
echo "Dashboard started with PID: $DASHBOARD_PID"

# 4. Wait for services to start
echo "4️⃣ Waiting for services to start..."
sleep 15

# 5. Test connections
echo "5️⃣ Testing connections..."
echo "Backend: $(curl -s http://localhost:8191/api/admin/products | jq -r '.status // "❌ Failed"')"
echo "Dashboard: $(curl -s http://localhost:3001 >/dev/null 2>&1 && echo "✅ Running" || echo "❌ Failed")"

echo ""
echo "🎉 Rmart System Started!"
echo "📊 Dashboard Admin: http://localhost:3001"
echo "🔧 Backend API: http://localhost:8191"
echo "🔑 Login: admin@rmart.com / admin123"
echo ""
echo "💾 Database: DB_Rmart (Persistent)"
echo "📝 Logs: backend.log, dashboard.log"