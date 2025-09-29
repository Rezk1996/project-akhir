# 🗄️ Database DB_Rmart - Status & Dokumentasi

## ✅ Status Database
- **Database Name**: DB_Rmart
- **Status**: ✅ RUNNING
- **PostgreSQL Version**: 14.18 (Homebrew)
- **Host**: localhost
- **Port**: 5432
- **Username**: user
- **Password**: (empty)

## 📊 Statistik Database
- **Total Products**: 31
- **Total Categories**: 10  
- **Total Users**: 16
- **Total Orders**: 1
- **Total Cart Items**: 0

## 🔗 Koneksi Database
```
URL: jdbc:postgresql://localhost:5432/DB_Rmart
Username: user
Password: (kosong)
Driver: org.postgresql.Driver
```

## 📋 Tabel Utama

### 🛍️ E-commerce Tables
- `barang` - Produk/barang
- `jenis_barang` - Kategori produk
- `users` - User accounts
- `carts` - Shopping carts
- `cart_items` - Items dalam cart
- `orders` - Order transaksi
- `order_items` - Detail order items

### 👥 User Management
- `users` - Data user (customer & admin)
- `addresses` - Alamat pengiriman
- `wishlists` - Wishlist produk

### 💰 Transaction & Payment
- `orders` - Order transaksi
- `order_items` - Detail item order
- `coupons` - Kupon diskon
- `reviews` - Review produk

### 🏢 Legacy Tables (Retail System)
- `customer` - Data customer lama
- `transaksi` - Transaksi lama
- `detail_transaksi` - Detail transaksi lama
- `keranjang` - Keranjang lama

## 🚀 Cara Menjalankan Database

### 1. Start Database
```bash
./start-database.sh
```

### 2. Check Status
```bash
./check-database-status.sh
```

### 3. Manual Commands
```bash
# Start PostgreSQL
brew services start postgresql@14

# Connect to database
psql -d DB_Rmart

# Check tables
psql -d DB_Rmart -c "\dt"
```

## 🔧 Konfigurasi Spring Boot
File: `Ecommerce/Backend/src/main/resources/application.properties`
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/DB_Rmart
spring.datasource.username=user
spring.datasource.password=
spring.datasource.driver-class-name=org.postgresql.Driver
```

## 📝 Sample Data
Database sudah berisi:
- ✅ Sample products (31 items)
- ✅ Categories (10 categories)  
- ✅ Test users (16 users)
- ✅ Admin user (admin@rmart.com)

## 🛠️ Maintenance Commands

### Backup Database
```bash
pg_dump DB_Rmart > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database
```bash
psql -d DB_Rmart -f backup_file.sql
```

### Reset Database
```bash
dropdb DB_Rmart
createdb DB_Rmart
psql -d DB_Rmart -f backups/DB_Rmart_backup_20250810_150330.sql
```

## 🔍 Troubleshooting

### Database tidak bisa connect
```bash
# Restart PostgreSQL
brew services restart postgresql@14

# Check if database exists
psql -l | grep DB_Rmart
```

### Port sudah digunakan
```bash
# Check what's using port 5432
lsof -i :5432

# Kill process if needed
sudo kill -9 <PID>
```

## 📈 Performance Monitoring
```sql
-- Check active connections
SELECT * FROM pg_stat_activity WHERE datname = 'DB_Rmart';

-- Check table sizes
SELECT schemaname,tablename,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size 
FROM pg_tables WHERE schemaname = 'public' ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---
**Last Updated**: $(date)
**Database Status**: ✅ OPERATIONAL