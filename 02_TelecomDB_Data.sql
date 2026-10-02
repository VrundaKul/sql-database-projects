-- ============================================================
-- TELECOM SUBSCRIBER & BILLING MANAGEMENT SYSTEM
-- Database Population (DML) - Sample Data
-- ============================================================

USE TelecomDB;

-- ============================================================
-- INSERT: Customers
-- ============================================================
INSERT INTO Customers (first_name, last_name, phone_number, email, address, registration_date) VALUES
(1, 'Charles', 'Davis', '9876543211', 'charles.d@example.net', '301 Pine Ln, City C', '2025-01-20'),
(2, 'Diana', 'Evans', '9876543212', 'diana.e@example.com', '402 Elm Rd, City D', '2025-01-25'),
(3, 'Frank', 'Green', '9876543213', 'frank.g@example.org', '503 Birch Ave, City E', '2025-02-05'),
(4, 'Grace', 'Hall', '9876543214', 'grace.h@example.net', '604 Cedar Dr, City F', '2025-02-10'),
(5, 'Henry', 'Ito', '9876543215', 'henry.i@example.com', '705 Walnut St, City G', '2025-02-15'),
(6, 'Ivy', 'Jones', '9876543216', 'ivy.j@example.org', '806 Willow Ct, City H', '2025-02-20'),
(7, 'Jack', 'Klein', '9876543217', 'jack.k@example.net', '907 Spruce Blvd, City I', '2025-03-01'),
(8, 'Karen', 'Lee', '9876543218', 'karen.l@example.com', '108 Ash St, City J', '2025-03-05'),
(9, 'Liam', 'Miller', '9876543219', 'liam.m@example.org', '209 Poplar Ln, City K', '2025-03-10'),
(10, 'Mia', 'Nava', '9876543220', 'mia.n@example.net', '310 Fir Rd, City L', '2025-03-15'),
(11, 'Noah', 'Owens', '9876543221', 'noah.o@example.com', '411 Cypress Ave, City M', '2025-03-20'),
(12, 'Olivia', 'Patel', '9876543222', 'olivia.p@example.org', '512 Hemlock Dr, City N', '2025-03-25'),
(13, 'Andy', 'Smith', '9876543223', 'andy.s@example.org', '916 Yew St, City R', '2025-04-15'),
(14, 'Xavier', 'Young', '9876543224', 'xavier.y@example.com', '420 Juniper Dr, City V', '2025-05-05'),
(15, 'Bella', 'Clark', '9876543225', 'bella.c@example.com', '723 Olive Blvd, City Y', '2025-05-20'),
(16, 'Caleb', 'Dalton', '9876543226', 'caleb.d@example.org', '824 Peach St, City Z', '2025-05-25'),
(17, 'Chloe', 'Eaton', '9876543227', 'chloe.e@example.net', '925 Plum Ln, Town A', '2025-06-01'),
(18, 'David', 'Finch', '9876543228', 'david.f@example.com', '1026 Rose Rd, Town B', '2025-06-05'),
(19, 'Ella', 'Gray', '9876543229', 'ella.g@example.org', '1127 Saffron Ave, Town C', '2025-06-10'),
(20, 'Finn', 'Hayes', '9876543230', 'finn.h@example.net', '1228 Teak Dr, Town D', '2025-06-15');

-- ============================================================
-- INSERT: Plans
-- ============================================================
INSERT INTO Plans (plan_id, plan_name, monthly_cost, data_limit_gb, call_minutes_limit) VALUES
(1, 'Basic Talk', 25, 5, 500),
(2, 'Premium Data', 50, 50, 2000),
(3, 'Prepaid Starter', 15, 2, 100),
(4, 'Prepaid Starter', 15, 2, 100),
(5, 'Prepaid Starter', 15, 2, 100),
(6, 'Basic Talk', 25, 5, 500),
(7, 'Basic Talk', 25, 5, 500),
(8, 'Premium Data', 50, 50, 2000),
(9, 'Premium Data', 50, 50, 2000),
(10, 'Premium Data', 50, 50, 2000),
(11, 'Basic Talk', 25, 5, 500),
(12, 'Basic Talk', 25, 5, 500),
(13, 'Basic Talk', 25, 5, 500),
(14, 'Premium Data', 50, 50, 2000),
(15, 'Prepaid Starter', 15, 2, 100),
(16, 'Prepaid Starter', 15, 2, 100),
(17, 'Prepaid Starter', 15, 2, 100),
(18, 'Prepaid Starter', 15, 2, 100),
(19, 'Basic Talk', 25, 5, 500),
(20, 'Basic Talk', 25, 5, 500);

-- ============================================================
-- INSERT: SIM Cards
-- ============================================================
INSERT INTO SIM_Cards (customer_id, phone_number, iccid, activation_status, activation_date, line_type) VALUES
(1, '9876543211', '89912345678901234569', 'Active', '2025-01-21', 'Postpaid'),
(2, '9876543212', '89912345678901234570', 'Active', '2025-01-26', 'Postpaid'),
(3, '9876543213', '89912345678901234571', 'Active', '2025-02-06', 'Postpaid'),
(4, '9876543214', '89912345678901234572', 'Active', '2025-02-11', 'Postpaid'),
(5, '9876543215', '89912345678901234573', 'Active', '2025-02-16', 'Postpaid'),
(6, '9876543216', '89912345678901234574', 'Active', '2025-02-21', 'Postpaid'),
(7, '9876543217', '89912345678901234575', 'Active', '2025-03-02', 'Postpaid'),
(8, '9876543218', '89912345678901234576', 'Active', '2025-03-06', 'Postpaid'),
(9, '9876543219', '89912345678901234577', 'Active', '2025-03-11', 'Postpaid'),
(10, '9876543220', '89912345678901234578', 'Active', '2025-03-16', 'Postpaid'),
(11, '9876543221', '89912345678901234579', 'Active', '2025-03-21', 'Postpaid'),
(12, '9876543222', '89912345678901234580', 'Active', '2025-03-26', 'Postpaid'),
(13, '9876543223', '89912345678901234581', 'Active', '2025-03-29', 'Postpaid'),
(14, '9876543224', '89912345678901234582', 'Pending', '2025-04-06', 'Prepaid'),
(15, '9876543225', '89912345678901234583', 'Suspended', '2025-04-15', 'Postpaid'),
(16, '9876543226', '89912345678901234584', 'Inactive', '2025-04-19', 'Postpaid'),
(17, '9876543227', '89912345678901234585', 'Pending', '2025-04-22', 'Postpaid'),
(18, '9876543228', '89912345678901234586', 'Pending', '2025-04-24', 'Postpaid'),
(19, '9876543229', '89912345678901234587', 'Pending', '2025-04-28', 'Postpaid'),
(20, '9876543230', '89912345678901234588', 'Pending', '2025-05-15', 'Postpaid');

-- ============================================================
-- INSERT: Subscriptions
-- ============================================================
INSERT INTO Subscriptions (customer_id, phone_number, sim_serial_number, plan_id, start_date, is_active, account_type) VALUES
(1, '9876543211', 'SIM00001', 1, '2025-03-01', TRUE, 'Postpaid'),
(2, '9876543212', 'SIM00002', 2, '2025-03-01', TRUE, 'Postpaid'),
(3, '9876543213', 'SIM00003', 3, '2025-03-07', TRUE, 'Postpaid'),
(4, '9876543214', 'SIM00004', 4, '2025-03-07', TRUE, 'Prepaid'),
(5, '9876543215', 'SIM00005', 5, '2025-03-08', TRUE, 'Postpaid'),
(6, '9876543216', 'SIM00006', 6, '2025-03-09', TRUE, 'Postpaid'),
(7, '9876543217', 'SIM00007', 7, '2025-03-11', TRUE, 'Postpaid'),
(8, '9876543218', 'SIM00008', 8, '2025-03-12', TRUE, 'Postpaid'),
(9, '9876543219', 'SIM00009', 9, '2025-03-13', TRUE, 'Postpaid'),
(10, '9876543220', 'SIM00010', 10, '2025-03-14', TRUE, 'Prepaid'),
(11, '9876543221', 'SIM00011', 11, '2025-03-15', TRUE, 'Postpaid'),
(12, '9876543222', 'SIM00012', 12, '2025-03-16', TRUE, 'Postpaid'),
(13, '9876543223', 'SIM00013', 13, '2025-03-22', TRUE, 'Postpaid'),
(14, '9876543224', 'SIM00014', 14, '2025-03-27', TRUE, 'Prepaid'),
(15, '9876543225', 'SIM00015', 15, '2025-04-03', TRUE, 'Postpaid'),
(16, '9876543226', 'SIM00016', 16, '2025-04-07', TRUE, 'Postpaid'),
(17, '9876543227', 'SIM00017', 17, '2025-04-12', TRUE, 'Postpaid'),
(18, '9876543228', 'SIM00018', 18, '2025-04-17', TRUE, 'Postpaid'),
(19, '9876543229', 'SIM00019', 19, '2025-04-22', TRUE, 'Postpaid'),
(20, '9876543230', 'SIM00020', 20, '2025-04-27', TRUE, 'Postpaid');

-- ============================================================
-- INSERT: Bills (Sample billing data)
-- ============================================================
INSERT INTO Bills (customer_id, billing_cycle_start, billing_cycle_end, due_date, total_amount, amount_paid, payment_status) VALUES
(1, '2025-03-01', '2025-03-31', '2025-04-15', 53.50, 53.50, 'Paid'),
(2, '2025-03-01', '2025-03-31', '2025-04-15', 27.25, 27.25, 'Paid'),
(3, '2025-03-07', '2025-04-06', '2025-04-21', 51.10, 51.10, 'Paid'),
(4, '2025-03-07', '2025-04-06', '2025-04-21', 19.80, 0.00, 'Pending'),
(5, '2025-03-08', '2025-04-07', '2025-04-22', 29.40, 0.00, 'Pending'),
(6, '2025-03-09', '2025-04-08', '2025-04-23', 54.90, 0.00, 'Pending'),
(7, '2025-03-11', '2025-04-10', '2025-04-25', 26.65, 26.65, 'Paid'),
(8, '2025-03-12', '2025-04-11', '2025-04-26', 52.30, 52.30, 'Paid'),
(9, '2025-03-13', '2025-04-12', '2025-04-27', 28.15, 0.00, 'Pending'),
(10, '2025-03-14', '2025-04-13', '2025-04-28', 17.50, 0.00, 'Pending'),
(11, '2025-03-15', '2025-04-14', '2025-04-29', 54.15, 54.15, 'Paid'),
(12, '2025-03-16', '2025-04-15', '2025-04-30', 25.95, 25.95, 'Paid'),
(13, '2025-03-22', '2025-04-21', '2025-05-06', 53.05, 53.05, 'Paid'),
(14, '2025-03-27', '2025-04-26', '2025-05-11', 19.30, 19.30, 'Paid'),
(15, '2025-04-03', '2025-05-02', '2025-05-17', 28.75, 0.00, 'Pending'),
(16, '2025-04-07', '2025-05-06', '2025-05-21', 26.05, 0.00, 'Pending'),
(17, '2025-04-12', '2025-05-11', '2025-05-26', 29.10, 0.00, 'Pending'),
(18, '2025-04-17', '2025-05-16', '2025-05-31', 27.65, 27.65, 'Paid'),
(19, '2025-04-22', '2025-05-21', '2025-06-05', 28.45, 0.00, 'Pending'),
(20, '2025-04-27', '2025-05-26', '2025-06-10', 26.80, 0.00, 'Pending');

-- ============================================================
-- INSERT: Complaints (Sample complaint records)
-- ============================================================
INSERT INTO Complaints (customer_id, sim_id, subject, description, status, reported_date) VALUES
(1, 1, 'Slow Data Speeds', 'My internet speed has been consistently below expectations since activation.', 'New', '2025-04-01 10:00:00'),
(5, 5, 'Incorrect Usage Charges', 'I was charged for SMS, but my plan includes unlimited messaging.', 'New', '2025-04-05 14:30:00'),
(6, 6, 'Frequent Network Coverage Loss', 'My phone drops signal several times a day in my home area.', 'New', '2025-04-10 09:00:00'),
(8, 8, 'Confusing Bill Breakdown', 'I do not understand the data charges section on my last bill.', 'New', '2025-04-15 16:00:00'),
(11, 11, 'SIM Activation Issue', 'The SIM card I received today is showing as inactive.', 'New', '2025-04-20 11:30:00'),
(12, 12, 'Dropped Calls', 'Calls are dropping randomly, especially during peak hours.', 'New', '2025-04-25 12:45:00');

-- ============================================================
-- End of Data Insertion
-- ============================================================
