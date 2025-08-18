package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.User;
import com.boniewijaya2021.springboot.pojo.LoginPojo;
import com.boniewijaya2021.springboot.pojo.RegisterPojo;
import com.boniewijaya2021.springboot.repository.UserRepository;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

@Service
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private UserRepository userRepository;
    
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    private static final String EMAIL_PATTERN = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@" +
        "(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);

    public ResponseEntity<MessageModel> register(RegisterPojo registerPojo) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            logger.info("Registration attempt for user");
            
            // Validate input
            String validationError = validateRegistrationInput(registerPojo);
            if (validationError != null) {
                logger.warn("Registration validation failed");
                msg.setStatus(false);
                msg.setMessage(validationError);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            String normalizedEmail = registerPojo.getEmail().toLowerCase().trim();
            logger.debug("Checking email availability");
            
            // Check if email already exists
            if (userRepository.existsByEmail(normalizedEmail)) {
                logger.warn("Registration failed - email already exists");
                msg.setStatus(false);
                msg.setMessage("Email already registered");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            logger.info("Creating new user");
            
            // Create and save user
            User newUser = new User();
            newUser.setName(registerPojo.getName().trim());
            newUser.setEmail(normalizedEmail);
            newUser.setPassword(passwordEncoder.encode(registerPojo.getPassword()));
            newUser.setRole("customer");
            newUser.setCreatedAt(LocalDateTime.now());
            newUser.setUpdatedAt(LocalDateTime.now());
            
            User savedUser = userRepository.save(newUser);
            logger.info("User registered successfully with ID: {}", savedUser.getId());
            
            if (savedUser == null || savedUser.getId() == null) {
                logger.error("Failed to save user during registration");
                msg.setStatus(false);
                msg.setMessage("Registration failed. Please try again.");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
            }
            
            result.put("user", Map.of(
                "id", savedUser.getId(),
                "name", savedUser.getName(),
                "email", savedUser.getEmail(),
                "role", savedUser.getRole()
            ));
            
            msg.setStatus(true);
            msg.setMessage("Registration successful");
            msg.setData(result);
            
            logger.info("Registration completed successfully");
            return ResponseEntity.status(HttpStatus.CREATED).body(msg);

        } catch (Exception e) {
            logger.error("Registration failed", e);
            
            // Handle specific database constraint violations
            if (e.getMessage() != null && e.getMessage().contains("duplicate key")) {
                msg.setStatus(false);
                msg.setMessage("Email already registered");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            msg.setStatus(false);
            msg.setMessage("Registration failed. Please try again.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> login(LoginPojo loginPojo) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            // Validate input
            String validationError = validateLoginInput(loginPojo);
            if (validationError != null) {
                msg.setStatus(false);
                msg.setMessage(validationError);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            // Find user by email (case insensitive)
            Optional<User> userOpt = userRepository.findByEmail(loginPojo.getEmail().toLowerCase().trim());
            
            if (userOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Invalid email or password");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            User user = userOpt.get();
            
            // Verify password (support both BCrypt and plain text for testing)
            boolean passwordMatches = false;
            if (user.getPassword().startsWith("$2a$")) {
                // BCrypt hashed password
                passwordMatches = passwordEncoder.matches(loginPojo.getPassword(), user.getPassword());
            } else {
                // Plain text password (for testing only)
                passwordMatches = user.getPassword().equals(loginPojo.getPassword());
            }
            
            if (!passwordMatches) {
                msg.setStatus(false);
                msg.setMessage("Invalid email or password");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(msg);
            }

            // Login successful - no need to update user for now

            // Generate session token (in production, use JWT)
            String sessionToken = generateSessionToken(user.getId());

            result.put("user", Map.of(
                "id", user.getId(),
                "name", user.getName(),
                "email", user.getEmail(),
                "role", user.getRole(),
                "avatar", user.getAvatar() != null ? user.getAvatar() : "",
                "phone", user.getPhone() != null ? user.getPhone() : ""
            ));
            result.put("token", sessionToken);
            result.put("expiresIn", 86400); // 24 hours in seconds

            msg.setStatus(true);
            msg.setMessage("Login successful");
            msg.setData(result);
            
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            logger.error("Login failed", e);
            msg.setStatus(false);
            msg.setMessage("Login failed. Please try again.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> logout() {
        MessageModel msg = new MessageModel();
        msg.setStatus(true);
        msg.setMessage("Logout successful");
        return ResponseEntity.status(HttpStatus.OK).body(msg);
    }
    
    public ResponseEntity<MessageModel> createAdminUser() {
        MessageModel msg = new MessageModel();
        
        try {
            // Check if admin already exists
            if (userRepository.existsByEmail("admin@rmart.com")) {
                msg.setStatus(false);
                msg.setMessage("Admin user already exists");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            // Create admin user
            User adminUser = new User();
            adminUser.setName("Admin User");
            adminUser.setEmail("admin@rmart.com");
            adminUser.setPassword(passwordEncoder.encode("admin123"));
            adminUser.setRole("admin");
            adminUser.setCreatedAt(LocalDateTime.now());
            adminUser.setUpdatedAt(LocalDateTime.now());
            
            User savedUser = userRepository.save(adminUser);
            
            msg.setStatus(true);
            msg.setMessage("Admin user created successfully");
            msg.setData(Map.of(
                "id", savedUser.getId(),
                "name", savedUser.getName(),
                "email", savedUser.getEmail(),
                "role", savedUser.getRole()
            ));
            
            return ResponseEntity.status(HttpStatus.CREATED).body(msg);
            
        } catch (Exception e) {
            logger.error("Failed to create admin user", e);
            msg.setStatus(false);
            msg.setMessage("Failed to create admin user");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }
    
    private String validateRegistrationInput(RegisterPojo registerPojo) {
        if (registerPojo.getName() == null || registerPojo.getName().trim().isEmpty()) {
            return "Name is required";
        }
        if (registerPojo.getName().trim().length() < 2) {
            return "Name must be at least 2 characters long";
        }
        if (registerPojo.getEmail() == null || registerPojo.getEmail().trim().isEmpty()) {
            return "Email is required";
        }
        if (!pattern.matcher(registerPojo.getEmail().trim()).matches()) {
            return "Please enter a valid email address";
        }
        if (registerPojo.getPassword() == null || registerPojo.getPassword().isEmpty()) {
            return "Password is required";
        }
        if (registerPojo.getPassword().length() < 6) {
            return "Password must be at least 6 characters long";
        }
        return null;
    }
    
    private String validateLoginInput(LoginPojo loginPojo) {
        if (loginPojo.getEmail() == null || loginPojo.getEmail().trim().isEmpty()) {
            return "Email is required";
        }
        if (!pattern.matcher(loginPojo.getEmail().trim()).matches()) {
            return "Please enter a valid email address";
        }
        if (loginPojo.getPassword() == null || loginPojo.getPassword().isEmpty()) {
            return "Password is required";
        }
        return null;
    }
    
    public ResponseEntity<MessageModel> checkEmailAvailability(String email) {
        MessageModel msg = new MessageModel();
        
        try {
            if (email == null || email.trim().isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Email is required");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            String normalizedEmail = email.toLowerCase().trim();
            boolean exists = userRepository.existsByEmail(normalizedEmail);
            
            if (exists) {
                msg.setStatus(false);
                msg.setMessage("Email already registered");
            } else {
                msg.setStatus(true);
                msg.setMessage("Email available");
            }
            
            return ResponseEntity.status(HttpStatus.OK).body(msg);
            
        } catch (Exception e) {
            logger.error("Error checking email availability", e);
            msg.setStatus(false);
            msg.setMessage("Error checking email availability");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }
    
    private String generateSessionToken(Long userId) {
        // In production, use proper JWT token generation
        return "session_" + userId + "_" + System.currentTimeMillis();
    }
}