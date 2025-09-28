CREATE DATABASE IF NOT EXISTS sales_db;
USE sales_db;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    amount DECIMAL(10,2),
    transaction_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    promo_name VARCHAR(100),
    discount_percent DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE returns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    return_date DATE,
    amount DECIMAL(10,2),
    reason VARCHAR(200),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT,
    reorder_point INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- Products table with messy columns
CREATE TABLE prodcts (  -- typo in table name
    id INT AUTO_INCREMENT PRIMARY KEY,
    prod_name VARCHAR(100) NOT NULL,  -- inconsistent column name
    Category VARCHAR(50),              -- capital C
    Price DECIMAL(10,2)
);

-- Customers table with missing region sometimes
CREATE TABLE custmrs (  -- typo in table name
    id INT AUTO_INCREMENT PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) DEFAULT NULL
);

-- Transactions with extra unnamed column
CREATE TABLE transctns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    amount DECIMAL(10,2),
    transaction_date DATE,
    extra_col VARCHAR(50),  -- irrelevant / messy column
    FOREIGN KEY (product_id) REFERENCES prodcts(id),
    FOREIGN KEY (customer_id) REFERENCES custmrs(id)
);

