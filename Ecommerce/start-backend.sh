#!/bin/bash

echo "Starting Rmart Ecommerce Backend..."
echo "=================================="

# Navigate to backend directory
cd Backend

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Maven is not installed. Please install Maven first."
    exit 1
fi

echo "⚠️  Please make sure your database is configured in application.properties"

echo "Building and starting Spring Boot application..."
echo "Backend will be available at: http://localhost:8191"
echo "API endpoints will be available at: http://localhost:8191/api"
echo ""

# Run the Spring Boot application
mvn spring-boot:run