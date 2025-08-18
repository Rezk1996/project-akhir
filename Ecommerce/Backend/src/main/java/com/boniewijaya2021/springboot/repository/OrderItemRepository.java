package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.Order;
import com.boniewijaya2021.springboot.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    List<OrderItem> findByOrder(Order order);
}