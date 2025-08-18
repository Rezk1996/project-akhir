package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.Category;
import com.boniewijaya2021.springboot.entity.Product;
import com.boniewijaya2021.springboot.repository.CategoryRepository;
import com.boniewijaya2021.springboot.repository.ProductRepository;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;

    public ResponseEntity<MessageModel> getAllProducts(int page, int size, Long categoryId, String search) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage;

            if (categoryId != null) {
                productPage = productRepository.findByCategoryId(categoryId, pageable);
            } else if (search != null && !search.isEmpty()) {
                productPage = productRepository.findByNameContainingIgnoreCase(search, pageable);
            } else {
                productPage = productRepository.findAll(pageable);
            }

            // Populate category names for products
            List<Product> products = productPage.getContent();
            populateCategoryNames(products);
            
            result.put("products", products);
            result.put("totalPages", productPage.getTotalPages());
            result.put("totalElements", productPage.getTotalElements());
            result.put("currentPage", page);

            msg.setStatus(true);
            msg.setMessage("Products retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve products: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getProductById(Long id) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            Optional<Product> productOpt = productRepository.findById(id);
            
            if (productOpt.isEmpty()) {
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }

            Product product = productOpt.get();
            populateCategoryName(product);
            result.put("product", product);
            msg.setStatus(true);
            msg.setMessage("Product retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve product: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getCategories() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<Category> categories = categoryRepository.findAll();
            result.put("categories", categories);
            
            msg.setStatus(true);
            msg.setMessage("Categories retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve categories: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getFeaturedProducts() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<Product> featuredProducts = productRepository.findFeaturedProducts();
            populateCategoryNames(featuredProducts);
            result.put("products", featuredProducts);
            
            msg.setStatus(true);
            msg.setMessage("Featured products retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve featured products: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    public ResponseEntity<MessageModel> getNewProducts() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<Product> newProducts = productRepository.findTop8ByOrderByCreatedAtDesc();
            populateCategoryNames(newProducts);
            result.put("products", newProducts);
            
            msg.setStatus(true);
            msg.setMessage("New products retrieved successfully");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve new products: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }
    
    private String getCategoryName(Long categoryId) {
        try {
            if (categoryId == null) return "Uncategorized";
            Optional<Category> category = categoryRepository.findById(categoryId);
            return category.map(Category::getName).orElse("Unknown");
        } catch (Exception e) {
            return "Unknown";
        }
    }
    
    private void populateCategoryName(Product product) {
        if (product != null) {
            product.setCategory(getCategoryName(product.getCategoryId()));
        }
    }
    
    private void populateCategoryNames(List<Product> products) {
        if (products != null) {
            products.forEach(this::populateCategoryName);
        }
    }
}