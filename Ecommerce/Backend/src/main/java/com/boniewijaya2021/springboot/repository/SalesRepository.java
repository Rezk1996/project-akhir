package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.TblSales;
import com.boniewijaya2021.springboot.pojo.PenjualanPojo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface SalesRepository extends JpaRepository<TblSales, UUID> {
    @Query(value = "SELECT cast (id_penjualan as varchar) id_penjualan, harga, nama_barang, sales_name\n" +
            "FROM sample.tbl_penjualan where id_penjualan =:idSales", nativeQuery = true)
    TblSales getPenjualanByid(@Param("idSales") UUID idSales);



}
