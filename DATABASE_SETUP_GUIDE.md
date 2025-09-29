# 🗄️ Database Setup Guide - R-Mart E-commerce

## 📋 Overview

Database DB_Rmart telah berhasil dijalankan menggunakan PostgreSQL dengan data lengkap yang sudah ter-restore dari backup.

## ✅ Database Status

- **Database Name**: `DB_Rmart`
- **Host**: `localhost`
- **Port**: `5432`
- **User**: `user`
- **Password**: (empty)
- **Status**: ✅ **RUNNING**

## 🚀 Quick Start

### 1. Jalankan Database Saja
```bash
bash start-database.sh
```

### 2. Jalankan Seluruh Sistem
```bash
bash run-rmart-system.sh
```

### 3. Hentikan Sistem
```bash
bash stop-rmart-system.sh
```

## 🔧 Manual Database Operations

### Koneksi ke Database
```bash
psql -d DB_Rmart
```

### Cek Status Database
```bash
psql -d DB_Rmart -c "SELECT 'Database is running!' as status;"
```

### Lihat Tabel yang Tersedia
```sql
\dt
```

### Cek Data Produk
```sql
SELECT * FROM barang LIMIT 5;
```

### Cek Data User
```sql
SELECT id, name, email, role FROM users LIMIT 5;
```

## 📊 Database Schema

### Tabel Utama:
- `users` - Data pengguna (customer & admin)
- `barang` - Data produk
- `jenis_barang` - Kategori produk
- `orders` - Data pesanan
- `order_items` - Detail item pesanan
- `carts` - Keranjang belanja
- `cart_items` - Item dalam keranjang

### Views:
- `products` - View produk untuk API
- `categories` - View kategori untuk API

## 🔄 Backup & Restore

### Backup Database
```bash
pg_dump -U user DB_Rmart > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore dari Backup
```bash
psql -U user -d DB_Rmart -f backup_file.sql
```

## 🐳 Alternative: Docker Setup

Jika PostgreSQL lokal bermasalah, gunakan Docker:

```bash
bash start-database-docker.sh
```

## 🛠️ Troubleshooting

### Problem: PostgreSQL tidak bisa start
**Solution:**
```bash
# Restart PostgreSQL service
brew services restart postgresql@14

# Atau gunakan Docker
bash start-database-docker.sh
```

### Problem: Database tidak ditemukan
**Solution:**
```bash
# Buat database baru
createdb DB_Rmart

# Restore dari backup
psql -d DB_Rmart -f backups/DB_Rmart_backup_20250810_150330.sql
```

### Problem: Permission denied
**Solution:**
```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/var/postgresql@14
```

## 📈 Database Performance

### Cek Ukuran Database
```sql
SELECT pg_size_pretty(pg_database_size('DB_Rmart')) as database_size;
```

### Cek Koneksi Aktif
```sql
SELECT count(*) as active_connections FROM pg_stat_activity WHERE datname = 'DB_Rmart';
```

## 🔐 Security Notes

- Database menggunakan trust authentication untuk development
- Untuk production, gunakan password authentication
- Backup database secara berkala
- Monitor log untuk aktivitas mencurigakan

## 📝 Configuration Files

- **Backend Config**: `Ecommerce/Backend/src/main/resources/application.properties`
- **Database URL**: `jdbc:postgresql://localhost:5432/DB_Rmart`

## 🎯 Next Steps

1. ✅ Database sudah running
2. ▶️ Jalankan backend: `cd Ecommerce/Backend && mvn spring-boot:run`
3. ▶️ Jalankan frontend: `cd Ecommerce/Frontend/frontend && npm start`
4. ▶️ Jalankan dashboard: `cd Dashboard_Admin && npm start`

## 📞 Support

Jika ada masalah dengan database:
1. Cek log: `tail -f /usr/local/var/log/postgresql@14.log`
2. Restart service: `brew services restart postgresql@14`
3. Gunakan Docker alternative: `bash start-database-docker.sh`

---

**Database DB_Rmart siap digunakan! 🎉**