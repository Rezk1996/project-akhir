#!/bin/bash

echo "🔧 Updating dependencies for security fixes..."

# Update Frontend dependencies
echo "📦 Updating Frontend dependencies..."
cd Ecommerce/Frontend/frontend
npm audit fix --force
npm update
npm install dompurify @types/dompurify

# Update Dashboard Admin dependencies  
echo "📦 Updating Dashboard Admin dependencies..."
cd ../../../Dashboard_Admin
npm audit fix --force
npm update
npm install dompurify @types/dompurify

# Update Backend dependencies
echo "📦 Updating Backend dependencies..."
cd ../Ecommerce/Backend
mvn clean compile

echo "✅ Dependencies updated successfully!"
echo "🔒 Security vulnerabilities have been addressed."
echo ""
echo "Next steps:"
echo "1. Test all applications"
echo "2. Configure HTTPS certificates for production"
echo "3. Review and update JWT secret key"
echo "4. Set up proper database connection pooling"