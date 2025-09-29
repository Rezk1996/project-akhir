# 🔗 Database Connection Guide - R-Mart

## 🚀 Quick Start

### 1. Setup & Start Semua Service
```bash
./start-rmart.sh
```

### 2. Test Koneksi Database
```bash
./test-database.sh
```

### 3. Stop Semua Service
```bash
./stop-rmart.sh
```

## 📊 Manual Database Setup

### 1. Install PostgreSQL (jika belum ada)
```bash
brew install postgresql
brew services start postgresql
```

### 2. Setup Database
```bash
./setup-database.sh
```

### 3. Initialize Schema
```bash
psql -d DB_Rmart -f init-database.sql
```

## 🔧 Konfigurasi Database

**Database:** DB_Rmart  
**Host:** localhost  
**Port:** 5432  
**Username:** postgres  
**Password:** postgres  

## 🌐 Service URLs

- **E-commerce Frontend:** http://localhost:3000
- **Admin Dashboard:** http://localhost:3001  
- **Backend API:** http://localhost:8191

## 👤 Login Credentials

**Admin:**
- Email: admin@rmart.com
- Password: admin123

**User:**
- Email: user@rmart.com  
- Password: user123

## 🔍 Troubleshooting

### Database tidak tersambung
```bash
# Check PostgreSQL status
brew services list | grep postgresql

# Restart PostgreSQL
brew services restart postgresql

# Test connection
psql -d DB_Rmart -c "SELECT version();"
```

### Backend error
```bash
# Check backend logs
tail -f backend.log

# Restart backend
cd Ecommerce/Backend
mvn spring-boot:run
```

### Frontend tidak bisa akses API
```bash
# Check .env files
cat Ecommerce/Frontend/frontend/.env
cat Dashboard_Admin/.env

# Should contain:
# REACT_APP_API_BASE_URL=http://localhost:8191/api
```

## 📝 Database Schema

### Tables:
- `users` - User accounts & profiles
- `categories` - Product categories  
- `products` - Product catalog
- `cart_items` - Shopping cart items
- `orders` - Customer orders
- `order_items` - Order line items

### Sample Data:
- 6 categories (Makanan, Minuman, Elektronik, Fashion, Kesehatan, Rumah Tangga)
- 6 sample products
- 1 admin user
- 1 regular user

## ✅ Verification Steps

1. ✅ Database created and running
2. ✅ Tables created with proper schema
3. ✅ Sample data inserted
4. ✅ Backend connects to database
5. ✅ Frontend connects to backend
6. ✅ Admin dashboard connects to backend
7. ✅ Authentication working
8. ✅ CRUD operations working

## 🆘 Support

Jika masih ada masalah:
1. Jalankan `./test-database.sh` untuk diagnosis
2. Check log files: `backend.log`, `frontend.log`, `dashboard.log`
3. Pastikan semua port (3000, 3001, 8191, 5432) tidak digunakan aplikasi lain