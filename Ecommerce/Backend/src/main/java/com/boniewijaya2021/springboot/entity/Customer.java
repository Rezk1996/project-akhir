package com.boniewijaya2021.springboot.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "customer")
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nama", length = 100)
    private String nama;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "is_member")
    private Boolean isMember;

    @Column(name = "poin")
    private Integer poin = 0;

    // Constructors
    public Customer() {}

    public Customer(String nama, String email, Boolean isMember, Integer poin) {
        this.nama = nama;
        this.email = email;
        this.isMember = isMember;
        this.poin = poin;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Boolean getIsMember() { return isMember; }
    public void setIsMember(Boolean isMember) { this.isMember = isMember; }

    public Integer getPoin() { return poin; }
    public void setPoin(Integer poin) { this.poin = poin; }
}