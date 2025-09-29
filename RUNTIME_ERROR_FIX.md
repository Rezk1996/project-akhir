# Perbaikan Runtime Error - toLowerCase() undefined

## Masalah
Error runtime terjadi karena beberapa fungsi mencoba mengakses method `toLowerCase()` pada nilai yang undefined:
```
Cannot read properties of undefined (reading 'toLowerCase')
```

## Penyebab
Error terjadi di beberapa lokasi:
1. **CartPage.tsx** - `item.name.toLowerCase()` ketika `item.name` undefined
2. **ProductContext.tsx** - `p.name.toLowerCase()`, `p.description.toLowerCase()`, `p.category.toLowerCase()` ketika properti undefined
3. **HeroSection.tsx** - `name.toLowerCase()` ketika parameter `name` undefined

## Solusi yang Diterapkan

### 1. CartPage.tsx
```typescript
// Sebelum
const name = item.name.toLowerCase();

// Sesudah  
const name = item.name?.toLowerCase() || '';
```

### 2. ProductContext.tsx
```typescript
// Sebelum
return products.filter(p => 
  p.name.toLowerCase().includes(lowercaseQuery) ||
  p.description.toLowerCase().includes(lowercaseQuery) ||
  p.category.toLowerCase().includes(lowercaseQuery)
);

// Sesudah
return products.filter(p => 
  (p.name?.toLowerCase() || '').includes(lowercaseQuery) ||
  (p.description?.toLowerCase() || '').includes(lowercaseQuery) ||
  (p.category?.toLowerCase() || '').includes(lowercaseQuery)
);
```

### 3. HeroSection.tsx
```typescript
// Sebelum
const getEmojiForCategory = (name: string): string => {
  const lowerName = name.toLowerCase();
  // ...
};

// Sesudah
const getEmojiForCategory = (name: string): string => {
  if (!name) return '🛒';
  const lowerName = name.toLowerCase();
  // ...
};
```

## Teknik yang Digunakan

1. **Optional Chaining (`?.`)** - Mengakses properti dengan aman
2. **Nullish Coalescing (`||`)** - Memberikan nilai default jika undefined
3. **Null Check** - Validasi parameter sebelum digunakan

## File yang Diperbaiki

- `CartPage.tsx` - Perbaikan di fungsi `getRecommendations`
- `ProductContext.tsx` - Perbaikan di fungsi `searchProducts`  
- `HeroSection.tsx` - Perbaikan di helper functions

## Hasil
- Error runtime telah teratasi
- Aplikasi dapat berjalan tanpa crash
- Fungsi pencarian dan rekomendasi bekerja dengan aman
- Kategori dapat ditampilkan tanpa error

## Testing
Untuk memverifikasi perbaikan:
1. Buka aplikasi di browser
2. Navigasi ke halaman cart
3. Lakukan pencarian produk
4. Klik kategori di homepage
5. Pastikan tidak ada error di console