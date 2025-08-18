package com.boniewijaya2021.springboot.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "jenis_barang")
public class JenisBarang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nama_jenis", nullable = false, length = 50)
    private String namaJenis;

    @Column(name = "image")
    private String image;

    @Column(name = "icon_color")
    private String iconColor;

    @Column(name = "icon")
    private String icon;

    // Constructors
    public JenisBarang() {}

    public JenisBarang(String namaJenis) {
        this.namaJenis = namaJenis;
    }

    public JenisBarang(String namaJenis, String image, String iconColor) {
        this.namaJenis = namaJenis;
        this.image = image;
        this.iconColor = iconColor;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNamaJenis() { return namaJenis; }
    public void setNamaJenis(String namaJenis) { this.namaJenis = namaJenis; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getIconColor() { return iconColor; }
    public void setIconColor(String iconColor) { this.iconColor = iconColor; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
}