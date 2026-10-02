-- ============================================================
-- TELECOM SUBSCRIBER & BILLING MANAGEMENT SYSTEM
-- Complex Query Demonstrations & Analysis
-- ============================================================

USE TelecomDB;

-- ============================================================
-- QUERY 1: Display all customers and their plan names
-- ============================================================
SELECT
    Customers.customer_id,
    Customers.first_name,
    Customers.last_name,
    Plans.plan_name
FROM Customers
JOIN Subscriptions ON Customers.customer_id = Subscriptions.customer_id
JOIN Plans ON Subscriptions.plan_id = Plans.plan_id;

-- ============================================================
-- QUERY 2: Show all pending bills
-- ============================================================
SELECT
    customer_id,
    total_amount,
    due_date,
    payment_status
FROM Bills
WHERE payment_status = 'Pending';

-- ============================================================
-- QUERY 3: Find customers who have made a complaint
-- ============================================================
SELECT
    customer_id,
    subject,
    status
FROM Complaints;

-- ============================================================
-- QUERY 4: Identify SIM cards that are not yet active
-- ============================================================
SELECT
    s.sim_id,
    s.phone_number,
    s.activation_status,
    c.first_name,
    c.last_name
FROM SIM_Cards s
JOIN Customers c ON s.customer_id = c.customer_id
WHERE s.activation_status IN ('Pending', 'Inactive');

-- ============================================================
-- QUERY 5: Display all customers who registered after March 2025
-- ============================================================
SELECT
    customer_id,
    first_name,
    last_name,
    registration_date
FROM Customers
WHERE registration_date > '2025-03-31';

-- ============================================================
-- QUERY 6: Find all customers using Postpaid connections
-- ============================================================
SELECT
    customer_id,
    phone_number,
    line_type
FROM SIM_Cards
WHERE line_type = 'Postpaid';

-- ============================================================
-- QUERY 7: Find the total amount billed to each customer
-- ============================================================
SELECT
    customer_id,
    SUM(total_amount) AS total_billed
FROM Bills
GROUP BY customer_id;

-- ============================================================
-- QUERY 8: List all calls longer than 3 minutes
-- ============================================================
SELECT
    sim_id,
    usage_timestamp,
    duration_seconds
FROM Usage_Records
WHERE usage_type = 'Call' AND duration_seconds > 180;

-- ============================================================
-- QUERY 9: Show all data usage records
-- ============================================================
SELECT
    sim_id,
    usage_type,
    data_used_mb,
    cost
FROM Usage_Records
WHERE usage_type = 'Data';

-- ============================================================
-- QUERY 10: Show total number of complaints for each status
-- ============================================================
SELECT
    status,
    COUNT(*) AS number_of_complaints
FROM Complaints
GROUP BY status;

-- ============================================================
-- QUERY 11: Show customers whose bill amount is more than ₹50
-- ============================================================
SELECT
    customer_id,
    total_amount,
    payment_status
FROM Bills
WHERE total_amount > 50;

-- ============================================================
-- QUERY 12: Show customers along with their SIM activation status
-- ============================================================
SELECT
    Customers.customer_id,
    Customers.first_name,
    SIM_Cards.phone_number,
    SIM_Cards.activation_status
FROM Customers
JOIN SIM_Cards ON Customers.customer_id = SIM_Cards.customer_id;

-- ============================================================
-- QUERY 13: Show total number of each type of usage
-- ============================================================
SELECT
    usage_type,
    COUNT(*) AS total_records
FROM Usage_Records
GROUP BY usage_type;

-- ============================================================
-- QUERY 14: Show all customers with email ending in '.com'
-- ============================================================
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM Customers
WHERE email LIKE '%.com';

-- ============================================================
-- QUERY 15: Find the earliest and latest SIM activation dates
-- ============================================================
SELECT
    MIN(activation_date) AS first_activation,
    MAX(activation_date) AS last_activation
FROM SIM_Cards;

-- ============================================================
-- QUERY 16: Revenue Analysis - Total revenue by payment status
-- ============================================================
SELECT
    payment_status,
    SUM(total_amount) AS revenue,
    COUNT(*) AS bill_count,
    AVG(total_amount) AS avg_bill_amount
FROM Bills
GROUP BY payment_status
ORDER BY revenue DESC;

-- ============================================================
-- QUERY 17: Customer Payment Analysis
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(b.bill_id) AS total_bills,
    SUM(b.total_amount) AS total_billed,
    SUM(b.amount_paid) AS total_paid,
    SUM(b.total_amount - b.amount_paid) AS outstanding_balance
FROM Customers c
LEFT JOIN Bills b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY outstanding_balance DESC;

-- ============================================================
-- QUERY 18: Usage Statistics by Customer
-- ============================================================
SELECT
    s.sim_id,
    c.first_name,
    c.last_name,
    COUNT(CASE WHEN ur.usage_type = 'Call' THEN 1 END) AS call_count,
    COUNT(CASE WHEN ur.usage_type = 'Data' THEN 1 END) AS data_count,
    COUNT(CASE WHEN ur.usage_type = 'SMS' THEN 1 END) AS sms_count,
    SUM(ur.cost) AS total_usage_cost
FROM SIM_Cards s
JOIN Customers c ON s.customer_id = c.customer_id
LEFT JOIN Usage_Records ur ON s.sim_id = ur.sim_id
GROUP BY s.sim_id, c.first_name, c.last_name;

-- ============================================================
-- QUERY 19: Plans Performance - Most popular and revenue generator
-- ============================================================
SELECT
    p.plan_id,
    p.plan_name,
    COUNT(s.subscription_id) AS subscriber_count,
    p.monthly_cost,
    COUNT(s.subscription_id) * p.monthly_cost AS potential_monthly_revenue
FROM Plans p
LEFT JOIN Subscriptions s ON p.plan_id = s.plan_id
GROUP BY p.plan_id, p.plan_name, p.monthly_cost
ORDER BY subscriber_count DESC;

-- ============================================================
-- QUERY 20: Complaint Resolution Analysis
-- ============================================================
SELECT
    status,
    COUNT(*) AS complaint_count,
    COUNT(CASE WHEN resolution_date IS NOT NULL 
            THEN DATEDIFF(resolution_date, reported_date) END) AS avg_resolution_days
FROM Complaints
GROUP BY status;

-- ============================================================
-- QUERY 21: SIM Card Activation Status Summary
-- ============================================================
SELECT
    activation_status,
    COUNT(*) AS sim_count,
    line_type,
    COUNT(*) AS count_by_type
FROM SIM_Cards
GROUP BY activation_status, line_type;

-- ============================================================
-- QUERY 22: Monthly Data Usage Trend
-- ============================================================
SELECT
    YEAR(usage_timestamp) AS year,
    MONTH(usage_timestamp) AS month,
    SUM(CASE WHEN usage_type = 'Data' THEN data_used_mb ELSE 0 END) AS total_data_mb,
    COUNT(*) AS total_records,
    SUM(cost) AS total_cost
FROM Usage_Records
GROUP BY YEAR(usage_timestamp), MONTH(usage_timestamp)
ORDER BY year DESC, month DESC;

-- ============================================================
-- QUERY 23: Top Spenders
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    SUM(ur.cost) AS total_usage_cost,
    SUM(b.total_amount) AS total_billed
FROM Customers c
LEFT JOIN SIM_Cards sc ON c.customer_id = sc.customer_id
LEFT JOIN Usage_Records ur ON sc.sim_id = ur.sim_id
LEFT JOIN Bills b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_billed DESC
LIMIT 10;

-- ============================================================
-- QUERY 24: Customers with Unpaid Bills
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone_number,
    SUM(b.total_amount - b.amount_paid) AS outstanding_balance,
    COUNT(b.bill_id) AS overdue_bills
FROM Customers c
JOIN Bills b ON c.customer_id = b.customer_id
WHERE b.payment_status IN ('Pending', 'Partial', 'Overdue')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone_number
ORDER BY outstanding_balance DESC;

-- ============================================================
-- QUERY 25: Active vs Inactive Subscriptions
-- ============================================================
SELECT
    account_type,
    is_active,
    COUNT(*) AS subscription_count
FROM Subscriptions
GROUP BY account_type, is_active;

-- ============================================================
-- End of Query Demonstrations
-- ============================================================
