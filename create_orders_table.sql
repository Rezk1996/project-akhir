-- Create orders table for order management
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_cost DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'pending',
    shipping_address TEXT,
    phone_number VARCHAR(20),
    notes TEXT,
    payment_method VARCHAR(20) DEFAULT 'cod',
    payment_status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_items table for order details
CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES barang(id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Insert some sample orders for testing
INSERT INTO orders (user_id, total_amount, shipping_cost, status, shipping_address, phone_number, payment_method, payment_status) VALUES
(1, 150000.00, 15000.00, 'pending', 'Jl. Merdeka No. 123, Jakarta', '081234567890', 'cod', 'pending'),
(1, 75000.00, 10000.00, 'processing', 'Jl. Sudirman No. 456, Jakarta', '081234567890', 'transfer', 'paid'),
(1, 200000.00, 20000.00, 'shipped', 'Jl. Thamrin No. 789, Jakarta', '081234567890', 'cod', 'pending')
ON CONFLICT DO NOTHING;

-- Verify tables were created
SELECT 'Orders table created successfully' as status;
SELECT COUNT(*) as order_count FROM orders;
SELECT COUNT(*) as order_items_count FROM order_items;