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
} from '@mui/material';
import { Add, Edit, Delete } from '@mui/icons-material';
import { categoryService } from '../services/api';
import { Category } from '../types';
import axios from 'axios';

const API_BASE_URL = 'http://localhost:8191/api';

const CategoriesPage: React.FC = () => {
  const [categories, setCategories] = useState<Category[]>([]);
  const [open, setOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [formData, setFormData] = useState({
    namaJenis: '',
    image: '',
    iconColor: '#007AFF',
  });

  useEffect(() => {
    loadCategories();
  }, []);

  const loadCategories = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/admin/categories`);
      if (response.data.status) {
        setCategories(response.data.data.categories || []);
      }
    } catch (error) {
      console.error('Error loading categories:', error);
    }
  };

  const handleOpen = (category?: Category) => {
    if (category) {
      setEditingCategory(category);
      setFormData({
        namaJenis: category.name,
        image: category.image || '',
        iconColor: category.iconColor || '#007AFF',
      });
    } else {
      setEditingCategory(null);
      setFormData({
        namaJenis: '',
        image: '',
        iconColor: '#007AFF',
      });
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditingCategory(null);
  };

  const handleSubmit = async () => {
    try {
      if (editingCategory) {
        await axios.put(`${API_BASE_URL}/admin/categories/${editingCategory.id}`, formData);
      } else {
        await axios.post(`${API_BASE_URL}/admin/categories`, formData);
      }

      loadCategories();
      handleClose();
    } catch (error: any) {
      console.error('Error saving category:', error);
      alert('Error saving category: ' + (error.response?.data?.message || error.message));
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this category?')) {
      try {
        await axios.delete(`${API_BASE_URL}/admin/categories/${id}`);
        loadCategories();
      } catch (error: any) {
        console.error('Error deleting category:', error);
        alert('Error deleting category: ' + (error.response?.data?.message || error.message));
      }
    }
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Categories Management</Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => handleOpen()}
          sx={{ 
            background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
            color: 'white',
            fontWeight: 600,
            px: 3,
            py: 1.5,
            borderRadius: 2,
            boxShadow: '0 4px 15px rgba(79, 172, 254, 0.4)',
            '&:hover': { 
              background: 'linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%)',
              transform: 'translateY(-2px)',
              boxShadow: '0 6px 20px rgba(79, 172, 254, 0.6)'
            },
            transition: 'all 0.3s ease'
          }}
        >
          Add Category
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Icon</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Color</TableCell>
              <TableCell>Product Count</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {categories.map((category) => (
              <TableRow key={category.id}>
                <TableCell>
                  <Box
                    sx={{
                      width: 40,
                      height: 40,
                      borderRadius: 1,
                      backgroundColor: category.iconColor,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                    }}
                  >
                    <img
                      src={category.image}
                      alt={category.name}
                      style={{ width: 24, height: 24, filter: 'brightness(0) invert(1)' }}
                    />
                  </Box>
                </TableCell>
                <TableCell>{category.name}</TableCell>
                <TableCell>
                  <Box
                    sx={{
                      width: 20,
                      height: 20,
                      borderRadius: '50%',
                      backgroundColor: category.iconColor,
                      display: 'inline-block',
                      mr: 1,
                    }}
                  />
                  {category.iconColor}
                </TableCell>
                <TableCell>{category.productCount}</TableCell>
                <TableCell>
                  <IconButton onClick={() => handleOpen(category)} color="primary">
                    <Edit />
                  </IconButton>
                  <IconButton onClick={() => handleDelete(category.id)} color="error">
                    <Delete />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>
          {editingCategory ? 'Edit Category' : 'Add New Category'}
        </DialogTitle>
        <DialogContent>
          <TextField
            fullWidth
            label="Category Name"
            value={formData.namaJenis}
            onChange={(e) => setFormData({ ...formData, namaJenis: e.target.value })}
            margin="normal"
            required
          />
          <TextField
            fullWidth
            label="Icon URL"
            value={formData.image}
            onChange={(e) => setFormData({ ...formData, image: e.target.value })}
            margin="normal"
            placeholder="https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
          />
          <TextField
            fullWidth
            label="Icon Color"
            type="color"
            value={formData.iconColor}
            onChange={(e) => setFormData({ ...formData, iconColor: e.target.value })}
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button 
            onClick={handleSubmit} 
            variant="contained"
            sx={{
              background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
              color: 'white',
              fontWeight: 600,
              px: 3,
              borderRadius: 2,
              '&:hover': { 
                background: 'linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%)',
                transform: 'translateY(-1px)'
              },
              transition: 'all 0.3s ease'
            }}
          >
            {editingCategory ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default CategoriesPage;