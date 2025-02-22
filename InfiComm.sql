CREATE DATABASE InfiComm;
USE InfiComm;

-- 1. User Table
CREATE TABLE user (user_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, contact VARCHAR (15), address TEXT, date_registered DATE);
-- 2. Customer Table
CREATE TABLE customer (customer_id INT AUTO_INCREMENT PRIMARY KEY,user_id INT UNIQUE NOT NULL,dob DATE,gender ENUM('Male', 'Female', 'Other'),national_id VARCHAR(50) UNIQUE NOT NULL, customer_type ENUM('Individual', 'Business'),FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE);
-- 3. Plan Table
CREATE TABLE plan (plan_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,price DECIMAL(10,2) NOT NULL,validity_days INT NOT NULL, data_limit INT, call_minutes INT, sms_limit INT);
-- 4. Enrolled Plans Table
CREATE TABLE enrolled_plan (enrollment_id INT PRIMARY KEY, customer_id INT NOT NULL, plan_id INT NOT NULL, start_date DATE NOT NULL,end_date DATE NOT NULL,status ENUM('Active', 'Inactive') DEFAULT 'Active', FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE, FOREIGN KEY (plan_id) REFERENCES plan(plan_id) ON DELETE CASCADE);
-- 5. Amenity Table
CREATE TABLE amenity (amenity_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, description TEXT, price DECIMAL(10,2) NOT NULL);
-- 6. Customer Amenities Table
CREATE TABLE customer_amenity (customer_amenity_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, amenity_id INT NOT NULL, activation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, status ENUM('Active', 'Inactive') DEFAULT 'Active', FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE, FOREIGN KEY (amenity_id) REFERENCES amenity(amenity_id) ON DELETE CASCADE);
-- 7. Billing Table
CREATE TABLE bill (bill_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, amount DECIMAL(10,2) NOT NULL, billing_date DATE NOT NULL, due_date DATE NOT NULL, status ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid', FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE);
-- 8. Payment Table
CREATE TABLE payment (payment_id INT AUTO_INCREMENT PRIMARY KEY, bill_id INT NOT NULL, payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash') NOT NULL, amount_paid DECIMAL(10,2) NOT NULL, payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (bill_id) REFERENCES bill(bill_id) ON DELETE CASCADE);
-- 9. Traffic Table
CREATE TABLE traffic (traffic_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, data_used DECIMAL(10,2), calls_made INT, sms_sent INT, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE);
-- 10. Customer Support Table
CREATE TABLE support_ticket (ticket_id INT PRIMARY KEY, customer_id INT NOT NULL, issue_description TEXT NOT NULL, status ENUM('Open', 'Resolved') DEFAULT 'Open', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, resolved_at TIMESTAMP NULL, FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE);
-- 11. Recharge History Table
CREATE TABLE recharge (recharge_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, plan_id INT NOT NULL, amount DECIMAL(10,2) NOT NULL, recharge_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash') NOT NULL, FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE, FOREIGN KEY (plan_id) REFERENCES plan(plan_id) ON DELETE CASCADE);
-- 12. Role Table
CREATE TABLE role (role_id INT AUTO_INCREMENT PRIMARY KEY, role_name VARCHAR(50) NOT NULL UNIQUE, description TEXT);
-- 13. User Roles Table
CREATE TABLE user_role (user_role_id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, role_id INT NOT NULL, assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,  FOREIGN KEY (role_id) REFERENCES role(role_id) ON DELETE CASCADE);
-- 14. Network Tower Table
CREATE TABLE network_tower (tower_id INT PRIMARY KEY, location VARCHAR(255) NOT NULL, coverage_area VARCHAR(255), status ENUM('Active', 'Inactive') DEFAULT 'Active');
-- 15. Service Requests Table
CREATE TABLE service_request (request_id INT PRIMARY KEY, customer_id INT NOT NULL, service_type ENUM('Broadband', 'SIM Activation', 'Plan Change', 'Technical Support') NOT NULL, status ENUM('Pending', 'In Progress', 'Resolved') DEFAULT 'Pending', requested_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, resolved_date TIMESTAMP NULL, FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE);
