package com.boniewijaya2021.springboot.controller;

import com.boniewijaya2021.springboot.service.SecureCartService;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.validation.annotation.Validated;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

@RestController
@RequestMapping("/api/cart")
@CrossOrigin(origins = {"https://localhost:3000", "https://localhost:3001"}, allowCredentials = "true")
@Validated
public class CartController {

    private static final Logger logger = LoggerFactory.getLogger(CartController.class);

    @Autowired
    private SecureCartService cartService;

    @GetMapping
    public ResponseEntity<MessageModel> getCart(@RequestHeader("Authorization") String token) {
        logger.info("Cart retrieval request received");
        return cartService.getCart(token);
    }

    @PostMapping
    public ResponseEntity<MessageModel> addToCart(
            @RequestHeader("Authorization") String token,
            @RequestParam @NotNull @Positive Long productId,
            @RequestParam @NotNull @Positive Integer quantity) {
        logger.info("Add to cart request: productId={}, quantity={}", productId, quantity);
        return cartService.addToCart(token, productId, quantity);
    }

    @PutMapping("/{itemId}")
    public ResponseEntity<MessageModel> updateCartItem(
            @RequestHeader("Authorization") String token,
            @PathVariable @NotNull Long itemId,
            @RequestParam @NotNull Integer quantity) {
        logger.info("Update cart item request: itemId={}, quantity={}", itemId, quantity);
        return cartService.updateCartItem(token, itemId, quantity);
    }

    @DeleteMapping("/{itemId}")
    public ResponseEntity<MessageModel> removeCartItem(
            @RequestHeader("Authorization") String token,
            @PathVariable @NotNull Long itemId) {
        logger.info("Remove cart item request: itemId={}", itemId);
        return cartService.removeCartItem(token, itemId);
    }
}