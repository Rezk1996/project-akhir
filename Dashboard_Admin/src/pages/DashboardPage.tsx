import React, { useEffect, useState } from 'react';
import {
  Grid,
  Paper,
  Typography,
  Box,
  Card,
  CardContent,
} from '@mui/material';
import {
  TrendingUp,
  People,
  Inventory,
  ShoppingCart,
  Warning,
  PendingActions,
} from '@mui/icons-material';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
} from 'recharts';
import { dashboardService, analyticsService } from '../services/api';
import { DashboardStats, SalesData } from '../types';

const StatCard: React.FC<{
  title: string;
  value: string | number;
  icon: React.ReactNode;
  color: string;
  gradient: string;
}> = ({ title, value, icon, color, gradient }) => (
  <Card sx={{ 
    height: '100%',
    background: gradient,
    color: 'white',
    position: 'relative',
    overflow: 'hidden',
    '&::before': {
      content: '""',
      position: 'absolute',
      top: 0,
      right: 0,
      width: '100px',
      height: '100px',
      background: 'rgba(255,255,255,0.1)',
      borderRadius: '50%',
      transform: 'translate(30px, -30px)',
    }
  }}>
    <CardContent sx={{ position: 'relative', zIndex: 1 }}>
      <Box display="flex" alignItems="center" justifyContent="space-between">
        <Box>
          <Typography 
            sx={{ color: 'rgba(255,255,255,0.8)', fontSize: '0.875rem', fontWeight: 500 }} 
            gutterBottom
          >
            {title}
          </Typography>
          <Typography variant="h4" component="h2" sx={{ fontWeight: 700, color: 'white' }}>
            {value}
          </Typography>
        </Box>
        <Box sx={{ 
          color: 'rgba(255,255,255,0.9)', 
          fontSize: 48,
          opacity: 0.8
        }}>
          {icon}
        </Box>
      </Box>
    </CardContent>
  </Card>
);

const DashboardPage: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [salesData, setSalesData] = useState<SalesData[]>([]);
  const [categoryData, setCategoryData] = useState<any[]>([]);
  const [revenueData, setRevenueData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  // Mock data for enhanced analytics
  const mockCategoryData = [
    { name: 'Groceries', value: 45, color: '#4CAF50' },
    { name: 'Beverages', value: 25, color: '#2196F3' },
    { name: 'Household', value: 20, color: '#FF9800' },
    { name: 'Personal Care', value: 10, color: '#9C27B0' },
  ];

  const mockRevenueData = [
    { month: 'Jan', revenue: 2400000, profit: 480000 },
    { month: 'Feb', revenue: 3800000, profit: 760000 },
    { month: 'Mar', revenue: 6000000, profit: 1200000 },
    { month: 'Apr', revenue: 5600000, profit: 1120000 },
    { month: 'May', revenue: 9000000, profit: 1800000 },
    { month: 'Jun', revenue: 7600000, profit: 1520000 },
  ];

  useEffect(() => {
    const loadDashboardData = async () => {
      try {
        const [statsResponse, salesResponse, categoryResponse, revenueResponse] = await Promise.all([
          dashboardService.getStats(),
          analyticsService.getSalesAnalytics(),
          analyticsService.getCategoryAnalytics(),
          analyticsService.getRevenueAnalytics(),
        ]);

        if (statsResponse.status) {
          setStats(statsResponse.data);
        }

        if (salesResponse.status) {
          setSalesData(salesResponse.data.salesData || mockRevenueData);
        }
        
        if (categoryResponse.status) {
          setCategoryData(categoryResponse.data.categoryData || mockCategoryData);
        } else {
          setCategoryData(mockCategoryData);
        }
        
        if (revenueResponse.status) {
          setRevenueData(revenueResponse.data.revenueData || mockRevenueData);
        } else {
          setRevenueData(mockRevenueData);
        }
      } catch (error) {
        console.error('Error loading dashboard data:', error);
      } finally {
        setLoading(false);
      }
    };

    loadDashboardData();
  }, []);

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" height="400px">
        <Typography>Loading dashboard...</Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Box sx={{ mb: 4 }}>
        <Typography 
          variant="h4" 
          gutterBottom 
          sx={{ 
            fontWeight: 700,
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            backgroundClip: 'text',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            mb: 1
          }}
        >
          Dashboard Overview
        </Typography>
        <Typography variant="body1" sx={{ color: '#4a5568', fontSize: '1.1rem' }}>
          Welcome back! Here's what's happening with your store today.
        </Typography>
      </Box>

      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Total Products"
            value={stats?.totalProducts || 0}
            icon={<Inventory />}
            color="#2196f3"
            gradient="linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Total Users"
            value={stats?.totalUsers || 0}
            icon={<People />}
            color="#4caf50"
            gradient="linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Total Orders"
            value={stats?.totalOrders || 0}
            icon={<ShoppingCart />}
            color="#ff9800"
            gradient="linear-gradient(135deg, #fa709a 0%, #fee140 100%)"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Revenue"
            value={`Rp ${(stats?.totalRevenue || 0).toLocaleString()}`}
            icon={<TrendingUp />}
            color="#e53935"
            gradient="linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Low Stock"
            value={stats?.lowStockProducts || 0}
            icon={<Warning />}
            color="#f44336"
            gradient="linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={2}>
          <StatCard
            title="Pending Orders"
            value={stats?.pendingOrders || 0}
            icon={<PendingActions />}
            color="#9c27b0"
            gradient="linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)"
          />
        </Grid>
      </Grid>

      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ 
            p: 3, 
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255,255,255,0.2)'
          }}>
            <Typography variant="h6" gutterBottom sx={{ fontWeight: 600, color: '#1a202c' }}>
              Revenue & Profit Trend
            </Typography>
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={revenueData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis />
                <Tooltip formatter={(value) => `Rp ${Number(value).toLocaleString()}`} />
                <Area type="monotone" dataKey="revenue" stackId="1" stroke="#2196F3" fill="#2196F3" fillOpacity={0.6} />
                <Area type="monotone" dataKey="profit" stackId="2" stroke="#4CAF50" fill="#4CAF50" fillOpacity={0.6} />
              </AreaChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper sx={{ 
            p: 3,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255,255,255,0.2)'
          }}>
            <Typography variant="h6" gutterBottom sx={{ fontWeight: 600, color: '#1a202c' }}>
              Products by Category
            </Typography>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={categoryData}
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  dataKey="value"
                  label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                >
                  {categoryData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip formatter={(value) => [`${value}%`, 'Percentage']} />
              </PieChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>
      
      <Grid container spacing={3} sx={{ mt: 2 }}>
        <Grid item xs={12} md={6}>
          <Paper sx={{ 
            p: 3,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255,255,255,0.2)'
          }}>
            <Typography variant="h6" gutterBottom sx={{ fontWeight: 600, color: '#1a202c' }}>
              Sales Trend (Last 30 Days)
            </Typography>
            <ResponsiveContainer width="100%" height={250}>
              <LineChart data={salesData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" />
                <YAxis />
                <Tooltip />
                <Line type="monotone" dataKey="sales" stroke="#e53935" strokeWidth={3} />
              </LineChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={6}>
          <Paper sx={{ 
            p: 3,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255,255,255,0.2)'
          }}>
            <Typography variant="h6" gutterBottom sx={{ fontWeight: 600, color: '#1a202c' }}>
              Orders Overview
            </Typography>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={salesData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="orders" fill="#2196f3" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default DashboardPage;