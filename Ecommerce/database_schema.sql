-- ENUM Definitions
DROP TYPE IF EXISTS user_role_type CASCADE;
DROP TYPE IF EXISTS payment_status_type CASCADE;
DROP TYPE IF EXISTS payment_method_type CASCADE;
DROP TYPE IF EXISTS transaction_status_type CASCADE;

CREATE TYPE user_role_type AS ENUM ('admin', 'customer');
CREATE TYPE payment_status_type AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE payment_method_type AS ENUM ('bank_transfer', 'credit_card', 'ewallet', 'cod');
CREATE TYPE transaction_status_type AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed');

-- USERS
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    phone VARCHAR(20),
    marital_status VARCHAR(20),
    birth_date DATE,
    gender VARCHAR(10),
    profile_image VARCHAR(500),
    role user_role_type DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- CATEGORIES
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    image VARCHAR(500),
    icon_color VARCHAR(7),
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT now()
);

-- PRODUCTS
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(12,2) CHECK (price > 0),
    original_price NUMERIC(12,2),
    discount INTEGER DEFAULT 0,
    image VARCHAR(500),
    description TEXT,
    rating NUMERIC(2,1) DEFAULT 0.0 CHECK (rating BETWEEN 0 AND 5),
    sold INTEGER DEFAULT 0,
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- PRODUCT IMAGES
CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    url VARCHAR(500),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- ADDRESSES
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255),
    phone VARCHAR(20),
    street TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(10),
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- CARTS
CREATE TABLE carts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- CART ITEMS
CREATE TABLE cart_items (
    id BIGSERIAL PRIMARY KEY,
    cart_id BIGINT REFERENCES carts(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    UNIQUE(cart_id, product_id)
);

-- ORDERS (Gabungan orders + transactions)
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    total_amount NUMERIC(15,2) NOT NULL,
    shipping_cost NUMERIC(12,2) DEFAULT 0,
    status transaction_status_type DEFAULT 'pending',
    shipping_address_id BIGINT REFERENCES addresses(id) ON DELETE SET NULL,
    shipping_address TEXT,
    phone_number VARCHAR(20),
    notes TEXT,
    payment_method payment_method_type,
    payment_status payment_status_type DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- ORDER ITEMS
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER CHECK (quantity > 0),
    price NUMERIC(15,2) CHECK (price >= 0),
    subtotal NUMERIC(15,2) GENERATED ALWAYS AS (quantity * price) STORED,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- REVIEWS
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    rating NUMERIC(2,1) CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- WISHLISTS
CREATE TABLE wishlists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE(user_id, product_id)
);

-- COUPONS
CREATE TABLE coupons (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    discount_type VARCHAR(10) CHECK (discount_type IN ('percent', 'fixed')),
    discount_value NUMERIC(10,2),
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    usage_limit INTEGER,
    used_count INTEGER DEFAULT 0
);

-- FUNCTION & TRIGGERS
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Tambahkan trigger untuk semua tabel yang memiliki `updated_at`
DO $$
DECLARE
    tbl TEXT;
BEGIN
    FOR tbl IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER trg_%I_updated_at
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
        ', tbl, tbl);
    END LOOP;
END;
$$;