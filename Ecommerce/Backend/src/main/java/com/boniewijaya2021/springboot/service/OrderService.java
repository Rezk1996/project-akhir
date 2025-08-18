package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.*;
import com.boniewijaya2021.springboot.pojo.OrderPojo;
import com.boniewijaya2021.springboot.repository.*;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Transactional
    public ResponseEntity<MessageModel> createOrder(String token, OrderPojo orderPojo) {
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
                msg.setStatus(false);
                msg.setMessage("Cart is empty");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            Cart cart = cartOpt.get();
            List<CartItem> cartItems = cartItemRepository.findByCart(cart);
            
            if (cartItems.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Cart is empty");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            // Calculate total
            BigDecimal subtotal = cartItems.stream()
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal shippingCost = orderPojo.getShippingCost() != null 
                ? BigDecimal.valueOf(orderPojo.getShippingCost()) 
                : BigDecimal.ZERO;

            BigDecimal totalAmount = subtotal.add(shippingCost);

            // Create order
            Order order = new Order();
            order.setUser(user);
            order.setTotalAmount(totalAmount);
            order.setShippingCost(shippingCost);
            order.setShippingAddress(orderPojo.getShippingAddress());
            order.setPhoneNumber(orderPojo.getPhoneNumber());
            order.setNotes(orderPojo.getNotes());
            order.setPaymentMethod(orderPojo.getPaymentMethod());
            order.setStatus("pending");
            order.setPaymentStatus("pending");

            Order savedOrder = orderRepository.save(order);

            // Create order items
            for (CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem(
                    savedOrder,
                    cartItem.getProduct(),
                    cartItem.getQuantity(),
                    cartItem.getProduct().getPrice()
                );
                orderItemRepository.save(orderItem);
            }

            // Clear cart
            cartItemRepository.deleteByCart(cart);

            Map<String, Object> result = new HashMap<>();
            result.put("orderId", savedOrder.getId());
            result.put("totalAmount", totalAmount);
            result.put("status", savedOrder.getStatus());

            msg.setStatus(true);
            msg.setMessage("Order created successfully");
            msg.setData(result);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to create order");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getUserOrders(String token) {
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
            List<Order> orders = orderRepository.findByUserOrderByCreatedAtDesc(user);
            
            List<Map<String, Object>> orderList = orders.stream().map(order -> {
                Map<String, Object> orderMap = new HashMap<>();
                orderMap.put("id", order.getId());
                orderMap.put("totalAmount", order.getTotalAmount());
                orderMap.put("status", order.getStatus());
                orderMap.put("paymentStatus", order.getPaymentStatus());
                orderMap.put("paymentMethod", order.getPaymentMethod());
                orderMap.put("createdAt", order.getCreatedAt());
                orderMap.put("shippingAddress", order.getShippingAddress());
                
                // Get order items
                List<OrderItem> items = orderItemRepository.findByOrder(order);
                List<Map<String, Object>> itemList = items.stream().map(item -> {
                    Map<String, Object> itemMap = new HashMap<>();
                    itemMap.put("productName", item.getProduct().getName());
                    itemMap.put("quantity", item.getQuantity());
                    itemMap.put("price", item.getPrice());
                    itemMap.put("subtotal", item.getSubtotal());
                    return itemMap;
                }).collect(Collectors.toList());
                
                orderMap.put("items", itemList);
                return orderMap;
            }).collect(Collectors.toList());

            msg.setStatus(true);
            msg.setMessage("Orders retrieved successfully");
            msg.setData(Map.of("orders", orderList));
            
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve orders");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getOrderById(String token, Long orderId) {
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
            Optional<Order> orderOpt = orderRepository.findByIdAndUser(orderId, user);
            
            if (orderOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Order not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            Order order = orderOpt.get();
            List<OrderItem> items = orderItemRepository.findByOrder(order);
            
            Map<String, Object> orderMap = new HashMap<>();
            orderMap.put("id", order.getId());
            orderMap.put("totalAmount", order.getTotalAmount());
            orderMap.put("shippingCost", order.getShippingCost());
            orderMap.put("status", order.getStatus());
            orderMap.put("paymentStatus", order.getPaymentStatus());
            orderMap.put("paymentMethod", order.getPaymentMethod());
            orderMap.put("shippingAddress", order.getShippingAddress());
            orderMap.put("phoneNumber", order.getPhoneNumber());
            orderMap.put("notes", order.getNotes());
            orderMap.put("createdAt", order.getCreatedAt());
            
            List<Map<String, Object>> itemList = items.stream().map(item -> {
                Map<String, Object> itemMap = new HashMap<>();
                itemMap.put("productId", item.getProduct().getId());
                itemMap.put("productName", item.getProduct().getName());
                itemMap.put("productImage", item.getProduct().getImage());
                itemMap.put("quantity", item.getQuantity());
                itemMap.put("price", item.getPrice());
                itemMap.put("subtotal", item.getSubtotal());
                return itemMap;
            }).collect(Collectors.toList());
            
            orderMap.put("items", itemList);

            msg.setStatus(true);
            msg.setMessage("Order retrieved successfully");
            msg.setData(orderMap);
            
            return ResponseEntity.ok(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve order");
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