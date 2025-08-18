# Manual Testing: Delete Product Functionality

## Status: ✅ WORKING

Backend delete endpoint sudah berfungsi dengan baik. Berikut adalah instruksi untuk testing manual:

## Prerequisites
1. Backend berjalan di port 8191
2. Database PostgreSQL berjalan dengan data sample
3. Dashboard Admin berjalan di port 3001

## Backend Testing (SUDAH BERHASIL)

### 1. Test Get Products
```bash
curl -X GET http://localhost:8191/api/products
```
**Expected:** List produk dengan totalElements = 4

### 2. Test Delete Product
```bash
curl -X DELETE http://localhost:8191/api/admin/products/2
```
**Expected:** `{"message":"Product deleted successfully","status":true,"data":null}`

### 3. Verify Deletion
```bash
curl -X GET http://localhost:8191/api/products
```
**Expected:** totalElements berkurang 1

## Frontend Testing (Dashboard Admin)

### 1. Akses Dashboard Admin
- Buka browser: http://localhost:3001
- Login sebagai admin (jika diperlukan)

### 2. Navigate ke Products Page
- Klik menu "Products" di sidebar
- Akan muncul tabel produk

### 3. Test Delete Function
- Klik tombol delete (ikon trash) pada salah satu produk
- Konfirmasi dialog "Are you sure you want to delete this product?"
- Klik "OK"

### 4. Expected Results
- Alert: "Product deleted successfully! It has been removed from the ecommerce website."
- Produk hilang dari tabel
- Total produk berkurang

## Troubleshooting

### Jika Backend Error:
```bash
# Restart backend
cd /Users/user/Documents/ProjectWeb/Ecommerce/Backend
pkill -f "spring-boot:run"
mvn spring-boot:run > backend.log 2>&1 &
```

### Jika Database Error:
```bash
# Check database connection
psql -U postgres -d DB_Rmart -c "SELECT COUNT(*) FROM products;"
```

### Jika Frontend Error:
```bash
# Restart Dashboard Admin
cd /Users/user/Documents/ProjectWeb/Dashboard_Admin
npm start
```

## API Endpoints Summary

| Method | Endpoint | Description | Status |
|--------|----------|-------------|---------|
| GET | `/api/products` | Get all products | ✅ Working |
| DELETE | `/api/admin/products/{id}` | Delete product | ✅ Working |
| GET | `/api/products/categories` | Get categories | ✅ Working |

## Database Schema
- Table: `products`
- Primary Key: `id` (BIGINT)
- Foreign Key: `category_id` references `categories(id)`
- Constraints: ON DELETE CASCADE untuk related tables

## Notes
- Delete function menggunakan `@Transactional` untuk data consistency
- Foreign key constraints sudah diatur dengan proper CASCADE
- Frontend sudah terintegrasi dengan backend API
- Error handling sudah implemented di backend dan frontend

## Test Results
- ✅ Backend delete endpoint working
- ✅ Database constraints working properly
- ✅ Product successfully deleted (ID 1 - Indomie Goreng)
- ✅ Total products updated correctly (5 → 4)
- 🔄 Frontend testing ready (Dashboard Admin started)