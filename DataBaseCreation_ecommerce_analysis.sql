CREATE DATABASE Ecommerce_SQL_Database;
USE Ecommerce_SQL_Database;
-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    country VARCHAR(50)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Insert customers
INSERT INTO customers VALUES 
(1, 'John Doe', 'john@example.com', '2023-01-15', 'USA'),
(2, 'Jane Smith', 'jane@example.com', '2023-02-20', 'UK'),
(3, 'Bob Johnson', 'bob@example.com', '2023-03-10', 'Canada');

-- Insert products
INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 999.99, 50),
(102, 'Smartphone', 'Electronics', 699.99, 100),
(103, 'Desk Chair', 'Furniture', 149.99, 30);

-- Insert orders
INSERT INTO orders VALUES
(1001, 1, '2023-04-05', 999.99),
(1002, 2, '2023-04-06', 849.98),
(1003, 1, '2023-04-07', 299.98);

-- Insert order items
INSERT INTO order_items VALUES
(1, 1001, 101, 1, 999.99),
(2, 1002, 102, 1, 699.99),
(3, 1002, 103, 1, 149.99),
(4, 1003, 103, 2, 149.99);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;