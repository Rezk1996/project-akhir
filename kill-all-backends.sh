#!/bin/bash

echo "🔪 Killing all backend processes..."

# Kill all Spring Boot processes
pkill -f "spring-boot:run"
pkill -f "SpringbootApplication"
pkill -f "maven"
pkill -f "mvn"

# Kill processes on port 8191
lsof -ti:8191 | xargs kill -9 2>/dev/null

# Wait a moment
sleep 3

# Check if any processes are still running
echo "Checking remaining processes..."
ps aux | grep -E "(spring-boot|maven|mvn)" | grep -v grep

echo "✅ All backend processes killed"