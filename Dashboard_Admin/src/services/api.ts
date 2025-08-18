import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8191/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      authService.logout();
    }
    return Promise.reject(error);
  }
);

export const authService = {
  login: async (email: string, password: string) => {
    const response = await api.post('/auth/login', { email, password });
    if (response.data.status && response.data.data.user.role === 'admin') {
      localStorage.setItem('admin_token', response.data.data.token);
      localStorage.setItem('admin_user', JSON.stringify(response.data.data.user));
      localStorage.setItem('login_date', new Date().toDateString());
    }
    return response.data;
  },
  logout: () => {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
    localStorage.removeItem('login_date');
    window.location.href = '/login';
  },
  getCurrentUser: () => {
    const token = localStorage.getItem('admin_token');
    const user = localStorage.getItem('admin_user');
    
    if (!token || !user) {
      return null;
    }
    
    try {
      return JSON.parse(user);
    } catch {
      return null;
    }
  },
  isAuthenticated: () => {
    const token = localStorage.getItem('admin_token');
    const user = localStorage.getItem('admin_user');
    const loginDate = localStorage.getItem('login_date');
    const today = new Date().toDateString();
    
    // Check if logged in today
    if (loginDate !== today) {
      return false;
    }
    
    return !!(token && user);
  },
};

export const dashboardService = {
  getStats: async () => {
    const response = await api.get('/admin/dashboard/stats');
    return response.data;
  },
  getSalesChart: async () => {
    const response = await api.get('/admin/dashboard/sales-chart');
    return response.data;
  },
};

export const productService = {
  getProducts: async (params?: any) => {
    const response = await api.get('/admin/products', { params });
    return response.data;
  },
  createProduct: async (productData: any) => {
    const response = await api.post('/admin/products', productData);
    return response.data;
  },
  updateProduct: async (id: number, productData: any) => {
    const response = await api.put(`/admin/products/${id}`, productData);
    return response.data;
  },
  deleteProduct: async (id: number) => {
    const response = await api.delete(`/admin/products/${id}`);
    return response.data;
  },
};

export const categoryService = {
  getCategories: async () => {
    const response = await api.get('/admin/categories');
    return response.data;
  },
  createCategory: async (categoryData: any) => {
    const response = await api.post('/admin/categories', categoryData);
    return response.data;
  },
  updateCategory: async (id: number, categoryData: any) => {
    const response = await api.put(`/admin/categories/${id}`, categoryData);
    return response.data;
  },
  deleteCategory: async (id: number) => {
    const response = await api.delete(`/admin/categories/${id}`);
    return response.data;
  },
};

export const userService = {
  getUsers: async (params?: any) => {
    const response = await api.get('/admin/users', { params });
    return response.data;
  },
};

export const orderService = {
  getOrders: async (params?: any) => {
    const response = await api.get('/admin/orders', { params });
    return response.data;
  },
  updateOrderStatus: async (id: number, status: string) => {
    const response = await api.put(`/admin/orders/${id}/status`, { status });
    return response.data;
  },
};

export const analyticsService = {
  getSalesAnalytics: async () => {
    const response = await api.get('/admin/analytics/sales');
    return response.data;
  },
  getCategoryAnalytics: async () => {
    const response = await api.get('/admin/analytics/categories');
    return response.data;
  },
  getRevenueAnalytics: async () => {
    const response = await api.get('/admin/analytics/revenue');
    return response.data;
  },
};

export const salesReportService = {
  getSalesReport: async (params?: any) => {
    const response = await api.get('/admin/sales-report', { params });
    return response.data;
  },
  exportSalesReport: async (format: 'pdf' | 'excel', params?: any) => {
    const response = await api.get(`/admin/sales-report/export/${format}`, { 
      params,
      responseType: 'blob'
    });
    return response.data;
  },
};

export const employeeService = {
  getEmployees: async (params?: any) => {
    const response = await api.get('/admin/employees', { params });
    return response.data;
  },
  createEmployee: async (employeeData: any) => {
    const response = await api.post('/admin/employees', employeeData);
    return response.data;
  },
  updateEmployee: async (id: number, employeeData: any) => {
    const response = await api.put(`/admin/employees/${id}`, employeeData);
    return response.data;
  },
  deleteEmployee: async (id: number) => {
    const response = await api.delete(`/admin/employees/${id}`);
    return response.data;
  },
  getShifts: async () => {
    const response = await api.get('/admin/shifts');
    return response.data;
  },
  getAttendance: async (params?: any) => {
    const response = await api.get('/admin/attendance', { params });
    return response.data;
  },
  createAttendance: async (attendanceData: any) => {
    const response = await api.post('/admin/attendance', attendanceData);
    return response.data;
  },
  getPayroll: async (params?: any) => {
    const response = await api.get('/admin/payroll', { params });
    return response.data;
  },
  createPayroll: async (payrollData: any) => {
    const response = await api.post('/admin/payroll', payrollData);
    return response.data;
  },
};

export default api;