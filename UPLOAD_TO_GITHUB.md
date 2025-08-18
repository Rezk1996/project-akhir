# 🚀 Upload Project ke GitHub - Akun rezk1996

## Langkah 1: Buat Repository di GitHub (Manual)

1. **Buka browser** dan pergi ke https://github.com/rezk1996
2. **Klik "New repository"** (tombol hijau)
3. **Isi detail:**
   - Repository name: `rmart-ecommerce-system`
   - Description: `Complete e-commerce system with Spring Boot backend, React frontend, and admin dashboard`
   - Pilih **Public**
   - **JANGAN** centang "Add a README file"
   - **JANGAN** centang "Add .gitignore"
4. **Klik "Create repository"**

## Langkah 2: Upload dari Terminal

Setelah repository dibuat, jalankan perintah ini:

```bash
cd /Users/user/Documents/ProjectWeb

# Push ke GitHub (akan minta username dan password/token)
git push -u origin main
```

**Saat diminta credentials:**
- Username: `rezk1996`
- Password: Gunakan **Personal Access Token** (bukan password biasa)

## Langkah 3: Buat Personal Access Token (Jika Belum Ada)

1. **Pergi ke GitHub Settings:** https://github.com/settings/tokens
2. **Klik "Generate new token"** > "Generate new token (classic)"
3. **Isi detail:**
   - Note: `RMart Ecommerce Upload`
   - Expiration: `90 days` atau sesuai kebutuhan
   - Scopes: Centang `repo` (full control of private repositories)
4. **Klik "Generate token"**
5. **Copy token** dan simpan (tidak akan ditampilkan lagi)

## Langkah 4: Alternative - Upload via GitHub Desktop

Jika ada masalah dengan command line:

1. **Download GitHub Desktop** dari https://desktop.github.com/
2. **Login dengan akun rezk1996**
3. **Add existing repository** dan pilih folder `/Users/user/Documents/ProjectWeb`
4. **Publish repository** dengan nama `rmart-ecommerce-system`

## Status Saat Ini ✅

- ✅ Git repository sudah diinisialisasi
- ✅ Initial commit sudah dibuat (181 files)
- ✅ Branch main sudah disiapkan
- ✅ Remote origin sudah ditambahkan ke https://github.com/rezk1996/rmart-ecommerce-system.git
- ✅ User config sudah diset ke rezk1996

## Tinggal Langkah Terakhir:

1. **Buat repository** di GitHub (manual via browser)
2. **Push dengan command:** `git push -u origin main`
3. **Masukkan credentials** saat diminta

**Repository akan tersedia di:** https://github.com/rezk1996/rmart-ecommerce-system