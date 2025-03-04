CREATE DATABASE InfiComm;
USE InfiComm;
--alembic_version table
create table alembic_version (version_num VARCHAR(32) NOT NULL);
-- AMENITY TABLE
CREATE TABLE amenity (amenity_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), description TEXT);USE InfiComm;
-- BILLING TABLE
CREATE TABLE billing (billing_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, amount_due DECIMAL(10,2), due_date DATE, status ENUM('paid', 'unpaid', 'pending') DEFAULT 'unpaid', FOREIGN KEY (user_id) REFERENCES user(user_id));
-- FEEDBACK TABLE   
CREATE TABLE feedback (feedback_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, comments TEXT, rating INT, submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- PLAN TABLE
CREATE TABLE plan (plan_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), price DECIMAL(10,2), validity INT, data_limit VARCHAR(50), customer_id INT, FOREIGN KEY (customer_id) REFERENCES user(user_id));
-- SERVICE REQUEST TABLE
CREATE TABLE service_request (request_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, service_type VARCHAR(100), status ENUM('pending', 'in progress', 'resolved') DEFAULT 'pending', requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- SUBSCRIPTION HISTORY TABLE
CREATE TABLE subscription_history (history_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, plan_id INT, start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_date TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id), FOREIGN KEY (plan_id) REFERENCES plan(plan_id));
-- SUPPORT TICKET TABLE
CREATE TABLE support_ticket (ticket_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT,  subject VARCHAR(100),issue TEXT, status ENUM('open', 'in progress', 'resolved') DEFAULT 'open', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- TRANSACTIONS TABLE
CREATE TABLE transactions (transaction_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, transaction_type ENUM('bill', 'payment', 'recharge') NOT NULL, amount DECIMAL(10,2), date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- USAGE HISTORY TABLE
CREATE TABLE usage_history (usage_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, data_used VARCHAR(50), call_minutes INT, messages_sent INT, date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id));
-- USER TABLE
CREATE TABLE user (user_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), email VARCHAR(100), password_hash VARCHAR(255), phone VARCHAR(20), user_type ENUM('customer', 'admin') NOT NULL);drop database InfiComm;


desc amenity;
desc billing;
desc feedback;
desc plan;
desc service_request;
desc subscription_history;
desc support_ticket;
desc transactions;
desc usage_history;
desc user;



