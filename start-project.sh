#!/bin/bash

echo "🚀 Starting R-Mart E-commerce Project..."

# 1. Start PostgreSQL Container
echo "📦 Starting PostgreSQL container..."
docker start rmart_postgres || docker run --name rmart_postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=rmart_db -e POSTGRES_USER=postgres -p 5432:5432 -d postgres:14

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# 2. Check if DB_Rmart exists with correct data
echo "🔍 Checking database DB_Rmart..."
DB_EXISTS=$(docker exec rmart_postgres psql -U postgres -lqt | cut -d \| -f 1 | grep -w DB_Rmart | wc -l)

if [ $DB_EXISTS -eq 0 ]; then
    echo "❌ DB_Rmart not found. Creating and restoring from backup..."
    docker exec rmart_postgres psql -U postgres -c "CREATE DATABASE \"DB_Rmart\";"
    docker exec -i rmart_postgres psql -U postgres -d DB_Rmart < DB_Rmart_backup.sql
    
    # Add missing columns and migrate data
    echo "🔧 Setting up database structure..."
    docker exec rmart_postgres psql -U postgres -d DB_Rmart -c "
        ALTER TABLE products ADD COLUMN IF NOT EXISTS discount INTEGER DEFAULT 0;
        ALTER TABLE products ADD COLUMN IF NOT EXISTS original_price NUMERIC(38,2) DEFAULT 0;
        ALTER TABLE products ADD COLUMN IF NOT EXISTS rating DECIMAL(2,1) DEFAULT 0;
        ALTER TABLE products ADD COLUMN IF NOT EXISTS sold INTEGER DEFAULT 0;
        ALTER TABLE products ADD COLUMN IF NOT EXISTS image VARCHAR(255);
        
        DELETE FROM products;
        INSERT INTO products (id, name, price, original_price, stock, description, image, active, discount, rating, sold) 
        SELECT id, nama_barang, harga_jual, harga_jual, stok, 'Produk berkualitas', gambar, true, 0, 4.5, 0 FROM barang;
    "
else
    # Check if products table has data
    PRODUCT_COUNT=$(docker exec rmart_postgres psql -U postgres -d DB_Rmart -tAc "SELECT COUNT(*) FROM products;")
    if [ $PRODUCT_COUNT -eq 0 ]; then
        echo "🔧 Products table empty. Migrating data from barang..."
        docker exec rmart_postgres psql -U postgres -d DB_Rmart -c "
            ALTER TABLE products ADD COLUMN IF NOT EXISTS discount INTEGER DEFAULT 0;
            ALTER TABLE products ADD COLUMN IF NOT EXISTS original_price NUMERIC(38,2) DEFAULT 0;
            ALTER TABLE products ADD COLUMN IF NOT EXISTS rating DECIMAL(2,1) DEFAULT 0;
            ALTER TABLE products ADD COLUMN IF NOT EXISTS sold INTEGER DEFAULT 0;
            ALTER TABLE products ADD COLUMN IF NOT EXISTS image VARCHAR(255);
            
            INSERT INTO products (id, name, price, original_price, stock, description, image, active, discount, rating, sold) 
            SELECT id, nama_barang, harga_jual, harga_jual, stok, 'Produk berkualitas', gambar, true, 0, 4.5, 0 FROM barang
            ON CONFLICT (id) DO NOTHING;
        "
    fi
fi

echo "✅ Database DB_Rmart ready with $(docker exec rmart_postgres psql -U postgres -d DB_Rmart -tAc "SELECT COUNT(*) FROM products;") products"

# 3. Start Backend
echo "🔧 Starting Backend (Spring Boot)..."
cd Ecommerce/Backend
mvn spring-boot:run > backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"
cd ../..

# 4. Wait for backend to start
echo "⏳ Waiting for backend to start..."
sleep 15

# Test backend connection
if curl -s http://localhost:8191/api/products > /dev/null; then
    echo "✅ Backend started successfully at http://localhost:8191"
else
    echo "❌ Backend failed to start"
fi

# 5. Start Frontend E-commerce
echo "🌐 Starting E-commerce Frontend..."
cd Ecommerce/Frontend/frontend
npm start > frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"
cd ../../..

# 6. Start Admin Dashboard
echo "📊 Starting Admin Dashboard..."
cd Dashboard_Admin
npm start > dashboard.log 2>&1 &
DASHBOARD_PID=$!
echo "Dashboard PID: $DASHBOARD_PID"
cd ..

echo ""
echo "🎉 R-Mart Project Started Successfully!"
echo ""
echo "📋 Services:"
echo "   🗄️  Database: http://localhost:5432 (DB_Rmart)"
echo "   🔧 Backend API: http://localhost:8191"
echo "   🛒 E-commerce: http://localhost:3000"
echo "   📊 Admin Dashboard: http://localhost:3001"
echo ""
echo "📝 Process IDs:"
echo "   Backend: $BACKEND_PID"
echo "   Frontend: $FRONTEND_PID"
echo "   Dashboard: $DASHBOARD_PID"
echo ""
echo "🛑 To stop all services, run: ./stop-project.sh"