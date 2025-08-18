#!/bin/bash

echo "Starting Dashboard Admin..."

cd Dashboard_Admin

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Start the dashboard admin
echo "Starting Dashboard Admin on http://localhost:3001"
npm start