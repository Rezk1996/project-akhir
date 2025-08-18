package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.Cart;
import com.boniewijaya2021.springboot.entity.CartItem;
import com.boniewijaya2021.springboot.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCart(Cart cart);
    Optional<CartItem> findByCartAndProduct(Cart cart, Product product);
    void deleteByCart(Cart cart);
}