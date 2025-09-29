#!/bin/bash

echo "Stopping backend if running..."
pkill -f "spring-boot:run"

echo "Waiting for process to stop..."
sleep 3

echo "Starting backend..."
cd /Users/user/Documents/ProjectWeb/Ecommerce/Backend
mvn spring-boot:run &

echo "Backend restart initiated. Please wait for startup to complete."