-- Database Schema untuk DB_Rmart

-- Tabel 1: jenis_barang
CREATE TABLE jenis_barang (
    id SERIAL PRIMARY KEY,
    nama_jenis VARCHAR(50) NOT NULL
);

INSERT INTO jenis_barang (id, nama_jenis) VALUES 
(1, 'Minuman'), 
(2, 'Makanan'), 
(3, 'Perawatan'), 
(4, 'Kebutuhan Rumah Tangga');

-- Tabel 2: barang (dengan penambahan kolom gambar)
CREATE TABLE barang (
    id SERIAL PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    jenis_id INT,
    harga_jual DECIMAL(10,2),
    stok INT,
    gambar VARCHAR(255), -- Kolom baru untuk menyimpan path/nama file gambar
    FOREIGN KEY (jenis_id) REFERENCES jenis_barang(id)
);

INSERT INTO barang (id, nama_barang, jenis_id, harga_jual, stok, gambar) VALUES
(1, 'Aqua Botol 600ml', 1, 4000.00, 100, 'aqua_600ml.jpg'),
(2, 'Indomie Goreng', 2, 3000.00, 200, 'indomie_goreng.jpg'),
(3, 'Rinso 1kg', 4, 18000.00, 50, 'rinso_1kg.jpg'),
(4, 'Shampoo Lifebuoy', 3, 15000.00, 70, 'lifebuoy_shampoo.jpg');

-- Tabel 3: supplier
CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    nama_supplier VARCHAR(100),
    kontak VARCHAR(20)
);

INSERT INTO supplier (id, nama_supplier, kontak) VALUES 
(1, 'PT Sumber Sejahtera', '021-12345678');

-- Tabel 4: harga_beli
CREATE TABLE harga_beli (
    id SERIAL PRIMARY KEY,
    barang_id INT,
    supplier_id INT,
    harga DECIMAL(10,2),
    tanggal DATE,
    FOREIGN KEY (barang_id) REFERENCES barang(id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

INSERT INTO harga_beli (id, barang_id, supplier_id, harga, tanggal) VALUES
(1, 1, 1, 3000.00, '2025-05-01'),
(2, 2, 1, 2000.00, '2025-05-01');

-- Tabel 5: customer (dengan penambahan kolom poin)
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    email VARCHAR(100),
    is_member BOOLEAN,
    poin INT DEFAULT 0 -- Kolom baru untuk menyimpan jumlah poin
);

INSERT INTO customer (id, nama, email, is_member, poin) VALUES 
(1, 'Budi', 'budi@mail.com', TRUE, 120);

-- Tabel 6: transaksi (dengan penambahan kolom poin_digunakan)
CREATE TABLE transaksi (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    tanggal DATE,
    total_harga DECIMAL(10,2),
    poin_digunakan INT DEFAULT 0, -- Kolom baru untuk poin yang digunakan dalam transaksi
    poin_diperoleh INT DEFAULT 0, -- Kolom baru untuk poin yang diperoleh dari transaksi
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

INSERT INTO transaksi (id, customer_id, tanggal, total_harga, poin_digunakan, poin_diperoleh) VALUES 
(1, 1, '2025-05-21', 10000.00, 0, 10);

-- Tabel 7: detail_transaksi
CREATE TABLE detail_transaksi (
    id SERIAL PRIMARY KEY,
    transaksi_id INT,
    barang_id INT,
    jumlah INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (transaksi_id) REFERENCES transaksi(id),
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO detail_transaksi (id, transaksi_id, barang_id, jumlah, subtotal) VALUES
(1, 1, 1, 1, 4000.00),
(2, 1, 2, 2, 6000.00);

-- Tabel 8: point_member (tetap ada untuk mencatat riwayat poin, opsional jika ingin tetap digunakan)
CREATE TABLE point_member (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    total_point INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

INSERT INTO point_member (id, customer_id, total_point) VALUES 
(1, 1, 120);

-- Tabel 9: diskon
CREATE TABLE diskon (
    id SERIAL PRIMARY KEY,
    barang_id INT,
    persentase DECIMAL(5,2),
    tanggal_mulai DATE,
    tanggal_akhir DATE,
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO diskon (id, barang_id, persentase, tanggal_mulai, tanggal_akhir) VALUES 
(1, 2, 10.00, '2025-05-10', '2025-05-20');

-- Tabel 10: shift_kerja
CREATE TABLE shift_kerja (
    id SERIAL PRIMARY KEY,
    nama_shift VARCHAR(20),
    jam_mulai TIME,
    jam_selesai TIME
);

INSERT INTO shift_kerja (id, nama_shift, jam_mulai, jam_selesai) VALUES
(1, 'Pagi', '08:00:00', '16:00:00'),
(2, 'Malam', '16:00:00', '00:00:00');

-- Tabel 11: tenaga_kerja
CREATE TABLE tenaga_kerja (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    shift_id INT,
    FOREIGN KEY (shift_id) REFERENCES shift_kerja(id)
);

INSERT INTO tenaga_kerja (id, nama, shift_id) VALUES 
(1, 'Andi', 1);

-- Tabel 12: admin
CREATE TABLE admin (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO admin (id, nama, email) VALUES 
(1, 'Admin1', 'admin1@mail.com');

-- Tabel 13: stok_masuk
CREATE TABLE stok_masuk (
    id SERIAL PRIMARY KEY,
    barang_id INT,
    jumlah INT,
    tanggal DATE,
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO stok_masuk (id, barang_id, jumlah, tanggal) VALUES 
(1, 1, 50, '2025-05-05');

-- Tabel 14: stok_keluar
CREATE TABLE stok_keluar (
    id SERIAL PRIMARY KEY,
    barang_id INT,
    jumlah INT,
    tanggal DATE,
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO stok_keluar (id, barang_id, jumlah, tanggal) VALUES 
(1, 2, 20, '2025-05-06');

-- Tabel 15: keranjang
CREATE TABLE keranjang (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    barang_id INT,
    jumlah INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO keranjang (id, customer_id, barang_id, jumlah) VALUES 
(1, 1, 2, 3);

-- Tabel 16: target_penjualan
CREATE TABLE target_penjualan (
    id SERIAL PRIMARY KEY,
    barang_id INT,
    bulan INT,
    tahun INT,
    jumlah_target INT,
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

INSERT INTO target_penjualan (id, barang_id, bulan, tahun, jumlah_target) VALUES 
(1, 1, 5, 2025, 500);

-- Trigger untuk menambah poin setelah transaksi
CREATE OR REPLACE FUNCTION update_poin_customer()
RETURNS TRIGGER AS $$
BEGIN
    -- Tambah poin ke customer berdasarkan total_harga (misal: 1 poin per Rp1000)
    UPDATE customer
    SET poin = poin + NEW.poin_diperoleh
    WHERE id = NEW.customer_id;
    
    -- Kurangi poin jika poin digunakan dalam transaksi
    IF NEW.poin_digunakan > 0 THEN
        UPDATE customer
        SET poin = poin - NEW.poin_digunakan
        WHERE id = NEW.customer_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_poin
AFTER INSERT ON transaksi
FOR EACH ROW
EXECUTE FUNCTION update_poin_customer();