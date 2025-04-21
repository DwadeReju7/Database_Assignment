DROP TABLE IF EXISTS order_items, orders, products, categories, customers;

-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Categories Table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Items Table (Many-to-Many join table)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- Insert sample customers
INSERT INTO customers (name, email)
VALUES 
    ('Tasha Carter', 'tasha@example.com'),
	('Jimmy Johnson', 'jimme@example.com'),
    ('Jordan Miles', 'jordan@example.com');

-- Insert sample categories
INSERT INTO categories (category_name)
VALUES 
    ('Electronics'),
    ('Books');

-- Insert sample products
INSERT INTO products (product_name, price, category_id)
VALUES 
    ('Laptop', 1200.00, 1),
    ('E-Reader', 99.99, 1),
    ('Novel', 15.00, 2);

-- Insert sample orders
INSERT INTO orders (customer_id)
VALUES 
    (1), -- Tasha
	(2), -- Jimmy
    (3); -- Jordan
	

-- Insert order items (products in each order)
INSERT INTO order_items (order_id, product_id, quantity)
VALUES 
    (1, 1, 1),  -- Order 1, Laptop
    (1, 3, 2),  -- Order 1, 2 Novels
    (2, 2, 1),  -- Order 2, E-Reader
	(3, 2, 1);  -- Order 3, E-Reader


SELECT 
    customers.name AS customer_name,
    orders.order_id,
    orders.order_date,
    products.product_name,
    order_items.quantity
FROM order_items
JOIN orders ON order_items.order_id = orders.order_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON order_items.product_id = products.product_id;
