#!/bin/bash

echo "Updating database schema for multiple images support..."

# Run the SQL script
mysql -u root -p ecommerce_db < add_images_column.sql

echo "Database updated successfully!"
echo "You can now use multiple images in products."