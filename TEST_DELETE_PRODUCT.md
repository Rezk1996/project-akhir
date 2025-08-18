# 🧪 Test Delete Product Functionality

## 📋 Langkah Testing:

### 1. Persiapan
```bash
# Jalankan semua aplikasi
./start-all-apps.sh
```

### 2. Tambah Produk Test
1. Login ke Admin Dashboard: http://localhost:3001
   - Email: `admin@rmart.com`
   - Password: `admin123`
2. Klik "Products Management"
3. Klik "Add Product"
4. Isi data test:
   - **Name**: "Test Product - Will be Deleted"
   - **Category**: Pilih salah satu
   - **Price**: 10000
   - **Stock**: 5
   - **Image URL**: https://via.placeholder.com/300/FF0000?text=TEST
   - **Description**: "This is a test product for deletion"
5. Klik "Create"

### 3. Verifikasi Produk Muncul di Ecommerce
1. Buka Frontend: http://localhost:3000
2. Cek produk muncul di homepage atau halaman products
3. Klik produk untuk melihat detail page
4. Catat URL detail page (contoh: /products/1)

### 4. Test Delete dari Admin
1. Kembali ke Admin Dashboard
2. Di Products Management, klik tombol Delete (ikon sampah merah) pada produk test
3. Konfirmasi delete dengan klik "OK"
4. Verifikasi produk hilang dari tabel admin

### 5. Verifikasi Delete di Ecommerce
1. Refresh homepage ecommerce - produk test harus hilang
2. Refresh halaman products - produk test harus hilang  
3. Akses URL detail page yang dicatat tadi
4. Harus muncul error: "Product not found or has been removed"
5. Klik "Back to Products" harus redirect ke halaman products

## ✅ Expected Results:
- ✅ Produk terhapus dari admin dashboard
- ✅ Produk hilang dari homepage ecommerce
- ✅ Produk hilang dari halaman products
- ✅ Detail page menampilkan error yang user-friendly
- ✅ Redirect berfungsi dengan baik

## 🐛 Troubleshooting:
- Jika produk masih muncul, coba hard refresh (Ctrl+F5)
- Jika error 500, cek console backend untuk foreign key issues
- Jika detail page tidak menampilkan error, cek network tab untuk API response

## 🔄 Test Multiple Products:
1. Tambah 3-5 produk test
2. Delete satu per satu
3. Verifikasi setiap delete tidak mempengaruhi produk lain
4. Pastikan counter di dashboard stats berkurang sesuai