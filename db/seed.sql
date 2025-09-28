INSERT INTO products (product_name, category, price) VALUES
('Shoes', 'Fashion', 50.00),
('Bags', 'Fashion', 80.00),
('Laptop', 'Electronics', 1000.00),
('Phone', 'Electronics', 600.00),
('Watch', 'Accessories', 150.00),
('Headphones', 'Electronics', 120.00),
('Sunglasses', 'Accessories', 90.00),
('Jacket', 'Fashion', 200.00),
('Smartwatch', 'Electronics', 250.00),
('Backpack', 'Fashion', 60.00);

INSERT INTO customers (customer_name, region) VALUES
('Amit', 'North'),
('Priya', 'South'),
('Raj', 'East'),
('Sneha', 'West'),
('Karan', 'North'),
('Neha', 'South'),
('Vikram', 'East'),
('Anjali', 'West'),
('Rohit', 'North'),
('Simran', 'South');

INSERT INTO transactions (product_id, customer_id, amount, transaction_date) VALUES
(1, 1, 100.00, '2025-01-10'),
(2, 2, 80.00, '2025-01-12'),
(3, 3, 1000.00, '2025-01-15'),
(4, 4, 600.00, '2025-01-20'),
(5, 5, 150.00, '2025-01-25'),
(1, 2, 50.00, '2025-02-05'),
(3, 1, 2000.00, '2025-02-10'),
(2, 3, 160.00, '2025-02-15'),
(4, 4, 1200.00, '2025-02-18'),
(5, 5, 300.00, '2025-02-22'),
(6, 6, 120.00, '2025-03-01'),
(7, 7, 90.00, '2025-03-03'),
(8, 8, 200.00, '2025-03-05'),
(9, 9, 250.00, '2025-03-07'),
(10, 10, 60.00, '2025-03-10'),
(3, 6, 1000.00, '2025-03-12'),
(4, 7, 600.00, '2025-03-15'),
(1, 8, 50.00, '2025-03-18'),
(2, 9, 80.00, '2025-03-20'),
(5, 10, 150.00, '2025-03-22');



-- Suppliers
INSERT INTO suppliers (supplier_name, region) VALUES
('Alpha Suppliers', 'North'),
('Beta Traders', 'South'),
('Gamma Corp', 'East'),
('Delta Ltd', 'West');

-- Promotions
INSERT INTO promotions (product_id, promo_name, discount_percent, start_date, end_date) VALUES
(3, 'Laptop Summer Sale', 10.00, '2025-06-01', '2025-06-30'),
(5, 'Watch Fest', 15.00, '2025-07-01', '2025-07-15'),
(8, 'Jacket Discount', 20.00, '2025-08-01', '2025-08-20');

-- Inventory
INSERT INTO inventory (product_id, stock_quantity, reorder_point) VALUES
(1, 100, 20),
(2, 50, 10),
(3, 30, 5),
(4, 40, 10),
(5, 60, 15),
(6, 80, 20),
(7, 70, 15),
(8, 25, 5),
(9, 35, 10),
(10, 50, 10);

-- Returns
INSERT INTO returns (transaction_id, return_date, amount, reason) VALUES
(1, '2025-01-15', 50.00, 'Damaged'),
(3, '2025-01-20', 500.00, 'Customer changed mind'),
(6, '2025-02-15', 60.00, 'Wrong product'),
(9, '2025-02-20', 80.00, 'Late delivery');



-- Messy Products
INSERT INTO prodcts (prod_name, Category, Price) VALUES
('Laptop', 'Electronics', 1000),
('phone', 'Electronics', 600),  -- lowercase product name
('Shoes', NULL, 50),            -- missing category
('Watch', 'accessories', 150),  -- lowercase category
('Bags', 'Fashion', 80);

-- Messy Customers
INSERT INTO custmrs (cust_name, region) VALUES
('Amit', 'north'),  -- lowercase
('Priya', 'South'),
('Raj', NULL),      -- missing region
('Sneha', 'West'),
('Karan', 'North');

-- Messy Transactions
INSERT INTO transctns (product_id, customer_id, amount, transaction_date, extra_col) VALUES
(1, 1, 100, '2025-01-10', 'N/A'),
(2, 2, 80, '2025-01-12', NULL),
(3, 3, 1000, '2025-01-15', 'unknown'),
(4, 4, 600, '2025-01-20', 'N/A'),
(5, 5, 150, '2025-01-25', 'none'),
(1, 2, 50, '2025-02-05', NULL),
(3, 1, 2000, '2025-02-10', 'N/A');
