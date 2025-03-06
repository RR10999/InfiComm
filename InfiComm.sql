CREATE DATABASE InfiComm;
USE InfiComm;
--alembic_version table
create table alembic_version (version_num VARCHAR(32) NOT NULL);
-- AMENITY TABLE
CREATE TABLE amenity (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), description TEXT, created_at date);
-- BILLING TABLE
CREATE TABLE billing (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, amount_due DECIMAL(10,2), status ENUM('paid', 'unpaid', 'pending') DEFAULT 'unpaid', due_date DATE, created_at date, FOREIGN KEY (user_id) REFERENCES user(id));
-- FEEDBACK TABLE   
CREATE TABLE feedback (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, comments TEXT, rating INT, created_at date, FOREIGN KEY (user_id) REFERENCES user(id));
-- PLAN TABLE
CREATE TABLE plan (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), price DECIMAL(10,2), validity INT, data_limit VARCHAR(50), created_at date);
-- SERVICE REQUEST TABLE
CREATE TABLE service_request (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, service_type VARCHAR(100), status ENUM('pending', 'in progress', 'resolved') DEFAULT 'pending', requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- SUBSCRIPTION HISTORY TABLE
CREATE TABLE subscription_history (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, plan_id INT, start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_date TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id), FOREIGN KEY (plan_id) REFERENCES plan(id));
-- SUPPORT TICKET TABLE
CREATE TABLE support_ticket (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT,  subject VARCHAR(100),message TEXT, status ENUM('open', 'in progress', 'resolved') DEFAULT 'open', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- TRANSACTIONS TABLE
CREATE TABLE transactions (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, transaction_type ENUM('bill', 'payment', 'recharge') NOT NULL, amount DECIMAL(10,2), date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- USAGE HISTORY TABLE
CREATE TABLE usage_history (usage_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT,data_used VARCHAR(50),call_minutes INT, messages_sent INT, date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- USER TABLE
CREATE TABLE user (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), email VARCHAR(100), phone VARCHAR(20), user_type ENUM('customer', 'admin') NOT NULL, password_hash VARCHAR(255), created_at date);
