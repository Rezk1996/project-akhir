package com.boniewijaya2021.springboot.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "barang")
public class Barang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nama_barang", nullable = false)
    private String namaBarang;

    @Column(name = "jenis_id")
    private Integer jenisId;

    @Column(name = "harga_jual", precision = 10, scale = 2)
    private BigDecimal hargaJual;

    @Column(name = "stok")
    private Integer stok;

    @Column(name = "gambar", length = 500)
    private String gambar;

    // Removed jenisBarang relationship to avoid circular reference

    // Constructors
    public Barang() {}

    public Barang(String namaBarang, Integer jenisId, BigDecimal hargaJual, Integer stok, String gambar) {
        this.namaBarang = namaBarang;
        this.jenisId = jenisId;
        this.hargaJual = hargaJual;
        this.stok = stok;
        this.gambar = gambar;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNamaBarang() { return namaBarang; }
    public void setNamaBarang(String namaBarang) { this.namaBarang = namaBarang; }

    public Integer getJenisId() { return jenisId; }
    public void setJenisId(Integer jenisId) { this.jenisId = jenisId; }

    public BigDecimal getHargaJual() { return hargaJual; }
    public void setHargaJual(BigDecimal hargaJual) { this.hargaJual = hargaJual; }

    public Integer getStok() { return stok; }
    public void setStok(Integer stok) { this.stok = stok; }

    public String getGambar() { return gambar; }
    public void setGambar(String gambar) { this.gambar = gambar; }


}