import React, { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  Chip,
} from '@mui/material';
import { Add, Edit, Delete, Visibility } from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { productService, categoryService } from '../services/api';
import { Product, Category } from '../types';
import ImageUpload from '../components/ImageUpload';

const ProductsPage: React.FC = () => {
  const navigate = useNavigate();
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [open, setOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    price: '',
    originalPrice: '',
    discount: '',
    image: '',
    description: '',
    stock: '',
    categoryId: '',
  });
  const [productImages, setProductImages] = useState<string[]>([]);

  useEffect(() => {
    loadProducts();
    loadCategories();
  }, []);

  const loadProducts = async () => {
    try {
      const response = await productService.getProducts();
      if (response.status) {
        setProducts(response.data.products || []);
      }
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

  const loadCategories = async () => {
    try {
      const response = await categoryService.getCategories();
      console.log('Categories response:', response);
      if (response.status) {
        setCategories(response.data.categories || []);
      } else {
        // Fallback categories if API fails
        setCategories([
          { id: 6, name: 'Kebutuhan Dapur', description: 'Category: Kebutuhan Dapur', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 7, name: 'Kebutuhan Ibu & Anak', description: 'Category: Kebutuhan Ibu & Anak', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 8, name: 'Kebutuhan Rumah', description: 'Category: Kebutuhan Rumah', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 9, name: 'Makanan', description: 'Category: Makanan', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 10, name: 'Minuman', description: 'Category: Minuman', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 11, name: 'Produk Segar & Beku', description: 'Category: Produk Segar & Beku', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 12, name: 'Personal Care', description: 'Category: Personal Care', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 13, name: 'Kebutuhan Kesehatan', description: 'Category: Kebutuhan Kesehatan', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 14, name: 'Lifestyle', description: 'Category: Lifestyle', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
          { id: 15, name: 'Pet Foods', description: 'Category: Pet Foods', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' }
        ]);
      }
    } catch (error) {
      console.error('Error loading categories:', error);
      // Fallback categories if API fails
      setCategories([
        { id: 6, name: 'Kebutuhan Dapur', description: 'Category: Kebutuhan Dapur', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 7, name: 'Kebutuhan Ibu & Anak', description: 'Category: Kebutuhan Ibu & Anak', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 8, name: 'Kebutuhan Rumah', description: 'Category: Kebutuhan Rumah', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 9, name: 'Makanan', description: 'Category: Makanan', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 10, name: 'Minuman', description: 'Category: Minuman', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 11, name: 'Produk Segar & Beku', description: 'Category: Produk Segar & Beku', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 12, name: 'Personal Care', description: 'Category: Personal Care', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 13, name: 'Kebutuhan Kesehatan', description: 'Category: Kebutuhan Kesehatan', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 14, name: 'Lifestyle', description: 'Category: Lifestyle', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' },
        { id: 15, name: 'Pet Foods', description: 'Category: Pet Foods', productCount: 0, image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', iconColor: '#007AFF' }
      ]);
    }
  };

  const handleOpen = (product?: Product) => {
    if (product) {
      setEditingProduct(product);
      setFormData({
        name: product.name || '',
        price: product.price ? product.price.toString() : '',
        originalPrice: product.originalPrice?.toString() || '',
        discount: product.discount?.toString() || '',
        image: product.image || '',
        description: product.description || '',
        stock: product.stock ? product.stock.toString() : '',
        categoryId: product.categoryId ? product.categoryId.toString() : '',
      });
      setProductImages(product.image ? [product.image] : []);
    } else {
      setEditingProduct(null);
      setFormData({
        name: '',
        price: '',
        originalPrice: '',
        discount: '',
        image: '',
        description: '',
        stock: '',
        categoryId: '',
      });
      setProductImages([]);
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditingProduct(null);
    setProductImages([]);
  };

  const handleSubmit = async () => {
    try {
      // Validasi form
      if (!formData.name || !formData.price || !formData.categoryId) {
        alert('Please fill in all required fields (Name, Price, Category)');
        return;
      }

      if (productImages.length === 0) {
        alert('Please add at least one product image');
        return;
      }

      const productData = {
        name: formData.name,
        price: parseFloat(formData.price),
        originalPrice: formData.originalPrice ? parseFloat(formData.originalPrice) : null,
        discount: formData.discount ? parseInt(formData.discount) : 0,
        image: productImages[0], // Gambar utama
        images: productImages, // Semua gambar
        description: formData.description || '',
        stock: parseInt(formData.stock) || 0,
        categoryId: parseInt(formData.categoryId),
        rating: 0.0,
        sold: 0
      };

      console.log('Sending product data:', productData);

      let response;
      if (editingProduct) {
        response = await productService.updateProduct(editingProduct.id, productData);
      } else {
        response = await productService.createProduct(productData);
      }

      console.log('Server response:', response);

      if (response.status) {
        alert(response.message || 'Product saved successfully!');
        loadProducts();
        handleClose();
      } else {
        alert('Error: ' + (response.message || 'Failed to save product'));
      }
    } catch (error: any) {
      console.error('Error saving product:', error);
      console.error('Error response:', error.response);
      
      let errorMessage = 'Error saving product. Please try again.';
      if (error.response?.data?.message) {
        errorMessage = error.response.data.message;
      } else if (error.response?.status === 404) {
        errorMessage = 'API endpoint not found. Please check if backend is running.';
      } else if (error.response?.status === 500) {
        errorMessage = 'Server error. Please check backend logs.';
      } else if (error.message) {
        errorMessage = error.message;
      }
      
      alert(errorMessage);
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this product? This will also remove it from the ecommerce website.')) {
      try {
        console.log('Attempting to delete product with ID:', id);
        const response = await productService.deleteProduct(id);
        console.log('Delete response:', response);
        
        if (response.status) {
          alert('Product deleted successfully! It has been removed from the ecommerce website.');
          loadProducts();
        } else {
          console.error('Delete failed:', response);
          alert('Failed to delete product: ' + (response.message || 'Unknown error'));
        }
      } catch (error: any) {
        console.error('Error deleting product:', error);
        console.error('Error response:', error.response);
        
        let errorMessage = 'Please try again.';
        if (error.response?.data?.message) {
          errorMessage = error.response.data.message;
        } else if (error.response?.status === 404) {
          errorMessage = 'Product not found';
        } else if (error.response?.status === 500) {
          errorMessage = 'Server error - check if product has related data';
        } else if (error.message) {
          errorMessage = error.message;
        }
        
        alert('Error deleting product: ' + errorMessage);
      }
    }
  };

  const getStockStatus = (stock: number | null | undefined) => {
    const stockValue = stock || 0;
    if (stockValue === 0) return { label: 'Out of Stock', color: 'error' as const };
    if (stockValue < 10) return { label: 'Low Stock', color: 'warning' as const };
    return { label: 'In Stock', color: 'success' as const };
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Products Management</Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => navigate('/products/add')}
          sx={{ 
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white',
            fontWeight: 600,
            px: 3,
            py: 1.5,
            borderRadius: 2,
            boxShadow: '0 4px 15px rgba(102, 126, 234, 0.4)',
            '&:hover': { 
              background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)',
              transform: 'translateY(-2px)',
              boxShadow: '0 6px 20px rgba(102, 126, 234, 0.6)'
            },
            transition: 'all 0.3s ease'
          }}
        >
          Add Product
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Image</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Price</TableCell>
              <TableCell>Stock</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {products.map((product) => {
              const stockStatus = getStockStatus(product.stock);
              return (
                <TableRow key={product.id}>
                  <TableCell>
                    <img
                      src={product.image}
                      alt={product.name}
                      style={{ width: 50, height: 50, objectFit: 'cover', borderRadius: 4 }}
                    />
                  </TableCell>
                  <TableCell>{product.name}</TableCell>
                  <TableCell>{product.category?.name || 'N/A'}</TableCell>
                  <TableCell>Rp {product.price ? product.price.toLocaleString() : '0'}</TableCell>
                  <TableCell>{product.stock || 0}</TableCell>
                  <TableCell>
                    <Chip label={stockStatus.label} color={stockStatus.color} size="small" />
                  </TableCell>
                  <TableCell>
                    <IconButton onClick={() => handleOpen(product)} color="primary">
                      <Edit />
                    </IconButton>
                    <IconButton onClick={() => handleDelete(product.id)} color="error">
                      <Delete />
                    </IconButton>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
        <DialogTitle>
          {editingProduct ? 'Edit Product' : 'Add New Product'}
        </DialogTitle>
        <DialogContent>
          {/* Debug info */}
          {process.env.NODE_ENV === 'development' && (
            <Box sx={{ mb: 2, p: 1, bgcolor: '#f5f5f5', fontSize: '12px' }}>
              Categories loaded: {categories.length} | 
              Backend status: {categories.length > 0 ? 'Connected' : 'Disconnected'}
            </Box>
          )}
          
          <TextField
            fullWidth
            label="Product Name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            margin="normal"
          />
          <TextField
            fullWidth
            select
            label="Category"
            value={formData.categoryId}
            onChange={(e) => setFormData({ ...formData, categoryId: e.target.value })}
            margin="normal"
            required
          >
            <MenuItem value="" disabled>
              Select a category
            </MenuItem>
            {categories.length > 0 ? categories.map((category) => (
              <MenuItem key={category.id} value={category.id}>
                {category.name}
              </MenuItem>
            )) : (
              <MenuItem value="" disabled>
                Loading categories...
              </MenuItem>
            )}
          </TextField>
          <Box display="flex" gap={2}>
            <TextField
              label="Price"
              type="number"
              value={formData.price}
              onChange={(e) => setFormData({ ...formData, price: e.target.value })}
              margin="normal"
              fullWidth
            />
            <TextField
              label="Original Price"
              type="number"
              value={formData.originalPrice}
              onChange={(e) => setFormData({ ...formData, originalPrice: e.target.value })}
              margin="normal"
              fullWidth
            />
            <TextField
              label="Discount (%)"
              type="number"
              value={formData.discount}
              onChange={(e) => setFormData({ ...formData, discount: e.target.value })}
              margin="normal"
              fullWidth
            />
          </Box>
          <TextField
            fullWidth
            label="Stock"
            type="number"
            value={formData.stock}
            onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
            margin="normal"
          />
          <Box sx={{ mt: 2, mb: 2 }}>
            <Typography variant="h6" gutterBottom>
              Product Images
            </Typography>
            <ImageUpload
              images={productImages}
              onImagesChange={setProductImages}
            />
          </Box>
          <TextField
            fullWidth
            label="Description"
            multiline
            rows={4}
            value={formData.description}
            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button 
            onClick={handleSubmit} 
            variant="contained"
            sx={{
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: 'white',
              fontWeight: 600,
              px: 3,
              borderRadius: 2,
              '&:hover': { 
                background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)',
                transform: 'translateY(-1px)'
              },
              transition: 'all 0.3s ease'
            }}
          >
            {editingProduct ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default ProductsPage;