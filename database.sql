-- 1. CREATE DATABASE
CREATE DATABASE cms_db;
USE cms_db;

-- 2. CREATE TABLES
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100)
);

CREATE TABLE food_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(50),
    price DECIMAL(8,2),
    category VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    item_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES food_items(item_id)
);

-- 3. INSERT SAMPLE DATA
INSERT INTO customers (name, phone, email) VALUES
('Rohit Kumar', '9876543210', 'rohit@gmail.com'), 
('Priya Sharma', '9123456789', 'priya@gmail.com'), 
('Mayank Nagar', '9998887776', 'mayank@gmail.com');

INSERT INTO food_items (item_name, price, category) VALUES 
('Veg Sandwich', 40.00, 'Snacks'), 
('Masala Dosa', 60.00, 'South Indian'),
('Cold Coffee', 50.00, 'Beverage'),
('Chhole Bhature', 70.00, 'North Indian'),
('French Fries', 45.00, 'Snacks');

-- 4. FUNCTIONS + STORED PROCEDURES
DELIMITER $$
CREATE FUNCTION get_item_price(f_item_id INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE price_val DECIMAL(10,2);
    SELECT price INTO price_val FROM food_items WHERE item_id = f_item_id; 
    RETURN price_val;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_new_order(IN cust_id INT)
BEGIN
    INSERT INTO orders (customer_id, order_date, total_amount) VALUES (cust_id, NOW(), 0.00);
    SELECT LAST_INSERT_ID() AS new_order_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE add_item_to_order(IN p_order_id INT, IN p_item_id INT, IN p_qty INT)
BEGIN
    DECLARE price DECIMAL (10,2);
    DECLARE total DECIMAL(10,2);
    SET price = get_item_price(p_item_id);
    SET total = price * p_qty;
    INSERT INTO order_details (order_id, item_id, quantity, item_total)
    VALUES (p_order_id, p_item_id, p_qty, total);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_order_total(IN p_order_id INT)
BEGIN
    DECLARE final_total DECIMAL(10,2);
    SELECT SUM(item_total) INTO final_total FROM order_details WHERE order_id = p_order_id;
    UPDATE orders SET total_amount = final_total WHERE order_id = p_order_id;
    SELECT final_total AS Final_Bill;
END $$
DELIMITER ;
