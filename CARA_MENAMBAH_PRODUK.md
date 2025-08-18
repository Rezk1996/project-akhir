# 📝 Cara Menambahkan Produk di Rmart

## 🚀 Langkah-langkah:

### 1. Jalankan Semua Aplikasi
```bash
./start-all-apps.sh
```

### 2. Login ke Admin Dashboard
- Buka: http://localhost:3001
- Email: `admin@rmart.com`
- Password: `admin123`

### 3. Menambah Produk Baru
1. Klik menu **"Products Management"**
2. Klik tombol **"Add Product"** (merah)
3. Isi form produk:
   - **Product Name**: Nama produk (contoh: "Indomie Goreng")
   - **Category**: Pilih kategori yang sesuai
   - **Price**: Harga jual (contoh: 3500)
   - **Original Price**: Harga asli sebelum diskon (opsional)
   - **Discount (%)**: Persentase diskon (opsional)
   - **Stock**: Jumlah stok tersedia
   - **Image URL**: Link gambar produk
   - **Description**: Deskripsi produk
4. Klik **"Create"**

### 4. Verifikasi Produk Muncul
- Buka Frontend Ecommerce: http://localhost:3000
- Produk baru akan muncul di:
  - Homepage (jika memenuhi kriteria featured/terbaru)
  - Halaman Products (/products)
  - Kategori yang sesuai

## 📋 Kategori Tersedia:
1. **Makanan & Minuman** - snack, minuman, makanan instan
2. **Kebutuhan Rumah Tangga** - sabun, deterjen, pembersih
3. **Kesehatan & Kecantikan** - obat-obatan, kosmetik
4. **Bayi & Anak** - susu, popok, mainan
5. **Rokok & Tembakau** - rokok, korek api
6. **Alat Tulis & Kantor** - pulpen, buku, kertas
7. **Elektronik & Aksesoris** - baterai, charger, earphone

## 💡 Tips:
- Gunakan gambar dengan URL yang valid dan dapat diakses
- Pastikan harga dalam format angka (tanpa titik/koma)
- Stock minimal 1 agar produk muncul di frontend
- Deskripsi yang menarik akan meningkatkan penjualan

## 🔧 Troubleshooting:
- Jika produk tidak muncul, refresh halaman frontend
- Pastikan semua field wajib sudah diisi
- Cek console browser untuk error jika ada masalah