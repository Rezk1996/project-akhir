# 🛒 R-Mart E-commerce System

Sistem e-commerce lengkap dengan dashboard admin yang dibangun menggunakan Spring Boot (Backend), React (Frontend), dan PostgreSQL (Database).

## 🚀 Fitur Utama

### 🛍️ E-commerce Frontend
- **Homepage** dengan banner dan kategori produk
- **Pencarian Produk** berdasarkan nama dan kategori
- **Filter Kategori** yang dapat diklik
- **Product List** dengan pagination dan sorting
- **Shopping Cart** dan checkout
- **User Authentication** (Login/Register)
- **Responsive Design** untuk mobile dan desktop

### 📊 Admin Dashboard
- **Product Management** (CRUD operations)
- **Category Management**
- **User Management**
- **Sales Reports**
- **Dashboard Analytics**
- **Employee Management**
- **Attendance System**

### 🔧 Backend API
- **RESTful API** dengan Spring Boot
- **JWT Authentication**
- **PostgreSQL Database**
- **Input Validation & Security**
- **CORS Configuration**
- **Rate Limiting**

## 🏗️ Arsitektur Sistem

```
ProjectWeb/
├── Ecommerce/
│   ├── Backend/          # Spring Boot API
│   └── Frontend/         # React E-commerce
├── Dashboard_Admin/      # React Admin Dashboard
├── Database/            # SQL scripts
└── Documentation/       # Project docs
```

## 🛠️ Tech Stack

**Backend:**
- Java 17
- Spring Boot 3.x
- Spring Security
- Spring Data JPA
- PostgreSQL
- Maven

**Frontend:**
- React 18
- TypeScript
- Material-UI
- Styled Components
- Axios
- React Router

**Database:**
- PostgreSQL 14+

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Node.js 16+
- PostgreSQL 14+
- Maven 3.6+

### 1. Database Setup
```bash
# Create database
createdb rmart_db

# Run database scripts
psql -d rmart_db -f database_schema.sql
psql -d rmart_db -f sample_data.sql
```

### 2. Backend Setup
```bash
cd Ecommerce/Backend
mvn clean install
mvn spring-boot:run
```
Backend akan berjalan di: http://localhost:8191

### 3. Frontend E-commerce Setup
```bash
cd Ecommerce/Frontend/frontend
npm install
npm start
```
Frontend akan berjalan di: http://localhost:3000

### 4. Admin Dashboard Setup
```bash
cd Dashboard_Admin
npm install
npm start
```
Dashboard akan berjalan di: http://localhost:3001

## 📱 Fitur Terbaru

### ✨ Filter Kategori & Pencarian
- **Kategori Clickable**: Klik kategori di homepage untuk filter produk
- **Smart Search**: Pencarian berdasarkan nama produk dan kategori
- **Search Suggestions**: Dropdown suggestions saat mengetik
- **URL Parameters**: Support untuk `/products?category=Makanan` dan `/products?search=susu`

### 🎨 Modern UI/UX
- **Professional Icons**: SVG icons yang modern dan clean
- **Smooth Animations**: Hover effects dan transitions
- **Responsive Design**: Optimal di semua device
- **Loading States**: Skeleton loading dan progress indicators

## 🔗 API Endpoints

### Products
- `GET /api/products` - Get all products
- `GET /api/products?category={name}` - Filter by category
- `GET /api/products?search={term}` - Search products
- `GET /api/products/{id}` - Get product by ID

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/products/category/{name}` - Get products by category

### Admin
- `POST /api/admin/products` - Create product
- `PUT /api/admin/products/{id}` - Update product
- `DELETE /api/admin/products/{id}` - Delete product

## 🧪 Testing

### Manual Testing
```bash
# Test category filter & search
./test_category_search_features.sh

# Test product creation
./test_product_creation.sh

# Open HTML test file
open test_category_filter.html
```

### Frontend Testing
1. Homepage: http://localhost:3000
2. Category Filter: http://localhost:3000/products?category=Makanan
3. Search: http://localhost:3000/products?search=susu

## 📚 Documentation

- [Fitur Kategori & Pencarian](FITUR_KATEGORI_PENCARIAN.md)
- [Dashboard Admin Guide](DASHBOARD_ADMIN_WORKING.md)
- [Security Implementation](SECURITY_FIXES_COMPLETED.md)
- [Database Schema](database_schema.sql)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Spring Boot Team
- React Team
- Material-UI Team
- PostgreSQL Community

---

⭐ **Star this repo if you find it helpful!** ⭐