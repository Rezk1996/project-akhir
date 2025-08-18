# Rmart - Professional Ecommerce Application

Aplikasi ecommerce profesional yang dibangun dengan **Spring Boot** (Backend) dan **React TypeScript** (Frontend).

## 🚀 Fitur Utama

### Backend (Spring Boot)
- ✅ **Authentication System** - Register, Login, Logout
- ✅ **Product Management** - CRUD operations untuk produk
- ✅ **Category Management** - Pengelolaan kategori produk
- ✅ **RESTful API** - API endpoints yang terstruktur
- ✅ **Database Integration** - PostgreSQL dengan JPA/Hibernate
- ✅ **CORS Configuration** - Mendukung cross-origin requests
- ✅ **Swagger Documentation** - API documentation

### Frontend (React TypeScript)
- ✅ **Modern UI/UX** - Material-UI components dengan styled-components
- ✅ **Responsive Design** - Mobile-friendly interface
- ✅ **Authentication Pages** - Login dan Register dengan validasi
- ✅ **Product Catalog** - Tampilan produk dengan kategori
- ✅ **Shopping Cart** - Keranjang belanja (UI ready)
- ✅ **Search Functionality** - Pencarian produk
- ✅ **Professional Layout** - Header, Footer, Navigation

## 🛠️ Tech Stack

### Backend
- **Java 11+**
- **Spring Boot 2.7+**
- **Spring Data JPA**
- **PostgreSQL**
- **Maven**
- **Swagger/OpenAPI**

### Frontend
- **React 18**
- **TypeScript**
- **Material-UI (MUI)**
- **Styled Components**
- **Axios**
- **React Router**

## 📋 Prerequisites

Pastikan Anda telah menginstall:

1. **Java 11 atau lebih tinggi**
2. **Maven 3.6+**
3. **Node.js 16+ dan npm**
4. **Database (MySQL, PostgreSQL, H2, dll)**

## 🚀 Quick Start

### 1. Setup Database

```properties
# Configure your database in Backend/src/main/resources/application.properties
# Example for MySQL:
# spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce
# spring.datasource.username=root
# spring.datasource.password=password
# spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### 2. Konfigurasi Backend

```bash
# Edit Backend/src/main/resources/application.properties
# Tambahkan konfigurasi database Anda:
# spring.datasource.url=jdbc:your_database://localhost:port/database_name
# spring.datasource.username=your_username
# spring.datasource.password=your_password
# spring.datasource.driver-class-name=your.database.Driver
```

### 3. Jalankan Backend

```bash
# Opsi 1: Menggunakan script
./start-backend.sh

# Opsi 2: Manual
cd Backend
mvn spring-boot:run
```

Backend akan berjalan di: `http://localhost:8191`

### 4. Jalankan Frontend

```bash
# Opsi 1: Menggunakan script
./start-frontend.sh

# Opsi 2: Manual
cd Frontend/frontend
npm install
npm start
```

Frontend akan berjalan di: `http://localhost:3000`

## 📚 API Documentation

Setelah backend berjalan, akses dokumentasi API di:
- **Swagger UI**: `http://localhost:8191/swagger-ui.html`

### Main API Endpoints

#### Authentication
- `POST /api/auth/register` - Registrasi user baru
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

#### Products
- `GET /api/products` - Get all products (dengan pagination)
- `GET /api/products/{id}` - Get product by ID
- `GET /api/products/categories` - Get all categories
- `GET /api/products/featured` - Get featured products

## 🗄️ Database Schema

### Tables
- `tbl_users` - User data dengan authentication
- `tbl_products` - Product catalog
- `tbl_sales` - Sales transactions (existing)

## 🔧 Development

### Backend Development
```bash
cd Backend
mvn clean compile
mvn spring-boot:run
```

### Frontend Development
```bash
cd Frontend/frontend
npm run start
npm run build  # untuk production build
```

## 🧪 Testing

### Test User Accounts
Gunakan akun berikut untuk testing:

```
Email: john@example.com
Password: password123

Email: jane@example.com  
Password: password123

Email: admin@rmart.com
Password: admin123
```

## 📱 Screenshots & Features

### 1. Homepage
- Banner carousel dengan promosi
- Kategori produk
- Produk unggulan dan terbaru
- Search bar

### 2. Authentication
- Register page dengan validasi
- Login page dengan error handling
- Responsive design

### 3. Product Catalog
- Grid layout produk
- Filter by category
- Search functionality
- Pagination

## 🚀 Production Deployment

### Backend
```bash
mvn clean package
java -jar target/springboot-*.jar
```

### Frontend
```bash
npm run build
# Deploy build folder ke web server
```

## 🤝 Contributing

1. Fork the project
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

- **Backend Developer**: Spring Boot & PostgreSQL
- **Frontend Developer**: React TypeScript & Material-UI
- **Full Stack Integration**: API Integration & Authentication

## 📞 Support

Jika ada pertanyaan atau masalah:
1. Check dokumentasi API di Swagger
2. Review console logs untuk debugging
3. Pastikan database connection berjalan dengan baik

---

**Happy Coding! 🎉**