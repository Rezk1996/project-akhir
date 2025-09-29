-- Create test users first
INSERT INTO users (name, email, password, role) VALUES 
('Test Customer 1', 'customer1@test.com', '$2a$10$dummy.hash.for.testing', 'customer'),
('Test Customer 2', 'customer2@test.com', '$2a$10$dummy.hash.for.testing', 'customer')
ON CONFLICT (email) DO NOTHING;

-- Create test categories
INSERT INTO categories (name, icon_color) VALUES 
('Makanan', '#FF6B6B'),
('Minuman', '#4ECDC4')
ON CONFLICT (name) DO NOTHING;

-- Create test products
INSERT INTO products (name, price, image, description, stock, category_id) VALUES 
('Nasi Goreng', 25000, '/images/products/nasi-goreng.jpg', 'Nasi goreng spesial', 50, 1),
('Es Teh Manis', 8000, '/images/products/es-teh.jpg', 'Es teh manis segar', 100, 2)
ON CONFLICT DO NOTHING;

-- Create test orders with proper ENUM casting
INSERT INTO orders (user_id, total_amount, shipping_cost, status, shipping_address, phone_number, payment_method, payment_status, notes) VALUES 
(
    (SELECT id FROM users WHERE email = 'customer1@test.com' LIMIT 1),
    33000,
    8000,
    'pending'::transaction_status_type,
    'Jl. Test No. 123, Jakarta Selatan, DKI Jakarta 12345',
    '081234567890',
    'cod'::payment_method_type,
    'pending'::payment_status_type,
    'Tolong antar sore hari'
),
(
    (SELECT id FROM users WHERE email = 'customer2@test.com' LIMIT 1),
    16000,
    8000,
    'processing'::transaction_status_type,
    'Jl. Sample No. 456, Bandung, Jawa Barat 40123',
    '081987654321',
    'bank_transfer'::payment_method_type,
    'paid'::payment_status_type,
    'Pembayaran sudah transfer'
);

-- Create order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(
    (SELECT id FROM orders WHERE user_id = (SELECT id FROM users WHERE email = 'customer1@test.com' LIMIT 1) LIMIT 1),
    (SELECT id FROM products WHERE name = 'Nasi Goreng' LIMIT 1),
    1,
    25000
),
(
    (SELECT id FROM orders WHERE user_id = (SELECT id FROM users WHERE email = 'customer2@test.com' LIMIT 1) LIMIT 1),
    (SELECT id FROM products WHERE name = 'Es Teh Manis' LIMIT 1),
    1,
    8000
);