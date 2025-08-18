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
public class AdminProductService {

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;

    public ResponseEntity<MessageModel> getAllProductsForAdmin(int page, int size, Long categoryId, String search) {
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

            // Populate category names for admin view
            List<Product> products = productPage.getContent();
            populateCategoryNames(products);
            
            result.put("products", products);
            result.put("totalPages", productPage.getTotalPages());
            result.put("totalElements", productPage.getTotalElements());
            result.put("currentPage", page);

            msg.setStatus(true);
            msg.setMessage("Products retrieved successfully for admin");
            msg.setData(result);

            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve products: " + e.getMessage());
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