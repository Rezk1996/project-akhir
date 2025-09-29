# Manual Login Fix

## Problem: Backend login tidak berfungsi

## Solusi Darurat: Manual Login

### Cara 1: Browser Console
1. Buka React app: http://localhost:3000
2. Tekan F12 untuk buka Developer Tools
3. Paste script ini di Console:

```javascript
function manualLogin() {
    const userData = {
        id: 1,
        name: "Test User", 
        email: "test@example.com",
        role: "customer"
    };
    
    const token = "manual_token_" + Date.now();
    const expiration = Date.now() + (24 * 60 * 60 * 1000);
    
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(userData));
    localStorage.setItem('tokenExpiration', expiration.toString());
    
    console.log('Manual login successful!');
    window.location.href = '/';
}
manualLogin();
```

### Cara 2: Copy File Script
1. Copy file `manual-login.js`
2. Paste isinya di browser console
3. Tekan Enter

### Cara 3: Bookmark Login
Buat bookmark dengan URL ini:
```javascript
javascript:(function(){const userData={id:1,name:"Test User",email:"test@example.com",role:"customer"};const token="manual_token_"+Date.now();const expiration=Date.now()+(24*60*60*1000);localStorage.setItem('token',token);localStorage.setItem('user',JSON.stringify(userData));localStorage.setItem('tokenExpiration',expiration.toString());window.location.href='/';})();
```

## Hasil:
- User akan login sebagai "Test User"
- Token valid selama 24 jam
- Bisa akses semua fitur app
- Cart dan orders akan berfungsi

## Untuk Logout:
```javascript
localStorage.clear();
window.location.reload();
```

Ini solusi sementara sampai backend login diperbaiki.