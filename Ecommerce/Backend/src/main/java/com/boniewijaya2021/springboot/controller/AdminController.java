package com.boniewijaya2021.springboot.controller;

import com.boniewijaya2021.springboot.entity.*;
import com.boniewijaya2021.springboot.repository.*;
import com.boniewijaya2021.springboot.service.*;
import com.boniewijaya2021.springboot.utility.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE})
@Validated
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private BarangRepository barangRepository;
    
    @Autowired
    private JenisBarangRepository jenisBarangRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private AdminProductService adminProductService;

    @GetMapping("/products")
    public ResponseEntity<MessageModel> getAllProductsForAdmin() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<Barang> barangList = barangRepository.findAll();
            
            List<Map<String, Object>> mappedProducts = barangList.stream().map(barang -> {
                Map<String, Object> product = new HashMap<>();
                product.put("id", barang.getId());
                product.put("name", barang.getNamaBarang());
                product.put("price", barang.getHargaJual());
                product.put("image", barang.getGambar());
                product.put("stock", barang.getStok());
                product.put("categoryId", barang.getJenisId());
                product.put("rating", 4.5);
                product.put("discount", 0);
                return product;
            }).toList();
            
            result.put("totalPages", 1);
            result.put("currentPage", 0);
            result.put("products", mappedProducts);
            result.put("totalElements", mappedProducts.size());
            
            msg.setStatus(true);
            msg.setMessage("Products retrieved successfully");
            msg.setData(result);
            
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            logger.error("Failed to retrieve products", e);
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve products: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @GetMapping("/dashboard/stats")
    public ResponseEntity<MessageModel> getDashboardStats() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            long totalProducts = barangRepository.count();
            long totalUsers = customerRepository.count();
            long totalCategories = jenisBarangRepository.count();
            long lowStockProducts = barangRepository.findAll().stream().mapToLong(b -> b.getStok() < 10 ? 1 : 0).sum();

            result.put("totalProducts", totalProducts);
            result.put("totalUsers", totalUsers);
            result.put("totalOrders", 0);
            result.put("totalRevenue", 0);
            result.put("lowStockProducts", lowStockProducts);
            result.put("pendingOrders", 0);

            msg.setStatus(true);
            msg.setMessage("Dashboard stats retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            logger.error("Failed to retrieve dashboard stats", e);
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve dashboard stats");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @GetMapping("/categories")
    public ResponseEntity<MessageModel> getCategories() {
        MessageModel msg = new MessageModel();
        try {
            List<JenisBarang> categories = jenisBarangRepository.findAll();
            
            // Map categories to the expected format
            List<Map<String, Object>> mappedCategories = categories.stream().map(category -> {
                Map<String, Object> cat = new HashMap<>();
                cat.put("id", category.getId());
                cat.put("name", category.getNamaJenis());
                cat.put("image", category.getImage());
                cat.put("iconColor", category.getIconColor());
                return cat;
            }).toList();
            
            Map<String, Object> result = new HashMap<>();
            result.put("categories", mappedCategories);
            
            msg.setStatus(true);
            msg.setMessage("Categories retrieved successfully");
            msg.setData(result);
            return ResponseEntity.ok(msg);
        } catch (Exception e) {
            logger.error("Failed to get categories", e);
            msg.setStatus(false);
            msg.setMessage("Failed to get categories: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @PostMapping("/debug")
    public ResponseEntity<MessageModel> debugSystem(@RequestBody(required = false) Map<String, Object> data) {
        MessageModel msg = new MessageModel();
        Map<String, Object> debugInfo = new HashMap<>();
        
        try {
            // Test database connections
            debugInfo.put("barangRepository_available", barangRepository != null);
            debugInfo.put("jenisBarangRepository_available", jenisBarangRepository != null);
            
            // Test database queries
            long productCount = barangRepository.count();
            long categoryCount = jenisBarangRepository.count();
            debugInfo.put("existing_products", productCount);
            debugInfo.put("existing_categories", categoryCount);
            
            // Get categories
            List<JenisBarang> categories = jenisBarangRepository.findAll();
            debugInfo.put("categories", categories.stream().map(c -> {
                Map<String, Object> cat = new HashMap<>();
                cat.put("id", c.getId());
                cat.put("name", c.getNamaJenis());
                return cat;
            }).toList());
            
            // Test simple product creation
            try {
                Barang testProduct = new Barang();
                testProduct.setNamaBarang("DEBUG_TEST_" + System.currentTimeMillis());
                testProduct.setHargaJual(new BigDecimal("1000"));
                testProduct.setStok(1);
                testProduct.setGambar("debug.jpg");
                
                // Use first available category or default to 1
                Integer categoryId = categories.isEmpty() ? 1 : categories.get(0).getId().intValue();
                testProduct.setJenisId(categoryId);
                
                Barang saved = barangRepository.save(testProduct);
                debugInfo.put("test_product_created", true);
                debugInfo.put("test_product_id", saved.getId());
                
                // Clean up test product
                barangRepository.deleteById(saved.getId());
                debugInfo.put("test_product_deleted", true);
                
            } catch (Exception e) {
                debugInfo.put("test_product_error", e.getMessage());
                debugInfo.put("test_product_created", false);
                logger.error("Test product creation failed", e);
            }
            
            msg.setStatus(true);
            msg.setMessage("Debug completed");
            msg.setData(debugInfo);
            
            return ResponseEntity.ok(msg);
            
        } catch (Exception e) {
            logger.error("Debug failed", e);
            debugInfo.put("debug_error", e.getMessage());
            msg.setStatus(false);
            msg.setMessage("Debug failed: " + e.getMessage());
            msg.setData(debugInfo);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @PostMapping("/products")
    public ResponseEntity<MessageModel> createProduct(@RequestBody Map<String, Object> productData) {
        MessageModel msg = new MessageModel();

        try {
            logger.info("Creating product with data: {}", productData);
            
            if (productData.get("name") == null || productData.get("name").toString().trim().isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Product name is required");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            if (productData.get("price") == null) {
                msg.setStatus(false);
                msg.setMessage("Product price is required");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            if (productData.get("category") == null || productData.get("category").toString().trim().isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Product category is required");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }

            Barang barang = new Barang();
            
            // Validate and set product name (max 100 characters)
            String productName = productData.get("name").toString().trim();
            if (productName.length() > 100) {
                msg.setStatus(false);
                msg.setMessage("Product name is too long. Maximum 100 characters allowed.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            barang.setNamaBarang(productName);
            
            try {
                String priceStr = productData.get("price").toString();
                BigDecimal price = new BigDecimal(priceStr);
                barang.setHargaJual(price);
            } catch (NumberFormatException e) {
                msg.setStatus(false);
                msg.setMessage("Invalid price format. Please enter a valid number.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            try {
                int stock = productData.get("stock") != null ? 
                    Integer.parseInt(productData.get("stock").toString()) : 0;
                barang.setStok(stock);
            } catch (NumberFormatException e) {
                msg.setStatus(false);
                msg.setMessage("Invalid stock format. Please enter a valid number.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            String imageUrl = null;
            if (productData.get("images") != null && productData.get("images") instanceof java.util.List) {
                @SuppressWarnings("unchecked")
                java.util.List<String> images = (java.util.List<String>) productData.get("images");
                if (!images.isEmpty()) {
                    imageUrl = images.get(0);
                }
            } else if (productData.get("image") != null) {
                imageUrl = productData.get("image").toString();
            }
            
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Product image is required");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            // Set image URL
            String trimmedImageUrl = imageUrl.trim();
            
            barang.setGambar(trimmedImageUrl);
            
            String categoryName = productData.get("category").toString().trim();
            List<JenisBarang> categories = jenisBarangRepository.findAll();
            Integer categoryId = null;
            
            logger.info("Looking for category: '{}'", categoryName);
            logger.info("Available categories: {}", categories.stream().map(JenisBarang::getNamaJenis).toList());
            
            for (JenisBarang category : categories) {
                if (category.getNamaJenis().equalsIgnoreCase(categoryName)) {
                    categoryId = category.getId().intValue();
                    logger.info("Found category ID: {} for name: {}", categoryId, categoryName);
                    break;
                }
            }
            
            if (categoryId == null) {
                msg.setStatus(false);
                msg.setMessage("Category not found: '" + categoryName + "'. Available categories: " + 
                    categories.stream().map(JenisBarang::getNamaJenis).toList());
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
            }
            
            barang.setJenisId(categoryId);
            
            logger.info("Saving barang: name={}, price={}, stock={}, image={}, categoryId={}", 
                barang.getNamaBarang(), barang.getHargaJual(), barang.getStok(), 
                barang.getGambar(), barang.getJenisId());
            
            Barang savedBarang = barangRepository.save(barang);
            logger.info("Product created successfully with ID: {}", savedBarang.getId());
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("id", savedBarang.getId());
            responseData.put("name", savedBarang.getNamaBarang());
            responseData.put("price", savedBarang.getHargaJual());
            responseData.put("stock", savedBarang.getStok());
            responseData.put("image", savedBarang.getGambar());
            responseData.put("categoryId", savedBarang.getJenisId());
            
            msg.setStatus(true);
            msg.setMessage("Product added successfully! The product is now available on the ecommerce website.");
            msg.setData(responseData);

            return ResponseEntity.status(HttpStatus.CREATED).body(msg);

        } catch (NumberFormatException e) {
            logger.error("Invalid number format in product data", e);
            msg.setStatus(false);
            msg.setMessage("Invalid price or stock value. Please enter valid numbers.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg);
        } catch (Exception e) {
            logger.error("Failed to create product - Full error: ", e);
            logger.error("Stack trace: ", e);
            
            // Log more details
            logger.error("Product data that failed: {}", productData);
            
            msg.setStatus(false);
            msg.setMessage("Failed to add product: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @PutMapping("/products/{id}")
    public ResponseEntity<MessageModel> updateProduct(@PathVariable Long id, @RequestBody Barang barang) {
        MessageModel msg = new MessageModel();

        try {
            if (!barangRepository.existsById(id)) {
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            barang.setId(id);
            Barang updatedBarang = barangRepository.save(barang);
            
            msg.setStatus(true);
            msg.setMessage("Product updated successfully");
            msg.setData(updatedBarang);

            return ResponseEntity.ok(msg);
        } catch (Exception e) {
            logger.error("Failed to update product", e);
            msg.setStatus(false);
            msg.setMessage("Failed to update product: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @DeleteMapping("/products/{id}")
    public ResponseEntity<MessageModel> deleteProduct(@PathVariable Long id) {
        MessageModel msg = new MessageModel();

        try {
            if (!barangRepository.existsById(id)) {
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            barangRepository.deleteById(id);
            
            msg.setStatus(true);
            msg.setMessage("Product deleted successfully");

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            logger.error("Failed to delete product with ID: {}", id, e);
            msg.setStatus(false);
            msg.setMessage("Failed to delete product");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }
}