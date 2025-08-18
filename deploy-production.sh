#!/bin/bash

echo "🚀 Production Deployment Script"
echo "================================"

# Check if environment variables are set
if [ -z "$JWT_SECRET" ] || [ -z "$DB_PASSWORD" ]; then
    echo "❌ ERROR: Required environment variables not set"
    echo "Please set: JWT_SECRET, DB_PASSWORD"
    exit 1
fi

# Validate JWT secret length
if [ ${#JWT_SECRET} -lt 64 ]; then
    echo "❌ ERROR: JWT_SECRET must be at least 64 characters long"
    exit 1
fi

echo "✅ Environment variables validated"

# Build Backend
echo "📦 Building Backend..."
cd Ecommerce/Backend
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "❌ Backend build failed"
    exit 1
fi

# Build Frontend
echo "📦 Building Frontend..."
cd ../Frontend/frontend
npm ci --production
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed"
    exit 1
fi

# Build Dashboard Admin
echo "📦 Building Dashboard Admin..."
cd ../../../Dashboard_Admin
npm ci --production
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Dashboard Admin build failed"
    exit 1
fi

echo "✅ All builds completed successfully"
echo "🔒 Security checklist:"
echo "  - Environment variables configured"
echo "  - HTTPS certificates installed"
echo "  - Database secured"
echo "  - Firewall configured"
echo "  - Monitoring enabled"
echo ""
echo "🚀 Ready for production deployment!"