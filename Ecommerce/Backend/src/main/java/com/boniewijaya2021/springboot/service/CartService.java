package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.*;
import com.boniewijaya2021.springboot.repository.*;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    public ResponseEntity<MessageModel> getCart(String token) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = extractUserIdFromToken(token);
            Optional<User> userOpt = userRepository.findById(userId);
            
            if (userOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            User user = userOpt.get();
            Optional<Cart> cartOpt = cartRepository.findByUser(user);
            
            if (cartOpt.isEmpty()) {
                // Create empty cart
                Cart newCart = new Cart(user);
                cartRepository.save(newCart);
                
                msg.setStatus(true);
                msg.setMessage("Cart retrieved successfully");
                msg.setData(Map.of("items", List.of(), "total", 0));
                return ResponseEntity.ok(msg);
            }

            Cart cart = cartOpt.get();
            List<CartItem> items = cartItemRepository.findByCart(cart);
            
            List<Map<String, Object>> cartItems = items.stream().map(item -> {
                Map<String, Object> itemMap = new HashMap<>();
                itemMap.put("id", item.getId());
                itemMap.put("productId", item.getProduct().getId());
                itemMap.put("productName", item.getProduct().getName());
                itemMap.put("price", item.getProduct().getPrice());
                itemMap.put("image", item.getProduct().getImage());
                itemMap.put("quantity", item.getQuantity());
                itemMap.put("subtotal", item.getProduct().getPrice().multiply(java.math.BigDecimal.valueOf(item.getQuantity())));
                return itemMap;
            }).collect(Collectors.toList());

            double total = items.stream()
                .mapToDouble(item -> item.getProduct().getPrice().doubleValue() * item.getQuantity())
                .sum();

            Map<String, Object> result = new HashMap<>();
            result.put("items", cartItems);
            result.put("total", total);
            result.put("itemCount", items.size());

            msg.setStatus(true);
            msg.setMessage("Cart retrieved successfully");
            msg.setData(result);
            
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve cart");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> addToCart(String token, Long productId, Integer quantity) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = extractUserIdFromToken(token);
            Optional<User> userOpt = userRepository.findById(userId);
            Optional<Product> productOpt = productRepository.findById(productId);
            
            if (userOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            if (productOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            User user = userOpt.get();
            Product product = productOpt.get();

            // Get or create cart
            Cart cart = cartRepository.findByUser(user).orElse(new Cart(user));
            if (cart.getId() == null) {
                cart = cartRepository.save(cart);
            }

            // Check if item already exists in cart
            Optional<CartItem> existingItem = cartItemRepository.findByCartAndProduct(cart, product);
            
            if (existingItem.isPresent()) {
                CartItem item = existingItem.get();
                item.setQuantity(item.getQuantity() + quantity);
                item.setUpdatedAt(LocalDateTime.now());
                cartItemRepository.save(item);
            } else {
                CartItem newItem = new CartItem(cart, product, quantity);
                cartItemRepository.save(newItem);
            }

            msg.setStatus(true);
            msg.setMessage("Product added to cart successfully");
            
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to add product to cart");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> updateCartItem(String token, Long itemId, Integer quantity) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = extractUserIdFromToken(token);
            Optional<CartItem> itemOpt = cartItemRepository.findById(itemId);
            
            if (itemOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Cart item not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            CartItem item = itemOpt.get();
            
            // Verify ownership
            if (!item.getCart().getUser().getId().equals(userId)) {
                msg.setStatus(false);
                msg.setMessage("Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            if (quantity <= 0) {
                cartItemRepository.delete(item);
                msg.setMessage("Item removed from cart");
            } else {
                item.setQuantity(quantity);
                item.setUpdatedAt(LocalDateTime.now());
                cartItemRepository.save(item);
                msg.setMessage("Cart item updated successfully");
            }

            msg.setStatus(true);
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to update cart item");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> removeCartItem(String token, Long itemId) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = extractUserIdFromToken(token);
            Optional<CartItem> itemOpt = cartItemRepository.findById(itemId);
            
            if (itemOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Cart item not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            CartItem item = itemOpt.get();
            
            // Verify ownership
            if (!item.getCart().getUser().getId().equals(userId)) {
                msg.setStatus(false);
                msg.setMessage("Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            cartItemRepository.delete(item);

            msg.setStatus(true);
            msg.setMessage("Item removed from cart successfully");
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to remove cart item");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    private Long extractUserIdFromToken(String token) {
        try {
            // Simple token extraction - in production use proper JWT parsing
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            if (token.startsWith("session_")) {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    return Long.parseLong(parts[1]);
                }
            }
            
            // Default to user ID 1 for testing if token format is invalid
            System.out.println("Invalid token format, using default user ID 1 for testing: " + token);
            return 1L;
        } catch (Exception e) {
            System.out.println("Error parsing token, using default user ID 1: " + e.getMessage());
            return 1L;
        }
    }
}