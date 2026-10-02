-- ============================================================
-- TELECOM SUBSCRIBER & BILLING MANAGEMENT SYSTEM
-- Database Schema Definition (DDL)
-- ============================================================
-- Database: TelecomDB
-- Description: A comprehensive database system for managing
--              subscribers, SIM cards, plans, usage, billing,
--              and complaints in a telecom domain
-- ============================================================

-- Create Database
CREATE DATABASE TelecomDB;
USE TelecomDB;

-- ============================================================
-- TABLE: Customers (Subscribers)
-- ============================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    registration_date DATE NOT NULL
);

-- ============================================================
-- TABLE: Plans
-- ============================================================
CREATE TABLE Plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    monthly_cost INT NOT NULL,
    data_limit_gb INT,  -- NULL for unlimited
    call_minutes_limit INT  -- NULL for unlimited
);

-- ============================================================
-- TABLE: SIM Cards
-- ============================================================
CREATE TABLE SIM_Cards (
    sim_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    iccid VARCHAR(20) UNIQUE,
    activation_status ENUM('Pending', 'Active', 'Inactive', 'Suspended') NOT NULL,
    activation_date DATE,
    line_type ENUM('Prepaid', 'Postpaid') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE: Subscriptions
-- ============================================================
CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    sim_serial_number VARCHAR(20) UNIQUE,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    account_type ENUM('Prepaid', 'Postpaid') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id)
);

-- ============================================================
-- TABLE: Usage Records
-- ============================================================
CREATE TABLE Usage_Records (
    usage_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sim_id INT,
    usage_type ENUM('Call', 'Data', 'SMS') NOT NULL,
    usage_timestamp DATETIME NOT NULL,
    duration_seconds INT NULL,  -- For calls/SMS
    data_used_mb DECIMAL(10, 2) NULL,  -- For data
    cost DECIMAL(10, 4) DEFAULT 0.0000,
    FOREIGN KEY (sim_id) REFERENCES SIM_Cards(sim_id)
);

-- ============================================================
-- TABLE: Bills
-- ============================================================
CREATE TABLE Bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    billing_cycle_start DATE NOT NULL,
    billing_cycle_end DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    amount_paid DECIMAL(10, 2) DEFAULT 0.00,
    payment_status ENUM('Pending', 'Paid', 'Partial', 'Overdue') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE: Complaints
-- ============================================================
CREATE TABLE Complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    sim_id INT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('New', 'In Progress', 'Resolved', 'Closed') NOT NULL,
    reported_date DATETIME NOT NULL,
    resolution_date DATETIME,
    resolution_notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (sim_id) REFERENCES SIM_Cards(sim_id)
);

-- ============================================================
-- TABLE: Employees
-- ============================================================
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    position VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- ============================================================
-- TABLE: Network Areas
-- ============================================================
CREATE TABLE Network_Areas (
    area_id INT PRIMARY KEY AUTO_INCREMENT,
    area_name VARCHAR(100),
    coverage_type ENUM('Urban', 'Rural', 'Suburban'),
    network_quality VARCHAR(50)
);

-- ============================================================
-- TABLE: Notifications
-- ============================================================
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    notification_type VARCHAR(100),
    message TEXT,
    sent_date DATETIME,
    read_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE: Transaction Logs
-- ============================================================
CREATE TABLE Transaction_Logs (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    transaction_type VARCHAR(50),
    amount DECIMAL(10, 2),
    transaction_date DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- ============================================================
-- INDEXES for Performance Optimization
-- ============================================================
CREATE INDEX idx_customer_phone ON Customers(phone_number);
CREATE INDEX idx_sim_customer ON SIM_Cards(customer_id);
CREATE INDEX idx_subscription_customer ON Subscriptions(customer_id);
CREATE INDEX idx_usage_sim ON Usage_Records(sim_id);
CREATE INDEX idx_usage_timestamp ON Usage_Records(usage_timestamp);
CREATE INDEX idx_bill_customer ON Bills(customer_id);
CREATE INDEX idx_bill_status ON Bills(payment_status);
CREATE INDEX idx_complaint_customer ON Complaints(customer_id);
CREATE INDEX idx_complaint_status ON Complaints(status);

-- ============================================================
-- End of Schema Definition
-- ============================================================
