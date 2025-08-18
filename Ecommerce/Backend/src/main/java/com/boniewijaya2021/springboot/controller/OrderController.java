package com.boniewijaya2021.springboot.controller;

import com.boniewijaya2021.springboot.pojo.OrderPojo;
import com.boniewijaya2021.springboot.service.OrderService;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "http://localhost:3000")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    public ResponseEntity<MessageModel> createOrder(
            @RequestHeader("Authorization") String token,
            @RequestBody OrderPojo orderPojo) {
        return orderService.createOrder(token, orderPojo);
    }

    @GetMapping
    public ResponseEntity<MessageModel> getUserOrders(@RequestHeader("Authorization") String token) {
        return orderService.getUserOrders(token);
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<MessageModel> getOrderById(
            @RequestHeader("Authorization") String token,
            @PathVariable Long orderId) {
        return orderService.getOrderById(token, orderId);
    }
}