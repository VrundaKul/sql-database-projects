-- ============================================================
-- TELECOM SUBSCRIBER & BILLING MANAGEMENT SYSTEM
-- Database Security, Access Control & Transaction Management
-- ============================================================

USE TelecomDB;

-- ============================================================
-- USER CREATION & ROLES
-- ============================================================

-- Create Admin User (Full Access)
-- CREATE USER 'telecom_admin'@'localhost' IDENTIFIED BY 'admin_password_123';
-- GRANT ALL PRIVILEGES ON TelecomDB.* TO 'telecom_admin'@'localhost' WITH GRANT OPTION;

-- Create Staff User (Limited Access - SELECT, INSERT, UPDATE)
-- CREATE USER 'telecom_staff'@'localhost' IDENTIFIED BY 'staff_password_456';
-- GRANT SELECT, INSERT, UPDATE ON TelecomDB.* TO 'telecom_staff'@'localhost';

-- Create Customer Service User (READ-ONLY for most tables, UPDATE Bills)
-- CREATE USER 'customer_service'@'localhost' IDENTIFIED BY 'cust_service_789';
-- GRANT SELECT ON TelecomDB.* TO 'customer_service'@'localhost';
-- GRANT UPDATE ON TelecomDB.Bills TO 'customer_service'@'localhost';
-- GRANT UPDATE ON TelecomDB.Complaints TO 'customer_service'@'localhost';

-- Create Billing User (Access to Bills and Payments)
-- CREATE USER 'billing_user'@'localhost' IDENTIFIED BY 'billing_password_101';
-- GRANT SELECT ON TelecomDB.Bills TO 'billing_user'@'localhost';
-- GRANT UPDATE ON TelecomDB.Bills TO 'billing_user'@'localhost';
-- GRANT INSERT ON TelecomDB.Bills TO 'billing_user'@'localhost';

-- Create Viewer User (READ-ONLY Access)
-- CREATE USER 'viewer_user'@'localhost' IDENTIFIED BY 'viewer_password_202';
-- GRANT SELECT ON TelecomDB.* TO 'viewer_user'@'localhost';

-- ============================================================
-- GRANT PRIVILEGES
-- ============================================================

-- Grant ALL privileges to Admin
-- GRANT ALL PRIVILEGES ON TelecomDB.* TO 'telecom_admin'@'localhost' WITH GRANT OPTION;

-- Grant SELECT and UPDATE on specific tables to Staff
-- GRANT SELECT, UPDATE ON TelecomDB.Customers TO 'telecom_staff'@'localhost';
-- GRANT SELECT, UPDATE ON TelecomDB.SIM_Cards TO 'telecom_staff'@'localhost';
-- GRANT SELECT, UPDATE ON TelecomDB.Subscriptions TO 'telecom_staff'@'localhost';

-- Grant SELECT and INSERT on Bills to Billing User
-- GRANT SELECT, INSERT ON TelecomDB.Bills TO 'billing_user'@'localhost';

-- ============================================================
-- REVOKE PRIVILEGES
-- ============================================================

-- Revoke INSERT privilege from Staff User
-- REVOKE INSERT ON TelecomDB.Bills FROM 'telecom_staff'@'localhost';

-- Revoke DELETE privilege from Customer Service User
-- REVOKE DELETE ON TelecomDB.* FROM 'customer_service'@'localhost';

-- Revoke all privileges from a user
-- REVOKE ALL PRIVILEGES ON TelecomDB.* FROM 'viewer_user'@'localhost';

-- ============================================================
-- VIEWS FOR DATA SECURITY & SIMPLIFIED ACCESS
-- ============================================================

-- View 1: Customer Summary View (Hide sensitive email)
CREATE VIEW v_customer_summary AS
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    phone_number,
    registration_date
FROM Customers;

-- View 2: Pending Bills Summary
CREATE VIEW v_pending_bills AS
SELECT
    b.customer_id,
    c.first_name,
    c.last_name,
    c.phone_number,
    b.total_amount,
    b.amount_paid,
    b.due_date,
    (b.total_amount - b.amount_paid) AS outstanding_amount
FROM Bills b
JOIN Customers c ON b.customer_id = c.customer_id
WHERE b.payment_status = 'Pending'
ORDER BY b.due_date;

-- View 3: Active Subscriptions View
CREATE VIEW v_active_subscriptions AS
SELECT
    s.subscription_id,
    s.customer_id,
    c.first_name,
    c.last_name,
    p.plan_name,
    p.monthly_cost,
    s.start_date,
    sc.activation_status
FROM Subscriptions s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Plans p ON s.plan_id = p.plan_id
JOIN SIM_Cards sc ON s.customer_id = sc.customer_id
WHERE s.is_active = TRUE;

-- View 4: Customer Complaints View
CREATE VIEW v_customer_complaints AS
SELECT
    comp.complaint_id,
    comp.customer_id,
    c.first_name,
    c.last_name,
    comp.subject,
    comp.status,
    comp.reported_date
FROM Complaints comp
JOIN Customers c ON comp.customer_id = c.customer_id;

-- View 5: Revenue Summary by Status
CREATE VIEW v_revenue_summary AS
SELECT
    payment_status,
    COUNT(*) AS bill_count,
    SUM(total_amount) AS total_billed,
    SUM(amount_paid) AS total_paid,
    AVG(total_amount) AS avg_bill_amount
FROM Bills
GROUP BY payment_status;

-- ============================================================
-- TRANSACTION MANAGEMENT & ACID COMPLIANCE
-- ============================================================

-- ============================================================
-- TRANSACTION 1: Monthly Bill Generation Transaction
-- ============================================================
-- This demonstrates ACID compliance for bill generation

DELIMITER $$

CREATE PROCEDURE GenerateMonthlyBill(IN customer_id_param INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error in bill generation';
    END;

    START TRANSACTION;
    
    -- Verify customer exists
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = customer_id_param) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer not found';
    END IF;

    -- Calculate usage cost
    DECLARE usage_cost DECIMAL(10, 2);
    SELECT SUM(cost) INTO usage_cost 
    FROM Usage_Records ur
    JOIN SIM_Cards sc ON ur.sim_id = sc.sim_id
    WHERE sc.customer_id = customer_id_param
    AND MONTH(ur.usage_timestamp) = MONTH(CURDATE())
    AND YEAR(ur.usage_timestamp) = YEAR(CURDATE());

    -- Insert new bill record
    INSERT INTO Bills (customer_id, billing_cycle_start, billing_cycle_end, due_date, 
                       total_amount, amount_paid, payment_status)
    VALUES (customer_id_param, 
            DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE())-1 DAY),
            LAST_DAY(CURDATE()),
            DATE_ADD(LAST_DAY(CURDATE()), INTERVAL 15 DAY),
            COALESCE(usage_cost, 0),
            0,
            'Pending');

    COMMIT;
END$$

DELIMITER ;

-- ============================================================
-- TRANSACTION 2: Payment Processing with Locking
-- ============================================================

DELIMITER $$

CREATE PROCEDURE ProcessPayment(IN bill_id_param INT, IN payment_amount DECIMAL(10, 2))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment processing failed';
    END;

    START TRANSACTION;

    -- Lock the bill record for exclusive access
    SELECT * FROM Bills WHERE bill_id = bill_id_param FOR UPDATE;

    -- Update bill payment status
    UPDATE Bills
    SET amount_paid = amount_paid + payment_amount,
        payment_status = CASE 
            WHEN (amount_paid + payment_amount) >= total_amount THEN 'Paid'
            WHEN (amount_paid + payment_amount) > 0 THEN 'Partial'
            ELSE 'Pending'
        END
    WHERE bill_id = bill_id_param;

    -- Log transaction
    INSERT INTO Transaction_Logs (customer_id, transaction_type, amount, transaction_date, status)
    SELECT customer_id, 'Payment', payment_amount, NOW(), 'Completed'
    FROM Bills WHERE bill_id = bill_id_param;

    COMMIT;
END$$

DELIMITER ;

-- ============================================================
-- SAVEPOINT EXAMPLE
-- ============================================================

-- BEGIN;
-- INSERT INTO Customers VALUES (...);
-- SAVEPOINT after_customer_insert;
-- INSERT INTO SIM_Cards VALUES (...);
-- SAVEPOINT after_sim_insert;
-- -- If an error occurs, rollback to specific savepoint
-- ROLLBACK TO SAVEPOINT after_customer_insert;
-- COMMIT;

-- ============================================================
-- CONSTRAINT CHECKS & DATA VALIDATION
-- ============================================================

-- Verify referential integrity
SELECT 
    'Orphaned SIM Cards' AS check_name,
    COUNT(*) AS issue_count
FROM SIM_Cards
WHERE customer_id NOT IN (SELECT customer_id FROM Customers);

-- Check for null values in critical fields
SELECT 
    'Null customer_id in SIM_Cards' AS check_name,
    COUNT(*) AS null_count
FROM SIM_Cards
WHERE customer_id IS NULL;

-- ============================================================
-- BACKUP & RECOVERY RECOMMENDATIONS
-- ============================================================

-- Recommended backup strategy:
-- 1. Full backup: Daily at 2:00 AM
-- 2. Incremental backup: Every 6 hours
-- 3. Transaction log backup: Every 1 hour
-- 4. Test restore procedures regularly

-- Example backup command (to be run in shell):
-- mysqldump -u telecom_admin -p TelecomDB > TelecomDB_backup_$(date +%Y%m%d_%H%M%S).sql

-- Example restore command (to be run in shell):
-- mysql -u telecom_admin -p TelecomDB < TelecomDB_backup_YYYYMMDD_HHMMSS.sql

-- ============================================================
-- AUDIT & LOGGING
-- ============================================================

-- Enable binary logging for recovery (in my.cnf):
-- log_bin = /var/log/mysql/mysql-bin.log
-- binlog_format = ROW
-- server-id = 1

-- Query to check transaction logs
SELECT
    transaction_id,
    customer_id,
    transaction_type,
    amount,
    transaction_date,
    status
FROM Transaction_Logs
ORDER BY transaction_date DESC
LIMIT 20;

-- ============================================================
-- End of Security Configuration
-- ============================================================
