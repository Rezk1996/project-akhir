# 📊 Struktur Database R-Mart Setelah Perbaikan

## 🗂️ **DAFTAR SEMUA TABEL (11 Tabel Utama)**

### 1. **USERS** - Tabel Pengguna Utama
```sql
users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    phone VARCHAR(20),
    address TEXT,
    marital_status VARCHAR(20),
    birth_date DATE,
    gender VARCHAR(10),
    profile_image VARCHAR(500),
    role user_role_type DEFAULT 'customer', -- 'admin' | 'customer'
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Menyimpan semua pengguna (admin & customer)

### 2. **CATEGORIES** - Kategori Produk
```sql
categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    image VARCHAR(500),
    icon_color VARCHAR(7),
    icon VARCHAR(100),
    parent_id BIGINT REFERENCES categories(id),
    created_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Kategori produk (Makanan, Minuman, dll)

### 3. **PRODUCTS** - Produk Utama
```sql
products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(12,2) CHECK (price > 0),
    original_price NUMERIC(12,2),
    discount INTEGER DEFAULT 0,
    image VARCHAR(500),
    description TEXT DEFAULT 'Produk berkualitas',
    rating NUMERIC(2,1) DEFAULT 4.5 CHECK (rating BETWEEN 0 AND 5),
    sold INTEGER DEFAULT 0,
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    category_id BIGINT REFERENCES categories(id),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Menyimpan semua produk e-commerce

### 4. **PRODUCT_IMAGES** - Gambar Produk
```sql
product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    url VARCHAR(500),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Multiple gambar untuk setiap produk

### 5. **ADDRESSES** - Alamat Pengiriman
```sql
addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255),
    phone VARCHAR(20),
    street TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(10),
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Alamat pengiriman user

### 6. **CARTS** - Keranjang Belanja
```sql
carts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Keranjang utama per user

### 7. **CART_ITEMS** - Item dalam Keranjang
```sql
cart_items (
    id BIGSERIAL PRIMARY KEY,
    cart_id BIGINT REFERENCES carts(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    UNIQUE(cart_id, product_id)
)
```
**Fungsi**: Detail produk dalam keranjang

### 8. **ORDERS** - Pesanan/Transaksi
```sql
orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    total_amount NUMERIC(15,2) NOT NULL,
    shipping_cost NUMERIC(12,2) DEFAULT 0,
    status transaction_status_type DEFAULT 'pending',
    shipping_address_id BIGINT REFERENCES addresses(id),
    shipping_address TEXT,
    phone_number VARCHAR(20),
    notes TEXT,
    payment_method payment_method_type,
    payment_status payment_status_type DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Header pesanan/transaksi

### 9. **ORDER_ITEMS** - Detail Pesanan
```sql
order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER CHECK (quantity > 0),
    price NUMERIC(15,2) CHECK (price >= 0),
    subtotal NUMERIC(15,2) GENERATED ALWAYS AS (quantity * price) STORED,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Detail produk dalam pesanan

### 10. **REVIEWS** - Review Produk
```sql
reviews (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    rating NUMERIC(2,1) CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
)
```
**Fungsi**: Review dan rating produk

### 11. **WISHLISTS** - Wishlist
```sql
wishlists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE(user_id, product_id)
)
```
**Fungsi**: Produk favorit user

### 12. **COUPONS** - Kupon Diskon
```sql
coupons (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    discount_type VARCHAR(10) CHECK (discount_type IN ('percent', 'fixed')),
    discount_value NUMERIC(10,2),
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    usage_limit INTEGER,
    used_count INTEGER DEFAULT 0
)
```
**Fungsi**: Sistem kupon dan diskon

## 🔗 **RELASI ANTAR TABEL**

```
users (1) ←→ (∞) addresses
users (1) ←→ (1) carts
users (1) ←→ (∞) orders
users (1) ←→ (∞) reviews
users (1) ←→ (∞) wishlists

categories (1) ←→ (∞) products
categories (1) ←→ (∞) categories (self-reference)

products (1) ←→ (∞) product_images
products (1) ←→ (∞) cart_items
products (1) ←→ (∞) order_items
products (1) ←→ (∞) reviews
products (1) ←→ (∞) wishlists

carts (1) ←→ (∞) cart_items
orders (1) ←→ (∞) order_items
addresses (1) ←→ (∞) orders
```

## 📋 **ENUM TYPES**

```sql
user_role_type: 'admin', 'customer'
payment_status_type: 'pending', 'paid', 'failed', 'refunded'
payment_method_type: 'bank_transfer', 'credit_card', 'ewallet', 'cod'
transaction_status_type: 'pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed'
```

## 🔧 **FUNCTIONS & TRIGGERS**

- **update_updated_at_column()** - Auto update timestamp
- **Triggers** pada semua tabel dengan kolom `updated_at`

## ✅ **TABEL YANG DIHAPUS (Legacy)**

- ❌ `keranjang` → Diganti `carts + cart_items`
- ❌ `barang` → Diganti `products`
- ❌ `jenis_barang` → Diganti `categories`
- ❌ `customer` → Diganti `users`
- ❌ `transaksi` → Diganti `orders`
- ❌ `detail_transaksi` → Diganti `order_items`
- ❌ `admin` → Digabung ke `users`
- ❌ `point_member` → Tidak diperlukan
- ❌ Views `products` & `categories` → Jadi tabel nyata

## 🎯 **KEUNGGULAN STRUKTUR BARU**

- ✅ Tidak ada duplikasi tabel
- ✅ Relasi yang jelas dan konsisten
- ✅ Support multi-gambar produk
- ✅ Sistem role-based (admin/customer)
- ✅ Flexible payment & shipping
- ✅ Review & wishlist system
- ✅ Auto timestamp updates