package com.boniewijaya2021.springboot.controller;

import com.boniewijaya2021.springboot.pojo.LoginPojo;
import com.boniewijaya2021.springboot.pojo.RegisterPojo;
import com.boniewijaya2021.springboot.service.AuthService;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<MessageModel> register(@RequestBody RegisterPojo registerPojo) {
        return authService.register(registerPojo);
    }

    @PostMapping("/login")
    public ResponseEntity<MessageModel> login(@RequestBody LoginPojo loginPojo) {
        return authService.login(loginPojo);
    }

    @PostMapping("/logout")
    public ResponseEntity<MessageModel> logout() {
        return authService.logout();
    }
    
    @PostMapping("/create-admin")
    public ResponseEntity<MessageModel> createAdmin() {
        return authService.createAdminUser();
    }
    
    @GetMapping("/check-email")
    public ResponseEntity<MessageModel> checkEmail(@RequestParam String email) {
        return authService.checkEmailAvailability(email);
    }
    
    @GetMapping("/cart")
    public ResponseEntity<MessageModel> getCart(@RequestHeader(value = "Authorization", required = false) String token) {
        MessageModel msg = new MessageModel();
        msg.setStatus(true);
        msg.setMessage("Cart endpoint working");
        msg.setData(java.util.Map.of("items", java.util.List.of(), "total", 0));
        return ResponseEntity.ok(msg);
    }
    
    @GetMapping("/orders")
    public ResponseEntity<MessageModel> getOrders(@RequestHeader(value = "Authorization", required = false) String token) {
        MessageModel msg = new MessageModel();
        msg.setStatus(true);
        msg.setMessage("Orders endpoint working");
        msg.setData(java.util.Map.of("orders", java.util.List.of()));
        return ResponseEntity.ok(msg);
    }
}