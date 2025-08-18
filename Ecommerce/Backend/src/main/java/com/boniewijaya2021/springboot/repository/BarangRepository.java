package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.Barang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BarangRepository extends JpaRepository<Barang, Long> {
    
    @Query("SELECT b FROM Barang b WHERE b.jenisId = ?1")
    List<Barang> findByJenisId(Integer jenisId);
    
    @Query("SELECT b FROM Barang b WHERE b.namaBarang LIKE %?1%")
    List<Barang> findByNamaBarangContaining(String nama);
    
    @Query("SELECT b FROM Barang b WHERE b.stok > 0")
    List<Barang> findAvailableItems();
}