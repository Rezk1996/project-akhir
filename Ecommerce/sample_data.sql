-- Sample data for DB_Rmart

-- Insert categories
INSERT INTO categories (name, image, icon_color) VALUES
('Electronics', 'https://cdn-icons-png.flaticon.com/512/2553/2553645.png', '#3498db'),
('Fashion', 'https://cdn-icons-png.flaticon.com/512/2553/2553644.png', '#e74c3c'),
('Books', 'https://cdn-icons-png.flaticon.com/512/2232/2232688.png', '#f39c12'),
('Home', 'https://cdn-icons-png.flaticon.com/512/3659/3659997.png', '#2ecc71'),
('Sports', 'https://cdn-icons-png.flaticon.com/512/857/857418.png', '#9b59b6');

-- Insert products
INSERT INTO products (name, price, original_price, discount, image, description, rating, stock, category_id) VALUES
('iPhone 14 Pro', 999.99, 1099.99, 9, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400', 'Latest iPhone with advanced camera system and A16 Bionic chip', 4.8, 50, 1),
('Samsung Galaxy S23', 899.99, 999.99, 10, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400', 'Flagship Android phone with excellent display and camera', 4.7, 30, 1),
('MacBook Air M2', 1199.99, 1299.99, 8, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400', 'Lightweight laptop with Apple M2 chip for ultimate performance', 4.9, 25, 1),
('Nike Air Max 270', 150.00, 180.00, 17, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'Comfortable running shoes with Air Max technology', 4.5, 100, 2),
('Sony WH-1000XM4', 349.99, 399.99, 13, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', 'Industry-leading noise canceling wireless headphones', 4.8, 40, 1),
('Kindle Paperwhite', 139.99, 159.99, 13, 'https://images.unsplash.com/photo-1481277542470-605612bd2d61?w=400', 'Waterproof e-reader with adjustable warm light', 4.6, 120, 3),
('Coffee Maker Deluxe', 89.99, 109.99, 18, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400', 'Programmable coffee maker with thermal carafe', 4.4, 45, 4),
('Yoga Mat Premium', 49.99, 59.99, 17, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', 'Non-slip yoga mat with extra cushioning', 4.3, 90, 5);

-- Insert sample users
INSERT INTO users (name, email, password, role) VALUES
('Admin User', 'admin@rmart.com', 'admin123', 'admin'),
('John Doe', 'john@example.com', 'password123', 'customer'),
('Jane Smith', 'jane@example.com', 'password123', 'customer');