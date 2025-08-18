# Fitur Upload Gambar Produk - Dashboard Admin

## 📋 Overview
Fitur upload gambar produk telah ditambahkan ke Dashboard Admin dengan dua opsi:
1. **Upload File** - Upload gambar dari komputer/perangkat
2. **Image URL** - Input URL gambar dari internet

## 🚀 Cara Menjalankan

### 1. Update Database
```bash
cd /Users/user/Documents/ProjectWeb
./update-database.sh
```

### 2. Start Backend
```bash
./start-backend.sh
```

### 3. Start Dashboard Admin
```bash
./start-dashboard-admin.sh
```

### 4. Start Frontend Ecommerce (Optional)
```bash
./start-frontend.sh
```

## 🎯 Fitur yang Ditambahkan

### Dashboard Admin (`http://localhost:3001`)

#### 1. **Komponen ImageUpload**
- **File**: `Dashboard_Admin/src/components/ImageUpload.tsx`
- **Tab Upload Files**: 
  - Klik tombol untuk pilih file dari komputer
  - Support multiple file selection
  - Preview gambar real-time
  - Tombol delete individual
- **Tab Image URLs**:
  - Input field untuk URL gambar
  - Tombol "Add URL" untuk menambah field
  - Tombol "Add to Images" untuk konfirmasi
  - Preview dari URL yang valid

#### 2. **ProductsPage Integration**
- **File**: `Dashboard_Admin/src/pages/ProductsPage.tsx`
- Dialog "Add/Edit Product" terintegrasi dengan ImageUpload
- Validasi minimal 1 gambar wajib
- Support multiple images
- Gambar pertama menjadi gambar utama

#### 3. **Backend Support**
- **File**: `Backend/src/main/java/com/boniewijaya2021/springboot/entity/Product.java`
- Field `images` ditambahkan untuk menyimpan multiple images
- **File**: `Backend/src/main/java/com/boniewijaya2021/springboot/controller/AdminController.java`
- Endpoint create/update product mendukung multiple images

## 📱 Cara Menggunakan

### Menambah Produk Baru:
1. Buka Dashboard Admin: `http://localhost:3001`
2. Login sebagai admin
3. Klik menu "Products"
4. Klik tombol "Add Product"
5. Isi form produk:
   - Nama produk
   - Kategori
   - Harga & harga asli
   - Stok
   - Deskripsi
6. **Upload Gambar**:
   - **Tab "Upload Files"**: Klik untuk pilih file dari komputer
   - **Tab "Image URLs"**: Input URL gambar, klik "Add to Images"
7. Klik "Create"

### Edit Produk:
1. Di halaman Products, klik icon Edit (✏️)
2. Gambar existing akan muncul di preview
3. Bisa tambah/hapus gambar
4. Klik "Update"

## 🔧 Technical Details

### Database Schema:
```sql
ALTER TABLE products ADD COLUMN images TEXT;
```

### Data Format:
- **image**: String (gambar utama)
- **images**: String (comma-separated URLs untuk multiple images)

### API Endpoints:
- `POST /api/admin/products` - Create product with images
- `PUT /api/admin/products/{id}` - Update product with images
- `DELETE /api/admin/products/{id}` - Delete product

### Frontend Integration:
- Produk yang dibuat di Dashboard Admin otomatis muncul di website ecommerce
- Gambar utama (pertama) ditampilkan di product cards
- Multiple images bisa ditampilkan di product detail

## ✅ Fitur yang Berfungsi:
- ✅ Upload file dari komputer (multiple selection)
- ✅ Input URL gambar (multiple URLs)
- ✅ Preview gambar real-time
- ✅ Delete gambar individual
- ✅ Validasi gambar wajib
- ✅ Simpan ke database
- ✅ Tampil di website ecommerce
- ✅ Support base64 dan URL images
- ✅ Responsive design

## 🎨 UI/UX Features:
- Drag & drop area (visual feedback)
- Tabs untuk switch antara upload dan URL
- Grid layout untuk preview images
- Delete button dengan konfirmasi
- Loading states
- Error handling

## 🔄 Sync dengan Ecommerce:
Produk yang ditambahkan di Dashboard Admin akan otomatis muncul di:
- Homepage (Produk Unggulan & Terbaru)
- Product List Page
- Product Detail Page
- Search Results

Fitur upload gambar sudah fully functional dan terintegrasi dengan seluruh sistem!