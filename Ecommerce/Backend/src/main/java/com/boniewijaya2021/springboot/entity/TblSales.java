package com.boniewijaya2021.springboot.entity;

import org.hibernate.annotations.GenericGenerator;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.UUID;

@Entity
@Table(name = "tbl_penjualan")
public class TblSales implements Serializable {

    @Id
    @GenericGenerator(name = "uuid2", strategy = "uuid2")
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "uuid2")
    @Column(name = "id_penjualan", nullable = false)
    private UUID idPenjualan;

    @Column(name = "nama_barang", nullable = false)
    private String namaBarang;

    @Column(name ="harga", nullable = false)
    private Double harga;

    @Column(name = "sales_name", nullable = false)
    private String salesName;

    public TblSales() {}

    public TblSales(UUID idPenjualan, String namaBarang, Double harga, String salesName) {
        this.idPenjualan = idPenjualan;
        this.namaBarang = namaBarang;
        this.harga = harga;
        this.salesName = salesName;
    }

    public UUID getIdPenjualan() {
        return idPenjualan;
    }

    public void setIdPenjualan(UUID idPenjualan) {
        this.idPenjualan = idPenjualan;
    }

    public String getNamaBarang() {
        return namaBarang;
    }

    public void setNamaBarang(String namaBarang) {
        this.namaBarang = namaBarang;
    }

    public Double getHarga() {
        return harga;
    }

    public void setHarga(Double harga) {
        this.harga = harga;
    }

    public String getSalesName() {
        return salesName;
    }

    public void setSalesName(String salesName) {
        this.salesName = salesName;
    }
}
