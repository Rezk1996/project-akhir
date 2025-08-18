# 🚀 Instruksi Upload ke GitHub

## Langkah 1: Buat Repository di GitHub

1. **Buka GitHub.com** dan login ke akun Anda
2. **Klik tombol "New"** atau "+" di pojok kanan atas
3. **Isi detail repository:**
   - Repository name: `rmart-ecommerce-system` (atau nama yang Anda inginkan)
   - Description: `Complete e-commerce system with Spring Boot backend, React frontend, and admin dashboard`
   - Pilih **Public** atau **Private** sesuai kebutuhan
   - **JANGAN** centang "Add a README file" (karena sudah ada)
   - **JANGAN** centang "Add .gitignore" (karena sudah ada)
   - **JANGAN** centang "Choose a license" (bisa ditambah nanti)
4. **Klik "Create repository"**

## Langkah 2: Connect Local Repository ke GitHub

Setelah repository dibuat, GitHub akan menampilkan instruksi. Jalankan perintah berikut di terminal:

```bash
# Masuk ke folder project
cd /Users/user/Documents/ProjectWeb

# Tambahkan remote origin (ganti USERNAME dan REPO_NAME sesuai milik Anda)
git remote add origin https://github.com/USERNAME/REPO_NAME.git

# Push ke GitHub
git push -u origin main
```

**Contoh:**
```bash
git remote add origin https://github.com/yourusername/rmart-ecommerce-system.git
git push -u origin main
```

## Langkah 3: Verifikasi Upload

1. **Refresh halaman GitHub repository**
2. **Pastikan semua file sudah terupload**
3. **Check README.md** tampil dengan baik
4. **Verifikasi struktur folder** sesuai dengan project

## 🎯 Yang Sudah Disiapkan

✅ **Git Repository** sudah diinisialisasi  
✅ **Initial Commit** sudah dibuat dengan 181 files  
✅ **README.md** lengkap dengan dokumentasi  
✅ **.gitignore** untuk mengecualikan file yang tidak perlu  
✅ **Branch main** sudah disiapkan  
✅ **Nested git repositories** sudah dibersihkan  

## 📁 Struktur Project yang Akan Diupload

```
rmart-ecommerce-system/
├── README.md                    # Dokumentasi utama
├── .gitignore                   # File yang diabaikan git
├── Ecommerce/
│   ├── Backend/                 # Spring Boot API
│   ├── Frontend/                # React E-commerce
│   └── Database Scripts/        # SQL files
├── Dashboard_Admin/             # React Admin Dashboard
├── Documentation/               # Project docs
└── Test Files/                  # Testing scripts
```

## 🔧 Troubleshooting

### Jika ada error "remote origin already exists":
```bash
git remote remove origin
git remote add origin https://github.com/USERNAME/REPO_NAME.git
```

### Jika ada error authentication:
1. **Gunakan Personal Access Token** instead of password
2. **Generate token** di GitHub Settings > Developer settings > Personal access tokens
3. **Gunakan token** sebagai password saat push

### Jika file terlalu besar:
```bash
# Check file size
find . -size +100M -type f

# Remove large files if needed
git rm --cached path/to/large/file
```

## 🎉 Setelah Upload Berhasil

1. **Update README.md** dengan link repository yang benar
2. **Tambahkan topics/tags** di GitHub untuk visibility
3. **Setup GitHub Pages** jika ingin demo online
4. **Invite collaborators** jika ada tim
5. **Setup branch protection** untuk main branch

## 📝 Next Steps

- [ ] Upload ke GitHub ✅ (Ready to execute)
- [ ] Setup CI/CD dengan GitHub Actions
- [ ] Deploy backend ke cloud (Heroku/Railway)
- [ ] Deploy frontend ke Vercel/Netlify
- [ ] Setup database di cloud
- [ ] Add license file
- [ ] Create contribution guidelines

---

**Ready to upload!** 🚀 Jalankan perintah di atas untuk upload project ke GitHub.