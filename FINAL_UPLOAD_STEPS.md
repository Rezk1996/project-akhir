# 🚀 Final Steps - Upload ke GitHub

## Repository Sudah Disiapkan ✅

- ✅ Repository: `project-akhir` sudah dibuat di akun rezk1996
- ✅ Remote origin sudah diset ke: https://github.com/rezk1996/project-akhir.git
- ✅ Project siap untuk diupload (181 files)

## Langkah Upload (Pilih salah satu):

### Option 1: Terminal dengan Personal Access Token

```bash
cd /Users/user/Documents/ProjectWeb
git push -u origin main
```

**Saat diminta:**
- Username: `rezk1996`
- Password: **Personal Access Token** (bukan password GitHub)

**Cara buat Personal Access Token:**
1. Buka: https://github.com/settings/tokens
2. "Generate new token" → "Generate new token (classic)"
3. Centang scope: `repo`
4. Copy token yang dihasilkan
5. Gunakan sebagai password

### Option 2: GitHub Desktop (Lebih Mudah)

1. **Download GitHub Desktop:** https://desktop.github.com/
2. **Login dengan akun rezk1996**
3. **File → Add Local Repository**
4. **Pilih folder:** `/Users/user/Documents/ProjectWeb`
5. **Publish repository** dengan nama `project-akhir`

### Option 3: VS Code Git Integration

1. **Buka VS Code**
2. **Open folder:** `/Users/user/Documents/ProjectWeb`
3. **Source Control panel** (Ctrl+Shift+G)
4. **Klik "Publish to GitHub"**
5. **Pilih repository:** `project-akhir`

## Setelah Upload Berhasil

Repository akan tersedia di:
**https://github.com/rezk1996/project-akhir**

## Troubleshooting

Jika masih ada masalah authentication, coba:
```bash
# Set credential helper
git config --global credential.helper store

# Atau gunakan SSH (jika sudah setup SSH key)
git remote set-url origin git@github.com:rezk1996/project-akhir.git
```

---

**Pilih cara yang paling mudah untuk Anda!** 🎯