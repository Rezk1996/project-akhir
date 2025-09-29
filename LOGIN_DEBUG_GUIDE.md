# Login Debug Guide

## Masalah: Login tidak ada reaksi walaupun email dan password benar

### Langkah Troubleshooting:

#### 1. Test Backend API Langsung
```bash
curl -X POST http://localhost:8191/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@rmart.com", "password": "admin123"}'
```

**Expected Response:**
```json
{
  "message": "Login successful",
  "status": true,
  "data": {
    "user": {...},
    "token": "session_...",
    "expiresIn": 86400
  }
}
```

#### 2. Test Frontend dengan Debug Page
Buka: `test-login-debug.html`
- Masukkan email: `admin@rmart.com`
- Masukkan password: `admin123`
- Klik "Test Login"
- Periksa console browser untuk error

#### 3. Periksa Browser Console
Buka Developer Tools (F12) dan lihat:
- Network tab untuk request/response
- Console tab untuk JavaScript errors
- Application tab untuk localStorage

#### 4. Periksa localStorage
Setelah login berhasil, periksa:
```javascript
localStorage.getItem('token')
localStorage.getItem('user')
localStorage.getItem('tokenExpiration')
```

### User Credentials untuk Testing:

**Admin User:**
- Email: `admin@rmart.com`
- Password: `admin123`

### Common Issues dan Solutions:

#### Issue 1: CORS Error
**Symptoms:** Network error, CORS policy error
**Solution:** Pastikan backend CORS configuration benar

#### Issue 2: 401 Unauthorized
**Symptoms:** "Invalid email or password"
**Solution:** 
- Periksa email/password benar
- Periksa user ada di database
- Periksa password encoding

#### Issue 3: Frontend tidak redirect
**Symptoms:** Login berhasil tapi tidak redirect
**Solution:**
- Periksa AuthContext state update
- Periksa navigation logic di LoginPage
- Periksa isAuthenticated logic

#### Issue 4: Token tidak tersimpan
**Symptoms:** Login berhasil tapi token hilang
**Solution:**
- Periksa localStorage storage
- Periksa token expiration logic
- Periksa authService implementation

### Debug Steps:

1. **Backend Test:**
   ```bash
   ./test-login-backend.sh
   ```

2. **Frontend Test:**
   ```bash
   open test-login-debug.html
   ```

3. **Full Integration Test:**
   - Buka React app: http://localhost:3000/login
   - Buka Developer Tools
   - Coba login dengan admin credentials
   - Periksa console logs

### Files Modified untuk Debug:

1. **AuthContext.tsx** - Added console logging
2. **api.ts** - Added console logging  
3. **test-login-debug.html** - Debug page
4. **LOGIN_DEBUG_GUIDE.md** - This guide

### Expected Behavior:

1. User masukkan email/password
2. Frontend kirim POST ke `/api/auth/login`
3. Backend return success dengan token
4. Frontend simpan token ke localStorage
5. AuthContext update user state
6. LoginPage redirect ke homepage
7. User berhasil login

### Jika Masih Bermasalah:

1. Restart backend dan frontend
2. Clear browser cache dan localStorage
3. Periksa network connectivity
4. Periksa database connection
5. Check backend logs untuk error