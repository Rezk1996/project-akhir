import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Paper,
  TextField,
  Button,
  Typography,
  Box,
  Alert,
  InputAdornment,
  IconButton,
  Divider,
  Card,
} from '@mui/material';
import { Visibility, VisibilityOff, AdminPanelSettings, Store } from '@mui/icons-material';
import { authService } from '../services/api';

const LoginPage: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  
  // Redirect if already logged in
  React.useEffect(() => {
    if (authService.isAuthenticated()) {
      navigate('/', { replace: true });
    }
  }, [navigate]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await authService.login(email, password);
      if (response.status && response.data.user.role === 'admin') {
        navigate('/', { replace: true });
      } else {
        setError('Access denied. Admin privileges required.');
      }
    } catch (err: any) {
      setError(err.response?.data?.message || 'Invalid email or password');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      p: 2
    }}>
      <Container maxWidth="sm">
        <Paper 
          elevation={24} 
          sx={{ 
            p: 4, 
            borderRadius: 3,
            background: 'rgba(255, 255, 255, 0.95)',
            backdropFilter: 'blur(10px)'
          }}
        >
          <Box textAlign="center" mb={4}>
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', mb: 2 }}>
              <Store sx={{ fontSize: 40, color: '#1976d2', mr: 1 }} />
              <AdminPanelSettings sx={{ fontSize: 40, color: '#e53935' }} />
            </Box>
            <Typography 
              variant="h3" 
              component="h1" 
              gutterBottom 
              sx={{ 
                background: 'linear-gradient(45deg, #1976d2, #e53935)',
                backgroundClip: 'text',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
                fontWeight: 'bold',
                mb: 1
              }}
            >
              Rmart Admin
            </Typography>
            <Typography variant="h6" color="textSecondary" sx={{ mb: 2 }}>
              Dashboard Management System
            </Typography>
            <Divider sx={{ mb: 3 }} />
          </Box>

          {error && (
            <Alert severity="error" sx={{ mb: 3, borderRadius: 2 }}>
              {error}
            </Alert>
          )}

          <form onSubmit={handleSubmit}>
            <TextField
              fullWidth
              label="Email Address"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              margin="normal"
              required
              variant="outlined"
              sx={{ mb: 2 }}
            />
            <TextField
              fullWidth
              label="Password"
              type={showPassword ? 'text' : 'password'}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              margin="normal"
              required
              variant="outlined"
              sx={{ mb: 3 }}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowPassword(!showPassword)}
                      edge="end"
                    >
                      {showPassword ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              size="large"
              sx={{ 
                mt: 2, 
                mb: 3, 
                py: 1.5,
                background: 'linear-gradient(45deg, #1976d2, #e53935)',
                '&:hover': { 
                  background: 'linear-gradient(45deg, #1565c0, #d32f2f)',
                  transform: 'translateY(-1px)',
                  boxShadow: '0 8px 25px rgba(0,0,0,0.15)'
                },
                transition: 'all 0.3s ease',
                borderRadius: 2,
                fontSize: '1.1rem',
                fontWeight: 'bold'
              }}
              disabled={loading}
            >
              {loading ? 'Signing In...' : 'Sign In to Dashboard'}
            </Button>
          </form>

          <Card sx={{ p: 2, mt: 3, bgcolor: '#f5f5f5', borderRadius: 2 }}>
            <Typography variant="body2" color="textSecondary" textAlign="center" sx={{ mb: 1 }}>
              <strong>Demo Credentials:</strong>
            </Typography>
            <Typography variant="body2" textAlign="center" sx={{ fontFamily: 'monospace' }}>
              Email: admin@rmart.com<br/>
              Password: admin123
            </Typography>
          </Card>
        </Paper>
      </Container>
    </Box>
  );
};

export default LoginPage;