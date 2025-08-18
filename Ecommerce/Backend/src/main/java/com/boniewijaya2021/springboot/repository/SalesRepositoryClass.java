package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.TblSales;
import com.boniewijaya2021.springboot.pojo.PenjualanPojo;
import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

@Repository
public class SalesRepositoryClass {

    @PersistenceContext
    private EntityManager entityManager;

    public List<PenjualanPojo> getDataDinamic( String namaSales,String namaBarang
                                              )
    {
        StringBuilder qb = new StringBuilder();

        if(namaBarang !=null ){
            qb.append(" and nama_barang = :namaBarang \n");
        }
        if(namaSales !=null){
            qb.append("and sales_name = :namaSales \n");
        }

        String sisipan = qb.toString();

        //untuk sisipan yang ditengah

        String QueryText="SELECT cast (id_penjualan as varchar) id_penjualan, harga, nama_barang, sales_name\n" +
                "FROM sample.tbl_penjualan  WHERE 1=1 \n" +sisipan;

        Query query = entityManager.createNativeQuery(QueryText);
        if(namaBarang !=null){
            query.setParameter("namaBarang",namaBarang);
        }
        if(namaSales !=null ){
            query.setParameter("namaSales",namaSales);
        }



        List hasil= query.getResultList();
        List<PenjualanPojo> result = new ArrayList<>();

        Iterator itr = hasil.iterator();
        while(itr.hasNext()){
            PenjualanPojo browse = new PenjualanPojo();
            Object[] obj = (Object[]) itr.next();
            String idPenjualan= String.valueOf(obj[0]);
            Double harga = Double.valueOf((Double) obj[1]);
            String namaBarangs = String.valueOf(obj[2]);
            String salesName= String.valueOf(obj[3]);

            browse.setIdPenjualan(idPenjualan);
            browse.setHarga(harga);
            browse.setNamaBarang(namaBarangs);
            browse.setSalesName(salesName);
            result.add(browse);
        }
        return result;
    }


}
