package com.boniewijaya2021.springboot.controller;

import com.boniewijaya2021.springboot.entity.Barang;
import com.boniewijaya2021.springboot.entity.JenisBarang;
import com.boniewijaya2021.springboot.repository.BarangRepository;
import com.boniewijaya2021.springboot.repository.JenisBarangRepository;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE})
public class BarangController {

    @Autowired
    private BarangRepository barangRepository;
    
    @Autowired
    private JenisBarangRepository jenisBarangRepository;

    @GetMapping("/products")
    public ResponseEntity<MessageModel> getAllBarang(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String search) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<Barang> barangList = barangRepository.findAll();
            
            // Filter by category if provided
            if (category != null && !category.trim().isEmpty()) {
                // Find category ID by name
                List<JenisBarang> categories = jenisBarangRepository.findAll();
                Integer categoryId = null;
                for (JenisBarang jenis : categories) {
                    if (jenis.getNamaJenis().equalsIgnoreCase(category.trim())) {
                        categoryId = jenis.getId().intValue();
                        break;
                    }
                }
                
                if (categoryId != null) {
                    final Integer finalCategoryId = categoryId;
                    barangList = barangList.stream()
                        .filter(barang -> barang.getJenisId().equals(finalCategoryId))
                        .toList();
                }
            }
            
            // Filter by search term if provided
            if (search != null && !search.trim().isEmpty()) {
                String searchTerm = search.trim().toLowerCase();
                barangList = barangList.stream()
                    .filter(barang -> {
                        // Search in product name
                        boolean nameMatch = barang.getNamaBarang().toLowerCase().contains(searchTerm);
                        
                        // Search in category name
                        boolean categoryMatch = false;
                        try {
                            List<JenisBarang> categories = jenisBarangRepository.findAll();
                            for (JenisBarang jenis : categories) {
                                if (jenis.getId().intValue() == barang.getJenisId() && 
                                    jenis.getNamaJenis().toLowerCase().contains(searchTerm)) {
                                    categoryMatch = true;
                                    break;
                                }
                            }
                        } catch (Exception e) {
                            // Ignore category search error
                        }
                        
                        return nameMatch || categoryMatch;
                    })
                    .toList();
            }
            
            // Map PostgreSQL fields to frontend expected fields
            List<Map<String, Object>> mappedProducts = barangList.stream().map(barang -> {
                Map<String, Object> product = new HashMap<>();
                product.put("id", barang.getId());
                product.put("name", barang.getNamaBarang());
                product.put("price", barang.getHargaJual());
                product.put("image", barang.getGambar());
                product.put("stock", barang.getStok());
                product.put("categoryId", barang.getJenisId());
                
                // Add category name
                try {
                    List<JenisBarang> categories = jenisBarangRepository.findAll();
                    for (JenisBarang jenis : categories) {
                        if (jenis.getId().intValue() == barang.getJenisId()) {
                            product.put("category", jenis.getNamaJenis());
                            break;
                        }
                    }
                } catch (Exception e) {
                    product.put("category", "Unknown");
                }
                
                product.put("rating", 4.5); // Default rating
                product.put("discount", 0); // Default discount
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
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve products: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @GetMapping("/products/{id}")
    public ResponseEntity<MessageModel> getBarangById(@PathVariable Long id) {
        MessageModel msg = new MessageModel();

        try {
            Barang barang = barangRepository.findById(id).orElse(null);
            
            if (barang == null) {
                msg.setStatus(false);
                msg.setMessage("Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }
            
            // Map PostgreSQL fields to frontend expected fields
            Map<String, Object> product = new HashMap<>();
            product.put("id", barang.getId());
            product.put("name", barang.getNamaBarang());
            product.put("price", barang.getHargaJual());
            product.put("image", barang.getGambar());
            product.put("stock", barang.getStok());
            product.put("categoryId", barang.getJenisId());
            product.put("rating", 4.5);
            product.put("discount", 0);
            
            msg.setStatus(true);
            msg.setMessage("Product retrieved successfully");
            msg.setData(product);
            
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve product: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

    @GetMapping("/categories")
    public ResponseEntity<MessageModel> getAllCategories() {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            List<JenisBarang> jenisBarangList = jenisBarangRepository.findAll();
            
            // Map PostgreSQL fields to frontend expected fields
            List<Map<String, Object>> mappedCategories = jenisBarangList.stream().map(jenis -> {
                Map<String, Object> category = new HashMap<>();
                category.put("id", jenis.getId());
                category.put("name", jenis.getNamaJenis());
                category.put("image", jenis.getImage() != null ? jenis.getImage() : "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400");
                category.put("iconColor", jenis.getIconColor() != null ? jenis.getIconColor() : "#007AFF");
                category.put("icon", jenis.getIcon() != null ? jenis.getIcon() : "📦");
                category.put("link", "/products?category=" + jenis.getNamaJenis());
                return category;
            }).toList();
            
            result.put("categories", mappedCategories);
            
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

    @GetMapping("/products/categories")
    public ResponseEntity<MessageModel> getProductCategories() {
        return getAllCategories();
    }

    @GetMapping("/products/category/{categoryName}")
    public ResponseEntity<MessageModel> getProductsByCategory(@PathVariable String categoryName) {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try {
            // Find category ID by name
            List<JenisBarang> categories = jenisBarangRepository.findAll();
            Integer categoryId = null;
            for (JenisBarang jenis : categories) {
                if (jenis.getNamaJenis().equalsIgnoreCase(categoryName)) {
                    categoryId = jenis.getId().intValue();
                    break;
                }
            }
            
            if (categoryId == null) {
                msg.setStatus(false);
                msg.setMessage("Category not found: " + categoryName);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
            }
            
            // Get products by category
            List<Barang> barangList = barangRepository.findAll();
            final Integer finalCategoryId = categoryId;
            barangList = barangList.stream()
                .filter(barang -> barang.getJenisId().equals(finalCategoryId))
                .toList();
            
            // Map PostgreSQL fields to frontend expected fields
            List<Map<String, Object>> mappedProducts = barangList.stream().map(barang -> {
                Map<String, Object> product = new HashMap<>();
                product.put("id", barang.getId());
                product.put("name", barang.getNamaBarang());
                product.put("price", barang.getHargaJual());
                product.put("image", barang.getGambar());
                product.put("stock", barang.getStok());
                product.put("categoryId", barang.getJenisId());
                product.put("category", categoryName);
                product.put("rating", 4.5);
                product.put("discount", 0);
                return product;
            }).toList();
            
            result.put("totalPages", 1);
            result.put("currentPage", 0);
            result.put("products", mappedProducts);
            result.put("totalElements", mappedProducts.size());
            result.put("category", categoryName);
            
            msg.setStatus(true);
            msg.setMessage("Products for category '" + categoryName + "' retrieved successfully");
            msg.setData(result);
            
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        } catch (Exception e) {
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage("Failed to retrieve products for category: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg);
        }
    }

}