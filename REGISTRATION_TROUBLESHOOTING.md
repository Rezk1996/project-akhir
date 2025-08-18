# Registration Troubleshooting Guide

## Masalah yang Diperbaiki

### 1. Error "Registration failed. Please try again."

**Penyebab:**
- Backend tidak berjalan atau tidak dapat diakses
- Masalah koneksi database
- Error handling yang tidak memadai
- Validasi input yang tidak konsisten

**Solusi yang Diterapkan:**

#### Backend (AuthService.java):
- ✅ Menambahkan logging untuk debugging
- ✅ Memperbaiki error handling untuk database constraint violations
- ✅ Normalisasi email dengan `toLowerCase().trim()`
- ✅ Validasi input yang lebih ketat
- ✅ Pesan error yang lebih spesifik

#### Frontend (RegisterPage.tsx):
- ✅ Validasi client-side yang lebih komprehensif
- ✅ Error handling yang lebih baik untuk berbagai jenis error
- ✅ Normalisasi input sebelum dikirim ke backend
- ✅ Pesan error yang lebih informatif

#### API Service (api.ts):
- ✅ Timeout untuk request (10 detik)
- ✅ Error handling untuk berbagai status code
- ✅ Logging untuk debugging

## Validasi yang Diterapkan

### Backend Validation:
- Name: minimal 2 karakter, tidak boleh kosong
- Email: format email valid, tidak boleh duplikat
- Password: minimal 6 karakter

### Frontend Validation:
- Name: minimal 2 karakter
- Email: format email valid
- Password: minimal 6 karakter
- Confirm Password: harus sama dengan password
- Terms Agreement: harus disetujui

## Testing

Gunakan script `test-registration.sh` untuk menguji berbagai skenario:

```bash
./test-registration.sh
```

Test cases yang dicakup:
1. ✅ Registrasi valid dengan email baru
2. ✅ Registrasi dengan email duplikat
3. ✅ Format email tidak valid
4. ✅ Password terlalu pendek
5. ✅ Name kosong

## Monitoring

### Backend Logs:
```bash
tail -f /Users/user/Documents/ProjectWeb/Ecommerce/Backend/backend.log
```

### Database Check:
```sql
SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC LIMIT 10;
```

## Troubleshooting Steps

### 1. Cek Backend Status
```bash
curl -s http://localhost:8191/api/auth/register -X POST -H "Content-Type: application/json" -d '{}'
```

### 2. Cek Database Connection
```bash
psql -h localhost -U postgres -d DB_Rmart -c "SELECT 1;"
```

### 3. Cek Frontend Console
- Buka Developer Tools (F12)
- Lihat Console tab untuk error messages
- Lihat Network tab untuk API requests

### 4. Common Issues

#### "Port 8191 already in use"
```bash
pkill -f "java.*springboot"
mvn spring-boot:run
```

#### "Database connection failed"
```bash
# Start PostgreSQL
brew services start postgresql
# atau
pg_ctl -D /usr/local/var/postgres start
```

#### "Email already registered" untuk email baru
- Cek database untuk duplikat dengan case-insensitive search
- Restart backend untuk clear cache

## Status Saat Ini

✅ **FIXED**: Registration API berfungsi normal
✅ **TESTED**: Semua validasi berjalan dengan baik
✅ **DOCUMENTED**: Troubleshooting guide tersedia

## Next Steps

1. Monitor production untuk error patterns
2. Implement rate limiting untuk registration
3. Add email verification (optional)
4. Implement password strength meter (optional)