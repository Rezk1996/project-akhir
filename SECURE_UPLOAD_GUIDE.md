# 🔐 Secure Upload Guide - GitHub

## ⚠️ Keamanan Penting

**JANGAN PERNAH** share password di chat/email. Untuk keamanan, ikuti langkah berikut:

## 🚀 Cara Upload yang Aman

### Step 1: Login Manual ke GitHub
1. **Buka browser** → https://github.com/login
2. **Login dengan:**
   - Email: muhrezkisetiawan96@gmail.com
   - Password: (gunakan password Anda)

### Step 2: Buat Personal Access Token (Recommended)
1. **Setelah login** → https://github.com/settings/tokens
2. **"Generate new token"** → "Generate new token (classic)"
3. **Settings:**
   - Note: `Project Upload`
   - Expiration: `90 days`
   - Scopes: ✅ `repo` (full control)
4. **Generate & Copy token**

### Step 3: Upload Project
```bash
cd /Users/user/Documents/ProjectWeb

# Push ke GitHub
git push -u origin main
```

**Saat diminta credentials:**
- Username: `rezk1996`
- Password: **Paste Personal Access Token** (bukan password asli)

### Alternative: GitHub Desktop (Easiest)
1. **Download:** https://desktop.github.com/
2. **Login dengan akun GitHub Anda**
3. **Add Local Repository:** `/Users/user/Documents/ProjectWeb`
4. **Publish to GitHub** → pilih repository `project-akhir`

## ✅ Yang Sudah Disiapkan

- ✅ Git config: muhrezkisetiawan96@gmail.com
- ✅ Remote: https://github.com/rezk1996/project-akhir.git
- ✅ Project ready (181 files)
- ✅ Initial commit done

## 🎯 Repository Target

**https://github.com/rezk1996/project-akhir**

## 🔒 Security Tips

1. **Gunakan Personal Access Token** instead of password
2. **Jangan share credentials** di chat/email
3. **Enable 2FA** di GitHub account
4. **Revoke token** setelah tidak digunakan

---

**Ikuti langkah di atas untuk upload yang aman!** 🚀