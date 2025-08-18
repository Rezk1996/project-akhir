# Rmart Admin Dashboard

Dashboard admin untuk mengelola project ecommerce Rmart yang terintegrasi dengan backend yang sama.

## Fitur Dashboard

### 📊 Dashboard Overview
- **Statistik Real-time**: Total produk, users, orders, revenue
- **Grafik Penjualan**: Line chart untuk trend penjualan 30 hari terakhir
- **Grafik Orders**: Bar chart untuk overview orders
- **Alert Stok Rendah**: Monitoring produk dengan stok < 10
- **Pending Orders**: Tracking orders yang perlu diproses

### 🛍️ Product Management
- **CRUD Operations**: Create, Read, Update, Delete produk
- **Kategori Integration**: Dropdown kategori dari database
- **Stock Management**: Monitoring dan update stok
- **Image Upload**: URL-based image management
- **Price & Discount**: Pengaturan harga dan diskon
- **Status Indicators**: Visual indicator untuk status stok

### 📂 Category Management
- **CRUD Operations**: Manajemen kategori produk
- **Icon & Color**: Customizable icon dan warna kategori
- **Visual Preview**: Preview icon dengan warna yang dipilih

### 📦 Orders Management
- **Order Tracking**: Melihat semua orders dengan detail
- **Status Update**: Update status order (pending, processing, shipped, delivered, cancelled)
- **Payment Status**: Monitoring status pembayaran
- **Customer Info**: Informasi customer untuk setiap order

### 👥 Users Management
- **User List**: Daftar semua users (admin & customer)
- **Role Management**: Visual indicator untuk role user
- **Registration Tracking**: Tanggal bergabung user

## Teknologi yang Digunakan

### Frontend
- **React 18** dengan TypeScript
- **Material-UI (MUI)** untuk UI components
- **React Router** untuk navigation
- **Recharts** untuk grafik dan visualisasi
- **Axios** untuk API calls
- **Styled Components** untuk custom styling

### Backend Integration
- **Spring Boot API** (menggunakan backend ecommerce yang sama)
- **PostgreSQL Database** (database yang sama dengan ecommerce)
- **JWT Authentication** untuk admin access
- **RESTful API** endpoints

## Setup dan Installation

### Prerequisites
- Node.js (v16 atau lebih tinggi)
- Backend ecommerce sudah running di port 8191

### Installation Steps

1. **Install Dependencies**
   ```bash
   cd Dashboard_Admin
   npm install
   ```

2. **Start Development Server**
   ```bash
   npm start
   ```

3. **Access Dashboard**
   - URL: http://localhost:3000
   - Login dengan akun admin yang sudah ada di database

## API Endpoints yang Digunakan

### Authentication
- `POST /api/auth/login` - Admin login

### Dashboard
- `GET /api/admin/dashboard/stats` - Dashboard statistics
- `GET /api/admin/dashboard/sales-chart` - Sales chart data

### Products
- `GET /api/products` - Get all products
- `POST /api/admin/products` - Create product
- `PUT /api/admin/products/{id}` - Update product
- `DELETE /api/admin/products/{id}` - Delete product

### Categories
- `GET /api/products/categories` - Get all categories
- `POST /api/admin/categories` - Create category
- `PUT /api/admin/categories/{id}` - Update category
- `DELETE /api/admin/categories/{id}` - Delete category

### Users & Orders
- `GET /api/admin/users` - Get all users
- `GET /api/admin/orders` - Get all orders
- `PUT /api/admin/orders/{id}/status` - Update order status

## Struktur Project

```
Dashboard_Admin/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   │   └── Layout.tsx          # Main layout dengan sidebar
│   ├── pages/
│   │   ├── LoginPage.tsx       # Halaman login admin
│   │   ├── DashboardPage.tsx   # Dashboard utama
│   │   ├── ProductsPage.tsx    # Manajemen produk
│   │   ├── CategoriesPage.tsx  # Manajemen kategori
│   │   ├── OrdersPage.tsx      # Manajemen orders
│   │   └── UsersPage.tsx       # Manajemen users
│   ├── services/
│   │   └── api.ts              # API service layer
│   ├── types/
│   │   └── index.ts            # TypeScript interfaces
│   ├── App.tsx                 # Main app component
│   └── index.tsx               # Entry point
├── package.json
└── README.md
```

## Keamanan

- **Admin Only Access**: Hanya user dengan role 'admin' yang bisa akses
- **JWT Token**: Authentication menggunakan JWT token
- **Protected Routes**: Semua routes dilindungi dengan authentication
- **CORS Configuration**: Configured untuk localhost development

## Development Notes

- Dashboard terintegrasi penuh dengan backend ecommerce
- Menggunakan database yang sama dengan aplikasi ecommerce
- Real-time data dari database production
- Responsive design untuk desktop dan mobile
- Error handling dan loading states
- Consistent UI/UX dengan tema Rmart

## Future Enhancements

- [ ] File upload untuk product images
- [ ] Bulk operations untuk products
- [ ] Advanced filtering dan search
- [ ] Export data ke Excel/PDF
- [ ] Real-time notifications
- [ ] Advanced analytics dan reports
- [ ] User role management
- [ ] Inventory alerts dan automation