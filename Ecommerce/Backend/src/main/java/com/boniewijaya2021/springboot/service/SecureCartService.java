package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.*;
import com.boniewijaya2021.springboot.repository.*;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class SecureCartService {

    private static final Logger logger = LoggerFactory.getLogger(SecureCartService.class);

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private JwtService jwtService;

    public ResponseEntity<MessageModel> getCart(String token) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = jwtService.extractUserId(token);
            if (userId == null) {
                logger.warn("Invalid token provided for cart access");
                msg.setStatus(false);
                msg.setMessage("Invalid authentication token");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            Optional<User> userOpt = userRepository.findById(userId);
            
            if (userOpt.isEmpty()) {
                logger.warn("User not found with ID: {}", userId);
                msg.setStatus(false);
                msg.setMessage("User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            User user = userOpt.get();
            Optional<Cart> cartOpt = cartRepository.findByUser(user);
            
            if (cartOpt.isEmpty()) {
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
                itemMap.put("productName", sanitizeOutput(item.getProduct().getName()));
                itemMap.put("price", item.getProduct().getPrice());
                itemMap.put("image", sanitizeOutput(item.getProduct().getImage()));
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
            
            logger.info("Cart retrieved successfully for user: {}", userId);
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            logger.error("Failed to retrieve cart", e);
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve cart");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> addToCart(String token, @NotNull @Positive Long productId, @NotNull @Positive Integer quantity) {
        MessageModel msg = new MessageModel();
        
        try {
            // Input validation
            if (quantity <= 0 || quantity > 100) {
                msg.setStatus(false);
                msg.setMessage("Invalid quantity. Must be between 1 and 100");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            Long userId = jwtService.extractUserId(token);
            if (userId == null) {
                logger.warn("Invalid token provided for add to cart");
                msg.setStatus(false);
                msg.setMessage("Invalid authentication token");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            Optional<User> userOpt = userRepository.findById(userId);
            Optional<Product> productOpt = productRepository.findById(productId);
            
            if (userOpt.isEmpty()) {
                logger.warn("User not found with ID: {}", userId);
                msg.setStatus(false);
                msg.setMessage("User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            if (productOpt.isEmpty()) {
                logger.warn("Product not found with ID: {}", productId);
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            User user = userOpt.get();
            Product product = productOpt.get();

            // Check stock availability
            if (product.getStock() < quantity) {
                msg.setStatus(false);
                msg.setMessage("Insufficient stock available");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            Cart cart = cartRepository.findByUser(user).orElse(new Cart(user));
            if (cart.getId() == null) {
                cart = cartRepository.save(cart);
            }

            Optional<CartItem> existingItem = cartItemRepository.findByCartAndProduct(cart, product);
            
            if (existingItem.isPresent()) {
                CartItem item = existingItem.get();
                int newQuantity = item.getQuantity() + quantity;
                
                if (newQuantity > product.getStock()) {
                    msg.setStatus(false);
                    msg.setMessage("Total quantity exceeds available stock");
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
                }
                
                item.setQuantity(newQuantity);
                item.setUpdatedAt(LocalDateTime.now());
                cartItemRepository.save(item);
            } else {
                CartItem newItem = new CartItem(cart, product, quantity);
                cartItemRepository.save(newItem);
            }

            msg.setStatus(true);
            msg.setMessage("Product added to cart successfully");
            
            logger.info("Product {} added to cart for user: {}", productId, userId);
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            logger.error("Failed to add product to cart", e);
            msg.setStatus(false);
            msg.setMessage("Failed to add product to cart");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> updateCartItem(String token, @NotNull Long itemId, @NotNull @Positive Integer quantity) {
        MessageModel msg = new MessageModel();
        
        try {
            if (quantity < 0 || quantity > 100) {
                msg.setStatus(false);
                msg.setMessage("Invalid quantity. Must be between 0 and 100");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            Long userId = jwtService.extractUserId(token);
            if (userId == null) {
                logger.warn("Invalid token provided for cart update");
                msg.setStatus(false);
                msg.setMessage("Invalid authentication token");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            Optional<CartItem> itemOpt = cartItemRepository.findById(itemId);
            
            if (itemOpt.isEmpty()) {
                logger.warn("Cart item not found with ID: {}", itemId);
                msg.setStatus(false);
                msg.setMessage("Cart item not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            CartItem item = itemOpt.get();
            
            if (!item.getCart().getUser().getId().equals(userId)) {
                logger.warn("Unauthorized cart access attempt by user: {}", userId);
                msg.setStatus(false);
                msg.setMessage("Unauthorized access");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(msg);
            }

            if (quantity == 0) {
                cartItemRepository.delete(item);
                msg.setMessage("Item removed from cart");
            } else {
                if (quantity > item.getProduct().getStock()) {
                    msg.setStatus(false);
                    msg.setMessage("Quantity exceeds available stock");
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
                }
                
                item.setQuantity(quantity);
                item.setUpdatedAt(LocalDateTime.now());
                cartItemRepository.save(item);
                msg.setMessage("Cart item updated successfully");
            }

            msg.setStatus(true);
            logger.info("Cart item {} updated for user: {}", itemId, userId);
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            logger.error("Failed to update cart item", e);
            msg.setStatus(false);
            msg.setMessage("Failed to update cart item");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> removeCartItem(String token, @NotNull Long itemId) {
        MessageModel msg = new MessageModel();
        
        try {
            Long userId = jwtService.extractUserId(token);
            if (userId == null) {
                logger.warn("Invalid token provided for cart item removal");
                msg.setStatus(false);
                msg.setMessage("Invalid authentication token");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            Optional<CartItem> itemOpt = cartItemRepository.findById(itemId);
            
            if (itemOpt.isEmpty()) {
                logger.warn("Cart item not found with ID: {}", itemId);
                msg.setStatus(false);
                msg.setMessage("Cart item not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            CartItem item = itemOpt.get();
            
            if (!item.getCart().getUser().getId().equals(userId)) {
                logger.warn("Unauthorized cart item removal attempt by user: {}", userId);
                msg.setStatus(false);
                msg.setMessage("Unauthorized access");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(msg);
            }

            cartItemRepository.delete(item);

            msg.setStatus(true);
            msg.setMessage("Item removed from cart successfully");
            
            logger.info("Cart item {} removed for user: {}", itemId, userId);
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            logger.error("Failed to remove cart item", e);
            msg.setStatus(false);
            msg.setMessage("Failed to remove cart item");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    private String sanitizeOutput(String input) {
        if (input == null) return null;
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }
}