# Update Kategori Produk di Halaman Depan

## Perubahan yang Dilakukan

### 1. HomePage.tsx
- **Menghapus data kategori mock** yang hardcoded (Electronics, Fashion, Books, Home, Sports)
- **Menambahkan state categories** untuk menyimpan data kategori dari database
- **Mengintegrasikan API call** ke `productService.getCategories()` untuk mengambil data kategori dari database
- **Menambahkan error handling** untuk kasus jika API gagal
- **Memformat data kategori** sesuai dengan struktur yang dibutuhkan komponen CategorySection

### 2. CategorySection.tsx
- **Menambahkan field icon_color** pada interface Category untuk mendukung warna ikon dari database

### 3. Struktur Data Kategori
Data kategori sekarang diambil dari database dengan struktur:
```typescript
{
  id: number,
  name: string,
  image: string,
  icon_color: string,
  link: string
}
```

### 4. Endpoint API
Menggunakan endpoint `/api/products/categories` yang sudah tersedia di backend untuk mengambil data kategori.

## Kategori yang Tersedia di Database

Berdasarkan file `new_categories.sql`, kategori yang tersedia:
1. Kebutuhan Dapur
2. Kebutuhan Ibu & Anak  
3. Kebutuhan Rumah
4. Makanan
5. Minuman
6. Produk Segar & Beku
7. Personal Care
8. Kebutuhan Kesehatan
9. Lifestyle
10. Pet Foods

## HeroSection Baru

### Komponen yang Dibuat:
- **HeroSection.tsx** - Komponen baru yang menggabungkan Banner dengan kategori produk
- Menampilkan 10 kategori sesuai database dalam layout yang kompak
- Setiap kategori memiliki ikon berwarna dan nama yang sesuai

### Kategori yang Ditampilkan:
1. Kebutuhan Dapur (#FF6B35)
2. Kebutuhan Ibu & Anak (#FF69B4)
3. Kebutuhan Rumah (#4CAF50)
4. Makanan (#FFA726)
5. Minuman (#42A5F5)
6. Produk Segar & Beku (#66BB6A)
7. Personal Care (#AB47BC)
8. Kebutuhan Kesehatan (#EF5350)
9. Lifestyle (#26C6DA)
10. Pet Foods (#8D6E63)

## Cara Kerja

1. HeroSection menampilkan banner slider di bagian atas
2. Di bawah banner, kategori produk ditampilkan dalam grid responsif
3. Setiap kategori memiliki ikon dengan warna yang unik
4. Kategori dapat diklik untuk mengarah ke halaman produk dengan filter kategori

## Testing

Untuk memastikan perubahan bekerja:
1. Pastikan backend berjalan dan database berisi data kategori
2. Buka halaman depan website
3. Kategori produk seharusnya menampilkan data dari database, bukan data mock
4. Klik pada kategori untuk memastikan link mengarah ke halaman produk dengan filter yang benar