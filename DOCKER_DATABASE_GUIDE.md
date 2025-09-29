# 🐳 Docker Database Setup Guide - DB_Rmart

## Cara Menjalankan Database DB_Rmart di Docker

### 1. Pastikan Docker Desktop Berjalan

Sebelum menjalankan database, pastikan Docker Desktop sudah terinstall dan berjalan:

```bash
# Cek status Docker
docker --version
docker ps
```

### 2. Jalankan Database dengan Docker

```bash
# Jalankan database DB_Rmart
bash start-db-rmart.sh
```

### 3. Cek Status Database

```bash
# Cek apakah database berjalan
bash check-db-rmart.sh
```

### 4. Stop Database

```bash
# Stop database
bash stop-db-rmart.sh
```

## Alternatif: Setup Database Lokal

Jika Docker tidak tersedia, gunakan PostgreSQL lokal:

```bash
# Setup database lokal
bash setup-db-rmart-local.sh
```

## Informasi Database

- **Database Name**: DB_Rmart
- **Host**: localhost
- **Port**: 5432
- **Username**: postgres
- **Password**: postgres
- **Connection String**: `jdbc:postgresql://localhost:5432/DB_Rmart`

## Troubleshooting

### Docker Daemon Not Running
```bash
# Start Docker Desktop manually atau:
open -a Docker
```

### Port 5432 Already in Use
```bash
# Stop local PostgreSQL
brew services stop postgresql

# Atau gunakan port berbeda di docker-compose-db.yml
ports:
  - "5433:5432"
```

### Database Connection Issues
```bash
# Test koneksi manual
docker exec db_rmart_postgres psql -U postgres -d DB_Rmart -c "SELECT 1;"
```

## File yang Dibuat

- `docker-compose-db.yml` - Konfigurasi Docker Compose
- `start-db-rmart.sh` - Script untuk start database
- `stop-db-rmart.sh` - Script untuk stop database  
- `check-db-rmart.sh` - Script untuk cek status
- `setup-db-rmart-local.sh` - Setup database lokal