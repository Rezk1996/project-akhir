import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Typography,
  Alert,
  Chip,
  IconButton,
} from '@mui/material';
import { Grid } from '@mui/material';
import { Add, Delete } from '@mui/icons-material';
import ImageUpload from '../components/ImageUpload';
import { productService, categoryService } from '../services/api';

interface ProductForm {
  name: string;
  description: string;
  price: string;
  originalPrice: string;
  category: string;
  stock: string;
  specifications: Record<string, string>;
}

const AddProductPage: React.FC = () => {
  const [formData, setFormData] = useState<ProductForm>({
    name: '',
    description: '',
    price: '',
    originalPrice: '',
    category: '',
    stock: '',
    specifications: {}
  });
  const [images, setImages] = useState<string[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [newSpecKey, setNewSpecKey] = useState('');
  const [newSpecValue, setNewSpecValue] = useState('');
  const [alert, setAlert] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const loadCategories = async () => {
      try {
        const response = await categoryService.getCategories();
        if (response.status) {
          setCategories(response.data.categories || []);
        }
      } catch (error) {
        console.error('Error loading categories:', error);
      }
    };

    loadCategories();
  }, []);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSelectChange = (e: any) => {
    setFormData(prev => ({ ...prev, category: e.target.value }));
  };

  const addSpecification = () => {
    if (newSpecKey && newSpecValue) {
      setFormData(prev => ({
        ...prev,
        specifications: { ...prev.specifications, [newSpecKey]: newSpecValue }
      }));
      setNewSpecKey('');
      setNewSpecValue('');
    }
  };

  const removeSpecification = (key: string) => {
    setFormData(prev => {
      const newSpecs = { ...prev.specifications };
      delete newSpecs[key];
      return { ...prev, specifications: newSpecs };
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formData.name || !formData.price || !formData.category) {
      setAlert({ type: 'error', message: 'Please fill in all required fields' });
      return;
    }

    if (formData.name.length > 100) {
      setAlert({ type: 'error', message: 'Product name is too long. Maximum 100 characters allowed.' });
      return;
    }

    if (images.length === 0) {
      setAlert({ type: 'error', message: 'Please add at least one product image' });
      return;
    }



    setLoading(true);

    try {
      const productData = {
        name: formData.name,
        description: formData.description,
        price: parseFloat(formData.price),
        originalPrice: formData.originalPrice ? parseFloat(formData.originalPrice) : null,
        category: formData.category,
        stock: parseInt(formData.stock) || 0,
        image: images[0],
        images: images,
        specifications: formData.specifications,
        rating: 0.0,
        sold: 0,
        discount: formData.originalPrice ? 
          Math.round(((parseFloat(formData.originalPrice) - parseFloat(formData.price)) / parseFloat(formData.originalPrice)) * 100) : 0
      };

      console.log('Sending product data:', productData);
      const result = await productService.createProduct(productData);
      console.log('Server response:', result);
      
      if (result.status) {
        setAlert({ type: 'success', message: result.message || 'Product added successfully! It will appear on the ecommerce website immediately.' });
        
        // Reset form
        setFormData({
          name: '', description: '', price: '', originalPrice: '', 
          category: '', stock: '', specifications: {}
        });
        setImages([]);
        
        // Auto-hide success message after 3 seconds
        setTimeout(() => setAlert(null), 3000);
      } else {
        console.error('Server returned error:', result);
        setAlert({ type: 'error', message: result.message || 'Failed to add product' });
      }
    } catch (error: any) {
      console.error('Error adding product:', error);
      console.error('Error response:', error.response?.data);
      
      let errorMessage = 'Failed to add product. Please try again.';
      if (error.response?.data?.message) {
        errorMessage = error.response.data.message;
      } else if (error.message) {
        errorMessage = error.message;
      }
      
      setAlert({ type: 'error', message: errorMessage });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Add New Product
      </Typography>
      <Typography variant="body1" color="textSecondary" gutterBottom>
        Products added here will immediately appear on the ecommerce website
      </Typography>

      {alert && (
        <Alert severity={alert.type} sx={{ mb: 3 }}>
          {alert.message}
        </Alert>
      )}

      <form onSubmit={handleSubmit}>
        <Paper sx={{ p: 3, mb: 3 }}>
          <Typography variant="h6" gutterBottom>
            Basic Information
          </Typography>
          
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <TextField
                name="name"
                label="Product Name"
                fullWidth
                required
                value={formData.name}
                onChange={handleInputChange}
                inputProps={{ maxLength: 100 }}
                helperText={`${formData.name.length}/100 characters`}
              />
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth required>
                <InputLabel>Category</InputLabel>
                <Select
                  value={formData.category}
                  label="Category"
                  onChange={handleSelectChange}
                >
                  {categories.map((category) => (
                    <MenuItem key={category.id} value={category.name}>
                      {category.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12}>
              <TextField
                name="description"
                label="Description"
                fullWidth
                multiline
                rows={4}
                value={formData.description}
                onChange={handleInputChange}
              />
            </Grid>
            
            <Grid item xs={12} md={4}>
              <TextField
                name="price"
                label="Price (Rp)"
                fullWidth
                required
                type="number"
                value={formData.price}
                onChange={handleInputChange}
              />
            </Grid>
            
            <Grid item xs={12} md={4}>
              <TextField
                name="originalPrice"
                label="Original Price (Rp)"
                fullWidth
                type="number"
                value={formData.originalPrice}
                onChange={handleInputChange}
                helperText="Leave empty if no discount"
              />
            </Grid>
            
            <Grid item xs={12} md={4}>
              <TextField
                name="stock"
                label="Stock Quantity"
                fullWidth
                type="number"
                value={formData.stock}
                onChange={handleInputChange}
              />
            </Grid>
          </Grid>
        </Paper>

        <Paper sx={{ p: 3, mb: 3 }}>
          <Typography variant="h6" gutterBottom>
            Product Images
          </Typography>
          <ImageUpload images={images} onImagesChange={setImages} />
        </Paper>

        <Paper sx={{ p: 3, mb: 3 }}>
          <Typography variant="h6" gutterBottom>
            Specifications
          </Typography>
          
          <Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
            <TextField
              label="Specification Name"
              value={newSpecKey}
              onChange={(e) => setNewSpecKey(e.target.value)}
              placeholder="e.g., Weight"
            />
            <TextField
              label="Value"
              value={newSpecValue}
              onChange={(e) => setNewSpecValue(e.target.value)}
              placeholder="e.g., 1kg"
            />
            <Button
              variant="contained"
              startIcon={<Add />}
              onClick={addSpecification}
              disabled={!newSpecKey || !newSpecValue}
              sx={{
                background: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
                color: 'white',
                fontWeight: 600,
                borderRadius: 2,
                '&:hover': { 
                  background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
                  transform: 'translateY(-1px)'
                },
                '&:disabled': {
                  background: 'linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%)',
                  color: '#a0aec0'
                },
                transition: 'all 0.3s ease'
              }}
            >
              Add
            </Button>
          </Box>
          
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
            {Object.entries(formData.specifications).map(([key, value]) => (
              <Chip
                key={key}
                label={`${key}: ${value}`}
                onDelete={() => removeSpecification(key)}
                deleteIcon={<Delete />}
                color="primary"
                variant="outlined"
              />
            ))}
          </Box>
        </Paper>

        <Box sx={{ display: 'flex', gap: 2, justifyContent: 'flex-end' }}>
          <Button
            type="submit"
            variant="contained"
            disabled={loading}
            size="large"
            sx={{
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: 'white',
              fontWeight: 600,
              px: 4,
              py: 1.5,
              borderRadius: 2,
              boxShadow: '0 4px 15px rgba(102, 126, 234, 0.4)',
              '&:hover': { 
                background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)',
                transform: 'translateY(-2px)',
                boxShadow: '0 6px 20px rgba(102, 126, 234, 0.6)'
              },
              '&:disabled': {
                background: 'linear-gradient(135deg, #a0aec0 0%, #718096 100%)',
                transform: 'none',
                boxShadow: 'none'
              },
              transition: 'all 0.3s ease'
            }}
          >
            {loading ? 'Adding Product...' : 'Add Product to Ecommerce'}
          </Button>
        </Box>
      </form>
    </Box>
  );
};

export default AddProductPage;