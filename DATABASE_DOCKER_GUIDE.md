# 🐳 R-Mart Database Docker Guide

Database DB_Rmart berhasil dijalankan menggunakan Docker dengan semua data yang sudah di-restore dari backup.

## 🚀 Quick Start

### Menjalankan Database
```bash
bash run-database-docker.sh
```

### Memeriksa Status Database
```bash
bash check-database-status.sh
```

### Menghentikan Database
```bash
docker stop rmart_postgres
```

## 📊 Database Information

- **Container Name**: `rmart_postgres`
- **Database Name**: `DB_Rmart`
- **Host**: `localhost`
- **Port**: `5432`
- **Username**: `postgres`
- **Password**: `postgres`
- **Connection String**: `postgresql://postgres:postgres@localhost:5432/DB_Rmart`

## 📋 Available Tables (27 tables)

### Core E-commerce Tables
- `users` - User accounts (customers & admin)
- `barang` - Products/Items
- `jenis_barang` - Product categories
- `carts` - Shopping carts
- `cart_items` - Cart items
- `orders` - Customer orders
- `order_items` - Order details
- `addresses` - User addresses

### Legacy/Admin Tables
- `admin` - Admin users
- `customer` - Customer data
- `transaksi` - Transactions
- `detail_transaksi` - Transaction details
- `keranjang` - Shopping cart (legacy)

### Inventory & Business Tables
- `stok_masuk` - Stock in
- `stok_keluar` - Stock out
- `supplier` - Suppliers
- `harga_beli` - Purchase prices
- `diskon` - Discounts
- `target_penjualan` - Sales targets

### Employee Management
- `tenaga_kerja` - Employees
- `shift_kerja` - Work shifts

### Additional Features
- `reviews` - Product reviews
- `wishlists` - User wishlists
- `coupons` - Discount coupons
- `product_images` - Product images
- `point_member` - Member points
- `categories_backup` - Category backup

## 🔧 Database Management Commands

### Connect to Database
```bash
docker exec -it rmart_postgres psql -U postgres -d DB_Rmart
```

### Backup Database
```bash
docker exec rmart_postgres pg_dump -U postgres DB_Rmart > backup_$(date +%Y%m%d_%H%M%S).sql
```

### View Container Logs
```bash
docker logs rmart_postgres
```

### Restart Container
```bash
docker restart rmart_postgres
```

## 🔗 Integration dengan Backend

Update konfigurasi database di `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/DB_Rmart
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.datasource.driver-class-name=org.postgresql.Driver
```

## ✅ Status

- ✅ Database container running
- ✅ All 27 tables restored
- ✅ Data imported from backup
- ✅ Connection healthy
- ✅ Ready for backend integration

## 🛠️ Troubleshooting

### Container won't start
```bash
docker logs rmart_postgres
```

### Connection refused
```bash
docker exec rmart_postgres pg_isready -U postgres -d DB_Rmart
```

### Reset database
```bash
docker stop rmart_postgres
docker rm rmart_postgres
docker volume rm postgres_data
bash run-database-docker.sh
```

Database DB_Rmart siap digunakan! 🎉