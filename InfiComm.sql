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