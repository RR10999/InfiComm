CREATE DATABASE InfiComm;
USE InfiComm;
-- USER TABLE
CREATE TABLE user (user_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), email VARCHAR(100) UNIQUE, password_hash VARCHAR(255), phone VARCHAR(20), user_type ENUM('customer', 'admin') NOT NULL);
-- PLAN TABLE 
CREATE TABLE plan (plan_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), price DECIMAL(10,2), validity INT, data_limit VARCHAR(50), customer_id INT, FOREIGN KEY (customer_id) REFERENCES user(user_id));
-- TRANSACTIONS TABLE 
CREATE TABLE transactions (transaction_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, transaction_type ENUM('bill', 'payment', 'recharge') NOT NULL, amount DECIMAL(10,2), date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- AMENITY TABLE
CREATE TABLE amenity (amenity_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), description TEXT);
-- ROLE TABLE
CREATE TABLE role (role_id INT PRIMARY KEY AUTO_INCREMENT, role_name VARCHAR(50));
-- SUPPORT_TICKET TABLE
CREATE TABLE support_ticket (ticket_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, issue TEXT, status ENUM('open', 'in progress', 'resolved') DEFAULT 'open', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- NETWORK_TOWER TABLE
CREATE TABLE network_tower (tower_id INT PRIMARY KEY AUTO_INCREMENT, location VARCHAR(255), status ENUM('active', 'under maintenance', 'inactive') DEFAULT 'active');
-- USAGE_HISTORY TABLE
CREATE TABLE usage_history (usage_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, data_used VARCHAR(50), call_minutes INT, messages_sent INT, date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- SUBSCRIPTION_HISTORY TABLE
CREATE TABLE subscription_history (history_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, plan_id INT, start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_date TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id), FOREIGN KEY (plan_id) REFERENCES plan(plan_id));
-- DEVICE_INFO TABLE
CREATE TABLE device_info (device_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, device_name VARCHAR(100), imei VARCHAR(50) UNIQUE, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- NETWORK_COVERAGE TABLE
CREATE TABLE network_coverage (coverage_id INT PRIMARY KEY AUTO_INCREMENT, region VARCHAR(255), coverage_status ENUM('good', 'moderate', 'poor') DEFAULT 'good');
CREATE TABLE enrolled_plan (user_id INT,plan_id INT,enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (user_id, plan_id),FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,FOREIGN KEY (plan_id) REFERENCES plan(plan_id) ON DELETE CASCADE);


select*from plan;


NSERT INTO user (name, email, password_hash, phone, user_type) VALUES
('Amit Sharma', 'amit.sharma@mail.com', 'hashed_password1', '9812345670', 'customer'),
('Priya Verma', 'priya.verma@mail.com', 'hashed_password2', '9823456781', 'customer'),
('Rahul Singh', 'rahul.singh@mail.com', 'hashed_password3', '9834567892', 'customer'),
('Neha Gupta', 'neha.gupta@mail.com', 'hashed_password4', '9845678903', 'customer'),
('Vikram Joshi', 'vikram.joshi@mail.com', 'hashed_password5', '9856789014', 'customer'),
('Sneha Iyer', 'sneha.iyer@mail.com', 'hashed_password6', '9867890125', 'customer'),
('Rohit Mehta', 'rohit.mehta@mail.com', 'hashed_password7', '9878901236', 'customer'),
('Kiran Rao', 'kiran.rao@mail.com', 'hashed_password8', '9889012347', 'customer'),
('Suresh Kumar', 'suresh.kumar@mail.com', 'hashed_password9', '9890123458', 'customer'),
('Anjali Das', 'anjali.das@mail.com', 'hashed_password10', '9901234569', 'admin');

-- Insert Plans
INSERT INTO plan (name, price, validity, data_limit, customer_id) VALUES
('Basic Plan', 299.00, 30, '10GB', 1),
('Silver Plan', 499.00, 60, '50GB', 2),
('Gold Plan', 799.00, 90, '100GB', 3),
('Platinum Plan', 999.00, 120, '200GB', 4),
('Basic Plan', 299.00, 30, '10GB', 5),
('Silver Plan', 499.00, 60, '50GB', 6),
('Gold Plan', 799.00, 90, '100GB', 7),
('Platinum Plan', 999.00, 120, '200GB', 8),
('Basic Plan', 299.00, 30, '10GB', 9),
('Silver Plan', 499.00, 60, '50GB', 10);

-- Insert Transactions
INSERT INTO transactions (user_id, transaction_type, amount, date) VALUES
(1, 'bill', 500.00, NOW()),
(2, 'payment', 700.00, NOW()),
(3, 'recharge', 399.00, NOW()),
(4, 'bill', 1000.00, NOW()),
(5, 'payment', 800.00, NOW()),
(6, 'recharge', 1299.00, NOW()),
(7, 'bill', 299.00, NOW()),
(8, 'payment', 499.00, NOW()),
(9, 'recharge', 599.00, NOW()),
(10, 'bill', 1200.00, NOW());

-- Insert Amenities
INSERT INTO amenity (name, description) VALUES
('WiFi', 'High-speed broadband connection'),
('Call Support', '24/7 customer support'),
('Roaming', 'Free roaming across India'),
('Streaming', 'Unlimited OTT subscriptions'),
('Family Plan', 'Shared data for multiple users'),
('Gaming Mode', 'Low latency for gaming'),
('Corporate Plan', 'Custom plans for businesses'),
('Free SMS', 'Unlimited SMS pack'),
('Caller Tune', 'Custom caller tunes available'),
('Emergency Data', 'Emergency data top-up option');

-- Insert Roles
INSERT INTO role (role_name) VALUES
('Admin'),
('Customer Support'),
('Technical Support'),
('User');

-- Insert Support Tickets
INSERT INTO support_ticket (user_id, issue, status, created_at) VALUES
(1, 'Internet speed slow', 'open', NOW()),
(2, 'Bill not generated', 'resolved', NOW()),
(3, 'Payment failed', 'in progress', NOW()),
(4, 'Service not activated', 'open', NOW()),
(5, 'SIM not working', 'resolved', NOW()),
(6, 'Network issues', 'in progress', NOW()),
(7, 'Plan details incorrect', 'resolved', NOW()),
(8, 'Roaming not activated', 'open', NOW()),
(9, 'Customer support not responsive', 'resolved', NOW()),
(10, 'Call drops frequently', 'in progress', NOW());

-- Insert Network Coverage
INSERT INTO network_coverage (region, coverage_status) VALUES
('Delhi', 'good'),
('Mumbai', 'moderate'),
('Bangalore', 'good'),
('Kolkata', 'poor'),
('Chennai', 'moderate'),
('Hyderabad', 'good'),
('Pune', 'moderate'),
('Jaipur', 'poor'),
('Lucknow', 'good'),
('Ahmedabad', 'good');

-- Insert Device Info
INSERT INTO device_info (user_id, device_name, imei) VALUES
(1, 'iPhone 13', '352093095462001'),
(2, 'Samsung S22', '358972106849320'),
(3, 'OnePlus 10', '358736081234567'),
(4, 'Redmi Note 11', '357836124589763'),
(5, 'Realme GT', '359873014728901'),
(6, 'Oppo Reno', '352657893104867'),
(7, 'Vivo X80', '354789562314678'),
(8, 'Google Pixel 7', '355098723456890'),
(9, 'Nokia XR20', '353847091234567'),
(10, 'Motorola Edge', '352091478560012');

-- Insert Subscription History
INSERT INTO subscription_history (user_id, plan_id, start_date, end_date) VALUES
(1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
(2, 2, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY)),
(3, 3, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY)),
(4, 4, NOW(), DATE_ADD(NOW(), INTERVAL 120 DAY)),
(5, 5, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
(6, 6, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY)),
(7, 7, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY)),
(8, 8, NOW(), DATE_ADD(NOW(), INTERVAL 120 DAY)),
(9, 9, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
(10, 10, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY));


-- Insert Network Towers
INSERT INTO network_tower (location, status) VALUES
('Delhi - Connaught Place', 'active'),
('Mumbai - Bandra', 'under maintenance'),
('Bangalore - Whitefield', 'active'),
('Kolkata - Salt Lake', 'inactive'),
('Chennai - T Nagar', 'active'),
('Hyderabad - Gachibowli', 'active'),
('Pune - Hinjewadi', 'under maintenance'),
('Jaipur - Malviya Nagar', 'active'),
('Lucknow - Gomti Nagar', 'inactive'),
('Ahmedabad - Satellite', 'active');

-- Insert Usage History
INSERT INTO usage_history (user_id, data_used, call_minutes, messages_sent, date) VALUES
(1, '2GB', 100, 50, NOW()),
(2, '1.5GB', 80, 40, NOW()),
(3, '3GB', 120, 60, NOW()),
(4, '2.5GB', 90, 30, NOW()),
(5, '1GB', 70, 20, NOW()),
(6, '2.2GB', 110, 45, NOW()),
(7, '1.8GB', 95, 35, NOW()),
(8, '2.7GB', 130, 70, NOW()),
(9, '3.5GB', 150, 80, NOW()),
(10, '2GB', 100, 50, NOW());

-- Insert Enrolled Plans (Users can have multiple plans)
INSERT INTO enrolled_plan (user_id, plan_id, enrollment_date) VALUES
(1, 1, NOW()),
(1, 3, NOW()),
(2, 2, NOW()),
(2, 4, NOW()),
(3, 3, NOW()),
(4, 1, NOW()),
(5, 2, NOW()),
(6, 4, NOW()),
(7, 3, NOW()),
(8, 1, NOW());
