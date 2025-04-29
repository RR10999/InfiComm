CREATE DATABASE InfiComm;
USE InfiComm;
--alembic_version table
create table alembic_version (version_num VARCHAR(32) NOT NULL);\
-- AMENITY TABLE

CREATE TABLE amenity (amenity_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), description TEXT, created_at date);
-- BILLING TABLE
CREATE TABLE billing (billing_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, amount_due DECIMAL(10,2), status ENUM('paid', 'unpaid', 'pending') DEFAULT 'unpaid', due_date DATE, created_at date, FOREIGN KEY (user_id) REFERENCES user(id));
-- FEEDBACK TABLE   
CREATE TABLE feedback (feedback_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, comments TEXT, rating INT, created_at date, FOREIGN KEY (user_id) REFERENCES user(id));
-- PLAN TABLE
CREATE TABLE plan (plan_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), price DECIMAL(10,2), validity INT, data_limit VARCHAR(50), created_at date);
-- SERVICE REQUEST TABLE
CREATE TABLE service_request (service_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, service_type VARCHAR(100), status ENUM('pending', 'in progress', 'resolved') DEFAULT 'pending', requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- SUBSCRIPTION HISTORY TABLE
CREATE TABLE subscription_history (subscription_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, plan_id INT, start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_date TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(user_id), FOREIGN KEY (plan_id) REFERENCES plan(id));
-- SUPPORT TICKET TABLE
CREATE TABLE support_ticket (support_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT,  subject VARCHAR(100),message TEXT, status ENUM('open', 'in progress', 'resolved') DEFAULT 'open', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- TRANSACTIONS TABLE
CREATE TABLE transactions (transactions_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, transaction_type ENUM('bill', 'payment', 'recharge') NOT NULL, amount DECIMAL(10,2), date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- USAGE HISTORY TABLE
CREATE TABLE usage_history (usage_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT,data_used VARCHAR(50),usage_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES user(id));
-- USER TABLE
CREATE TABLE user (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), email VARCHAR(100), phone VARCHAR(20), user_type ENUM('customer', 'admin') NOT NULL, created_at date);

SHOW TABLES;

DESC AMENITY;
DESC BILLING;
DESC FEEDBACK;
DESC PLAN;
DESC SERVICE_REQUEST;
DESC SUBSCRIPTION_HISTORY;
DESC SUPPORT_TICKET;
DESC TRANSACTIONS;
DESC USAGE_HISTORY;
DESC USER;

SELECT * FROM AMENITY;
SELECT * FROM BILLING;
SELECT * FROM FEEDBACK;
SELECT * FROM PLAN;
SELECT * FROM SERVICE_REQUEST;
SELECT * FROM SUBSCRIPTION_HISTORY;
SELECT * FROM SUPPORT_TICKET;
SELECT * FROM TRANSACTIONS;
SELECT * FROM USAGE_HISTORY;
SELECT * FROM USER;

<<<<<<< HEAD
SET FOREIGN_KEY_CHECKS = 0;
=======
SET FOREIGN_KEY_CHECKS = 1;
>>>>>>> f99348de9040c78820b12b9e7c9b83ae8fad816e

ALTER TABLE user ADD CONSTRAINT unique_email UNIQUE (email); -- Allows only Unique Mail
ALTER TABLE user ADD CONSTRAINT chk_phone CHECK (LENGTH(phone) >= 10); -- Checks if Phone Number = 10
ALTER TABLE feedback ADD CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5); -- Ensures valid feedback rating
ALTER TABLE transactions ADD CONSTRAINT chk_amount CHECK (amount > 0); --Ensures that Amount is +ve
ALTER TABLE transactions MODIFY COLUMN transaction_type SET('bill', 'payment', 'recharge');

--Retrieve users and their feedback
SELECT u.name, f.comments, f.rating, f.created_at
FROM user u
JOIN feedback f ON u.id = f.user_id;

--Get all unresolved support tickets with user details
SELECT u.name, s.subject, s.message, s.status, s.created_at
FROM user u
JOIN support_ticket s ON u.id = s.user_id
WHERE s.status IN ('open', 'in progress');

--Get transaction details along with user name
SELECT u.name, t.transaction_type, t.amount, t.date
FROM user u
JOIN transactions t ON u.id = t.user_id;

--Retrieve data usage history for all user
SELECT u.name, uh.data_used, uh.usage_date
FROM user u
JOIN usage_history uh ON u.id = uh.user_id;

--Create a view for user transactions summary
CREATE VIEW transaction_summary AS
SELECT u.id AS user_id, u.name, t.transaction_type, t.amount, t.date
FROM user u
JOIN transactions t ON u.id = t.user_id;
SELECT * FROM transaction_summary;

--Create a view for user feedback
DELIMITER //
CREATE VIEW user_feedback AS
SELECT u.name, f.comments, f.rating, f.created_at
FROM user u
JOIN feedback f ON u.id = f.user_id;
SELECT * FROM user_feedback;

--Trigger for Creating Support Ticket if Rating in Feedback <=2
CREATE TRIGGER after_feedback_inserts
AFTER INSERT ON feedback
FOR EACH ROW
BEGIN
    IF NEW.rating <= 2 THEN
        INSERT INTO support_ticket (user_id, subject, message, status, created_at)
        VALUES (NEW.user_id, 'Poor Feedback Alert', 'User has given a low rating.', 'open', NOW());
    END IF;
END;
//

--Trigger for Not Allowing User to Delete their Account if they have Pay Due
DELIMITER //
CREATE TRIGGER before_user_delete_billing_check
BEFORE DELETE ON user
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM billing 
        WHERE user_id = OLD.id AND status = 'pending'
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot delete user with pending billing records';
    END IF;
END;
//
<<<<<<< HEAD
SHOW TRIGGERS;

INSERT INTO user (id, name, email, phone, user_type, created_at) 
VALUES (462, 'John Doe', 'john123@example.com',123456789,'customer',"2024-01-02");

INSERT INTO user (id, name, email, phone, user_type, created_at) 
VALUES (463, 'Rahul Sharma', 'rahul.sharma123@gmail.com',123456789,'customer',"2024-01-02");

INSERT INTO feedback (feedback_id, user_id, comments, rating, created_at)
VALUES (279, 1, "Amazing Network", 6, "2025-03-06 10:20:00");

INSERT INTO feedback (feedback_id, user_id, comments, rating, created_at)
VALUES (279, 1, "Poor Network", 1, "2025-03-06 10:20:00");

INSERT INTO transactions (transactions_id, user_id, transaction_type, amount, date)
VALUES (246,1,"recharge",-399,"2025-01-05");

INSERT INTO transactions (transactions_id, user_id, transaction_type, amount, date)
VALUES (246,1,"recharge",399.00,"2025-01-05");

DELETE FROM user WHERE id = 1;

--Trigger Feedback--
INSERT INTO feedback (feedback_id, user_id, comments, rating, created_at) 
VALUES (423, 2, "Pathetic Service", 1, "2025-01-07");
SELECT * FROM support_ticket WHERE user_id = 4;

--Trigger Delete Account
INSERT INTO billing (billing_id, user_id, amount_due, status, due_date, created_at)
VALUES (952, 338, 4040.64, 'pending', CURDATE(), CURDATE());
DELETE FROM user WHERE id = 336;
 SELECT * FROM BILLING;

-- Adds an 'address' column to the 'user' table, potentially leading to redundancy if address data is also stored elsewhere.
ALTER TABLE user ADD COLUMN address VARCHAR(255);

-- Creates an index on the 'user_id' column in the 'billing' table to improve query performance for searches involving 'user_id'.
CREATE INDEX idx_user_id ON billing(user_id);
SHOW INDEX FROM billing;
=======
    
SHOW TRIGGERS;
>>>>>>> f99348de9040c78820b12b9e7c9b83ae8fad816e
