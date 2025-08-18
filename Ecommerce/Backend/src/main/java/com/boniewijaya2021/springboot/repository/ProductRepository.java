package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    Page<Product> findByCategoryId(Long categoryId, Pageable pageable);
    
    Page<Product> findByNameContainingIgnoreCase(String name, Pageable pageable);
    
    List<Product> findTop8ByOrderByCreatedAtDesc();
    
    List<Product> findByDiscountGreaterThan(Integer discount);
    
    @Query("SELECT p FROM Product p WHERE p.rating >= 4.5 ORDER BY p.rating DESC")
    List<Product> findFeaturedProducts();
    
    long countByStockLessThan(Integer stock);
}