import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Grid,
  Button,
  TextField,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Card,
  CardContent,
} from '@mui/material';
import {
  Download,
  DateRange,
  TrendingUp,
  AttachMoney,
  ShoppingCart,
  Assessment,
} from '@mui/icons-material';
import { salesReportService, analyticsService } from '../services/api';
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
} from 'recharts';

interface SalesReport {
  id: string;
  date: string;
  product: string;
  category: string;
  quantity: number;
  unitPrice: number;
  totalAmount: number;
  customer: string;
  status: 'completed' | 'pending' | 'cancelled';
}

const mockSalesData = [
  {
    id: 'ORD001',
    date: '2024-01-15',
    product: 'Organic Apples (1kg)',
    category: 'Groceries',
    quantity: 2,
    unitPrice: 25000,
    totalAmount: 50000,
    customer: 'John Doe',
    status: 'completed' as const,
  },
  {
    id: 'ORD002',
    date: '2024-01-15',
    product: 'Whole Grain Bread',
    category: 'Groceries',
    quantity: 1,
    unitPrice: 15000,
    totalAmount: 15000,
    customer: 'Jane Smith',
    status: 'completed' as const,
  },
  {
    id: 'ORD003',
    date: '2024-01-14',
    product: 'Premium Coffee Beans',
    category: 'Beverages',
    quantity: 3,
    unitPrice: 45000,
    totalAmount: 135000,
    customer: 'Bob Wilson',
    status: 'pending' as const,
  },
];

const mockChartData = [
  { date: '2024-01-10', sales: 1200000, orders: 45 },
  { date: '2024-01-11', sales: 1800000, orders: 67 },
  { date: '2024-01-12', sales: 2200000, orders: 89 },
  { date: '2024-01-13', sales: 1900000, orders: 72 },
  { date: '2024-01-14', sales: 2500000, orders: 95 },
  { date: '2024-01-15', sales: 2800000, orders: 108 },
];

const SalesReportPage: React.FC = () => {
  const [salesData, setSalesData] = useState<SalesReport[]>(mockSalesData);
  const [chartData, setChartData] = useState(mockChartData);
  const [loading, setLoading] = useState(true);
  const [dateFrom, setDateFrom] = useState('2024-01-01');
  const [dateTo, setDateTo] = useState('2024-01-31');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [statusFilter, setStatusFilter] = useState('all');

  useEffect(() => {
    const loadSalesData = async () => {
      try {
        const [reportResponse, analyticsResponse] = await Promise.all([
          salesReportService.getSalesReport({ dateFrom, dateTo, categoryFilter, statusFilter }),
          analyticsService.getSalesAnalytics()
        ]);

        if (reportResponse.status) {
          setSalesData(reportResponse.data.salesData || mockSalesData);
        }

        if (analyticsResponse.status) {
          setChartData(analyticsResponse.data.chartData || mockChartData);
        }
      } catch (error) {
        console.error('Error loading sales data:', error);
      } finally {
        setLoading(false);
      }
    };

    loadSalesData();
  }, [dateFrom, dateTo, categoryFilter, statusFilter]);

  const totalSales = salesData.reduce((sum, item) => sum + item.totalAmount, 0);
  const totalOrders = salesData.length;
  const avgOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0;
  const completedOrders = salesData.filter(item => item.status === 'completed').length;

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'success';
      case 'pending': return 'warning';
      case 'cancelled': return 'error';
      default: return 'default';
    }
  };

  const handleExportPDF = async () => {
    try {
      const blob = await salesReportService.exportSalesReport('pdf', {
        dateFrom, dateTo, categoryFilter, statusFilter
      });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `sales-report-${dateFrom}-to-${dateTo}.pdf`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error) {
      console.error('Error exporting PDF:', error);
      alert('Error exporting PDF. Please try again.');
    }
  };

  const handleExportExcel = async () => {
    try {
      const blob = await salesReportService.exportSalesReport('excel', {
        dateFrom, dateTo, categoryFilter, statusFilter
      });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `sales-report-${dateFrom}-to-${dateTo}.xlsx`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error) {
      console.error('Error exporting Excel:', error);
      alert('Error exporting Excel. Please try again.');
    }
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">
          Sales Reports & Analytics
        </Typography>
        <Box display="flex" gap={2}>
          <Button
            variant="outlined"
            startIcon={<Download />}
            onClick={handleExportPDF}
          >
            Export PDF
          </Button>
          <Button
            variant="contained"
            startIcon={<Download />}
            onClick={handleExportExcel}
          >
            Export Excel
          </Button>
        </Box>
      </Box>

      {/* Summary Cards */}
      <Grid container spacing={3} sx={{ mb: 3 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box display="flex" alignItems="center" justifyContent="space-between">
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Total Sales
                  </Typography>
                  <Typography variant="h5">
                    Rp {totalSales.toLocaleString()}
                  </Typography>
                </Box>
                <AttachMoney sx={{ fontSize: 40, color: '#4CAF50' }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box display="flex" alignItems="center" justifyContent="space-between">
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Total Orders
                  </Typography>
                  <Typography variant="h5">
                    {totalOrders}
                  </Typography>
                </Box>
                <ShoppingCart sx={{ fontSize: 40, color: '#2196F3' }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box display="flex" alignItems="center" justifyContent="space-between">
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Avg Order Value
                  </Typography>
                  <Typography variant="h5">
                    Rp {Math.round(avgOrderValue).toLocaleString()}
                  </Typography>
                </Box>
                <TrendingUp sx={{ fontSize: 40, color: '#FF9800' }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box display="flex" alignItems="center" justifyContent="space-between">
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Completion Rate
                  </Typography>
                  <Typography variant="h5">
                    {totalOrders > 0 ? Math.round((completedOrders / totalOrders) * 100) : 0}%
                  </Typography>
                </Box>
                <Assessment sx={{ fontSize: 40, color: '#9C27B0' }} />
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Charts */}
      <Grid container spacing={3} sx={{ mb: 3 }}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3 }}>
            <Typography variant="h6" gutterBottom>
              Sales Trend (Last 7 Days)
            </Typography>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" />
                <YAxis />
                <Tooltip formatter={(value, name) => [
                  name === 'sales' ? `Rp ${Number(value).toLocaleString()}` : value,
                  name === 'sales' ? 'Sales' : 'Orders'
                ]} />
                <Line type="monotone" dataKey="sales" stroke="#4CAF50" strokeWidth={3} />
              </LineChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 3 }}>
            <Typography variant="h6" gutterBottom>
              Orders by Day
            </Typography>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="orders" fill="#2196F3" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>

      {/* Filters */}
      <Paper sx={{ p: 3, mb: 3 }}>
        <Typography variant="h6" gutterBottom>
          Filter Reports
        </Typography>
        <Grid container spacing={3}>
          <Grid item xs={12} md={3}>
            <TextField
              fullWidth
              label="From Date"
              type="date"
              value={dateFrom}
              onChange={(e) => setDateFrom(e.target.value)}
              InputLabelProps={{ shrink: true }}
            />
          </Grid>
          <Grid item xs={12} md={3}>
            <TextField
              fullWidth
              label="To Date"
              type="date"
              value={dateTo}
              onChange={(e) => setDateTo(e.target.value)}
              InputLabelProps={{ shrink: true }}
            />
          </Grid>
          <Grid item xs={12} md={3}>
            <FormControl fullWidth>
              <InputLabel>Category</InputLabel>
              <Select
                value={categoryFilter}
                label="Category"
                onChange={(e) => setCategoryFilter(e.target.value)}
              >
                <MenuItem value="all">All Categories</MenuItem>
                <MenuItem value="groceries">Groceries</MenuItem>
                <MenuItem value="beverages">Beverages</MenuItem>
                <MenuItem value="household">Household</MenuItem>
              </Select>
            </FormControl>
          </Grid>
          <Grid item xs={12} md={3}>
            <FormControl fullWidth>
              <InputLabel>Status</InputLabel>
              <Select
                value={statusFilter}
                label="Status"
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <MenuItem value="all">All Status</MenuItem>
                <MenuItem value="completed">Completed</MenuItem>
                <MenuItem value="pending">Pending</MenuItem>
                <MenuItem value="cancelled">Cancelled</MenuItem>
              </Select>
            </FormControl>
          </Grid>
        </Grid>
      </Paper>

      {/* Sales Table */}
      <Paper>
        <TableContainer>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Order ID</TableCell>
                <TableCell>Date</TableCell>
                <TableCell>Product</TableCell>
                <TableCell>Category</TableCell>
                <TableCell>Quantity</TableCell>
                <TableCell>Unit Price</TableCell>
                <TableCell>Total</TableCell>
                <TableCell>Customer</TableCell>
                <TableCell>Status</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {salesData.map((row) => (
                <TableRow key={row.id}>
                  <TableCell>{row.id}</TableCell>
                  <TableCell>{row.date}</TableCell>
                  <TableCell>{row.product}</TableCell>
                  <TableCell>{row.category}</TableCell>
                  <TableCell>{row.quantity}</TableCell>
                  <TableCell>Rp {row.unitPrice.toLocaleString()}</TableCell>
                  <TableCell>Rp {row.totalAmount.toLocaleString()}</TableCell>
                  <TableCell>{row.customer}</TableCell>
                  <TableCell>
                    <Chip
                      label={row.status}
                      color={getStatusColor(row.status) as any}
                      size="small"
                    />
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  );
};

export default SalesReportPage;