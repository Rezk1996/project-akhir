package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.JenisBarang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JenisBarangRepository extends JpaRepository<JenisBarang, Long> {
}