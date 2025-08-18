export interface User {
  id: number;
  name: string;
  email: string;
  role: 'admin' | 'customer';
  createdAt: string;
}

export interface Product {
  id: number;
  name: string;
  price: number;
  originalPrice?: number;
  discount?: number;
  image: string;
  images?: string[];
  description: string;
  rating: number;
  stock: number;
  sold: number;
  categoryId: number;
  category?: Category;
  createdAt: string;
}

export interface Category {
  id: number;
  name: string;
  description: string;
  productCount: number;
  image: string;
  iconColor: string;
  createdAt?: string;
}

export interface Order {
  id: number;
  userId: number;
  totalAmount: number;
  shippingCost: number;
  status: string;
  paymentMethod: string;
  paymentStatus: string;
  createdAt: string;
  user?: User;
  orderItems?: OrderItem[];
}

export interface OrderItem {
  id: number;
  orderId: number;
  productId: number;
  quantity: number;
  price: number;
  subtotal: number;
  product?: Product;
}

export interface DashboardStats {
  totalProducts: number;
  totalUsers: number;
  totalOrders: number;
  totalRevenue: number;
  lowStockProducts: number;
  pendingOrders: number;
}

export interface SalesData {
  date: string;
  sales: number;
  orders: number;
}