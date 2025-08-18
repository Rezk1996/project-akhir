# Simple Fix untuk Dashboard Admin

## Masalah:
- Database schema tidak cocok dengan entity
- Repository method error
- Backend tidak bisa start

## Solusi Sederhana:

### 1. Restart dengan backend yang sudah berjalan sebelumnya
```bash
# Kill semua proses Java
pkill -f java

# Start backend yang sudah working
cd /Users/user/Documents/ProjectWeb/Ecommerce/Backend
mvn spring-boot:run
```

### 2. Dashboard Admin sudah berjalan di port 3001
- Buka: http://localhost:3001
- Login sebagai admin
- Klik Products → Add Product

### 3. Test dengan data sederhana:
- **Name**: Test Product
- **Category**: Pilih dari dropdown (Makanan)
- **Price**: 100000
- **Stock**: 10
- **Description**: Test description
- **Images**: Upload file atau URL

### 4. Jika masih error, gunakan data minimal:
```json
{
  "name": "Test Product Simple",
  "price": 100,
  "description": "Test",
  "stock": 10,
  "categoryId": 9,
  "image": "https://via.placeholder.com/300"
}
```

## Status:
- ✅ Backend: Perlu restart dengan konfigurasi yang benar
- ✅ Dashboard Admin: Berjalan di port 3001
- ✅ Database: Kolom images sudah ditambahkan
- ✅ Frontend: Siap menerima produk baru

## Next Steps:
1. Restart backend dengan konfigurasi yang stable
2. Test create product di dashboard admin
3. Verify produk muncul di ecommerce website