# Troubleshooting Dashboard Admin

## ✅ Status Sistem
- **Backend**: ✅ Berjalan di http://localhost:8191
- **Dashboard Admin**: ✅ Berjalan di http://localhost:3001
- **API Endpoint**: ✅ Berfungsi normal

## 🔧 Cara Mengatasi Error "Error saving product"

### 1. **Pastikan Semua Field Terisi**
- ✅ **Product Name**: Wajib diisi
- ✅ **Category**: Pilih salah satu kategori
- ✅ **Price**: Masukkan angka (contoh: 100)
- ✅ **Stock**: Masukkan angka (contoh: 10)
- ✅ **Images**: Minimal 1 gambar (upload atau URL)

### 2. **Kategori yang Tersedia**
- Kebutuhan Dapur (ID: 6)
- Kebutuhan Ibu & Anak (ID: 7)
- Kebutuhan Rumah (ID: 8)
- Makanan (ID: 9)
- Minuman (ID: 10)
- Produk Segar & Beku (ID: 11)
- Personal Care (ID: 12)
- Kebutuhan Kesehatan (ID: 13)
- Lifestyle (ID: 14)
- Pet Foods (ID: 15)

### 3. **Format Gambar yang Didukung**
- **Upload File**: JPG, PNG, GIF, WebP
- **Image URL**: URL yang valid (contoh: https://via.placeholder.com/300)

### 4. **Langkah Debugging**
1. Buka **Developer Tools** (F12)
2. Klik tab **Console**
3. Coba tambah produk
4. Lihat error message di console
5. Lihat **Network** tab untuk melihat request/response

### 5. **Test Manual API**
```bash
# Test create product
curl -X POST http://localhost:8191/api/admin/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "price": 100,
    "description": "Test description",
    "stock": 10,
    "categoryId": 6,
    "image": "https://via.placeholder.com/300",
    "images": ["https://via.placeholder.com/300"]
  }'
```

## 🎯 Contoh Data Produk yang Valid

### Produk Sederhana:
- **Name**: "Kopi Arabica Premium"
- **Category**: Makanan
- **Price**: 50000
- **Stock**: 100
- **Description**: "Kopi arabica berkualitas tinggi"
- **Image**: Upload file atau URL gambar

### Produk dengan Diskon:
- **Name**: "Smartphone Android"
- **Category**: Lifestyle
- **Price**: 2000000
- **Original Price**: 2500000
- **Discount**: 20
- **Stock**: 50
- **Images**: Multiple images

## 🚨 Error Messages dan Solusi

### "Please fill in all required fields"
- ✅ Isi semua field yang wajib (Name, Price, Category)

### "Please add at least one product image"
- ✅ Upload minimal 1 gambar atau masukkan URL gambar

### "constraint violation"
- ✅ Pilih kategori yang valid dari dropdown

### "API endpoint not found"
- ✅ Pastikan backend berjalan di port 8191
- ✅ Check dengan: `curl http://localhost:8191/api/products`

### "Server error"
- ✅ Check backend logs
- ✅ Restart backend jika perlu

## 📱 Cara Menggunakan Dashboard

1. **Akses**: http://localhost:3001
2. **Login**: Gunakan akun admin
3. **Products**: Klik menu "Products"
4. **Add Product**: Klik tombol "Add Product"
5. **Fill Form**: Isi semua field yang diperlukan
6. **Upload Images**: 
   - Tab "Upload Files": Pilih file dari komputer
   - Tab "Image URLs": Masukkan URL gambar
7. **Save**: Klik "Create"

## ✅ Verifikasi Produk Berhasil Ditambahkan

1. **Dashboard Admin**: Produk muncul di tabel Products
2. **Website Ecommerce**: Buka http://localhost:3000
3. **Check Homepage**: Produk muncul di "Produk Terbaru"
4. **Check Products Page**: Produk muncul di daftar produk

Jika masih ada masalah, periksa console browser untuk error message yang lebih detail!