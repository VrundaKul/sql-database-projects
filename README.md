SQL Database Projects
This repository contains two comprehensive SQL database projects demonstrating real-world database design, implementation, and management:
Telecom Subscriber & Billing Management System
University Course Management & Enrollment System


📁 Project Structure
Project 1: Telecom Subscriber & Billing Management System

Files:
01_TelecomDB_Schema.sql - Database schema and table definitions
02_TelecomDB_Data.sql - Sample data for testing and demonstration
03_TelecomDB_Queries.sql - Complex queries and analysis
04_TelecomDB_Security.sql - User management, access control, and transactions

Key Features:
✅ Customer/Subscriber Management
✅ SIM Card Management (Prepaid & Postpaid)
✅ Plan Selection and Modification
✅ Usage Tracking (Calls, Data, SMS)
✅ Billing and Payment Processing
✅ Complaint Handling & Resolution
✅ Transaction Management with ACID Compliance
✅ Role-Based Access Control
Database Entities:
Customers ←→ SIM_Cards ←→ Usage_Records
    ↓
Subscriptions ←→ Plans
    ↓
Bills ←→ Complaints
Project 2: University Course Management & Enrollment System
Files:
05_UniversityDB_Schema.sql - Database schema and table definitions
06_UniversityDB_Queries.sql - Complex queries and analysis
07_UniversityDB_Security.sql - User management, procedures, and transactions
Key Features:
✅ Student Management and Registration
✅ Professor and Faculty Management
✅ Department Administration
✅ Course Catalog and Scheduling
✅ Student Enrollment Processing
✅ Payment Status Tracking
✅ Comprehensive Reporting
✅ Role-Based Access Control
Database Entities:
Department ←→ Student ←→ Courses
    ↓
Professors → Enrollment
🚀 Getting Started
Prerequisites
MySQL Server (5.7 or higher) or MariaDB
MySQL Client or MySQL Workbench
Basic SQL knowledge
Installation Steps
For Telecom System:
Create Database and Schema:
mysql -u root -p < 01_TelecomDB_Schema.sql
Load Sample Data:
mysql -u root -p TelecomDB < 02_TelecomDB_Data.sql
Run Queries:
mysql -u root -p TelecomDB < 03_TelecomDB_Queries.sql
Set Up Security & Users:
mysql -u root -p TelecomDB < 04_TelecomDB_Security.sql
For University System:
Create Database and Schema:
mysql -u root -p < 05_UniversityDB_Schema.sql
Run Queries:
mysql -u root -p DBMS_Sem3 < 06_UniversityDB_Queries.sql
Set Up Security & Procedures:
mysql -u root -p DBMS_Sem3 < 07_UniversityDB_Security.sql
📊 Telecom System - Key Queries
1. Customer Payment Analysis
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(b.total_amount) AS total_billed,
    SUM(b.amount_paid) AS total_paid,
    SUM(b.total_amount - b.amount_paid) AS outstanding_balance
FROM Customers c
LEFT JOIN Bills b ON c.customer_id = b.customer_id
GROUP BY c.customer_id
ORDER BY outstanding_balance DESC;
2. Usage Statistics
SELECT
    s.sim_id,
    c.first_name,
    c.last_name,
    COUNT(CASE WHEN ur.usage_type = 'Call' THEN 1 END) AS call_count,
    COUNT(CASE WHEN ur.usage_type = 'Data' THEN 1 END) AS data_count,
    SUM(ur.cost) AS total_usage_cost
FROM SIM_Cards s
JOIN Customers c ON s.customer_id = c.customer_id
LEFT JOIN Usage_Records ur ON s.sim_id = ur.sim_id
GROUP BY s.sim_id, c.first_name, c.last_name;
3. Revenue Analysis
SELECT
    payment_status,
    SUM(total_amount) AS revenue,
    COUNT(*) AS bill_count,
    AVG(total_amount) AS avg_bill_amount
FROM Bills
GROUP BY payment_status
ORDER BY revenue DESC;
🎓 University System - Key Queries
1. Student Academic Summary
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    d.Dept_name,
    COUNT(c.course_id) AS Enrolled_Courses,
    SUM(c.credits) AS Total_Credits
FROM Student s
LEFT JOIN Department d ON s.Dept_ID = d.Dept_ID
LEFT JOIN Courses c ON s.Student_ID = c.student_id
GROUP BY s.Student_ID;
2. Department Statistics
SELECT
    d.Dept_ID,
    d.Dept_name,
    COUNT(DISTINCT s.Student_ID) AS Total_Students,
    COUNT(DISTINCT p.professor_id) AS Total_Professors,
    COUNT(DISTINCT c.course_id) AS Total_Courses
FROM Department d
LEFT JOIN Student s ON d.Dept_ID = s.Dept_ID
LEFT JOIN Professors p ON d.Dept_ID = p.Dept_ID
LEFT JOIN Courses c ON d.Dept_ID = c.Dept_ID
GROUP BY d.Dept_ID;
3. Pending Payments
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    e.enrollment_id,
    e.enrollment_date
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.student_id
WHERE e.payment_status = 'PENDING';
🔒 Security Features
Role-Based Access Control:
Telecom System:
Admin: Full access to all tables
Staff: SELECT, INSERT, UPDATE on customer and subscription tables
Customer Service: SELECT on all, UPDATE on Bills and Complaints
Billing: SELECT, INSERT, UPDATE on Bills only
Viewer: SELECT (read-only) access
University System:
Admin: Full access
Faculty: SELECT on all, UPDATE on Enrollment
Registrar: SELECT, INSERT, UPDATE on Enrollment
Student: SELECT on courses and enrollment info
Viewer: SELECT (read-only) access
Uncomment User Creation:
All user creation and privilege commands are commented. To enable them:
Uncomment the CREATE USER and GRANT statements
Update passwords for security
Execute the statements as the root user
🔄 Transaction Management
ACID Compliance Examples:
Telecom - Bill Generation Transaction:
CALL GenerateMonthlyBill(customer_id);
University - Student Enrollment:
CALL EnrollStudent(student_id, 'PENDING');
📈 Database Performance
Indexes Created:
All tables include strategic indexes on:
Foreign keys
Commonly searched fields (email, phone, status)
Timestamp fields
Query Optimization Tips:
Use EXPLAIN to analyze query performance
Check query execution plans
Consider denormalization for read-heavy operations
Monitor slow query log
🛠️ Maintenance Tasks
Backup Strategy:
Full Backup (Daily):
mysqldump -u admin_user -p TelecomDB > backup_$(date +%Y%m%d).sql
mysqldump -u admin_user -p DBMS_Sem3 > backup_$(date +%Y%m%d).sql
Restore from Backup:
mysql -u admin_user -p TelecomDB < backup_YYYYMMDD.sql
Data Validation:
Check referential integrity:
-- Check orphaned records
SELECT * FROM SIM_Cards WHERE customer_id NOT IN (SELECT customer_id FROM Customers);
📚 Technical Highlights
Telecom System:
Entities: 9 tables with complex relationships
Views: 5 views for simplified data access
Triggers: For automated billing and notifications
Stored Procedures: For payment processing
Data Volume: 20+ sample customers with usage records
University System:
Entities: 5 core tables
Views: 5 views for enrollment and course management
Stored Procedures: For enrollment and reporting
Joins: Inner, Left, Right joins demonstrated
Aggregations: GROUP BY, HAVING, COUNT, SUM, AVG
🎯 Use Cases
Telecom System:
Track subscriber usage and billing
Manage prepaid vs postpaid accounts
Process payments and handle complaints
Generate revenue reports
Monitor network area coverage
University System:
Manage student registrations
Track course enrollments
Monitor payment status
Generate academic reports
Manage faculty assignments
📝 Sample Data
Both projects include realistic sample data:
Telecom: 20 customers with SIM cards, usage records, and bills
University: Multiple students, professors, departments, and courses
Data is designed to demonstrate:
Various status values (Pending, Active, Paid, etc.)
Complex relationships between tables
Aggregate calculations
Real-world scenarios
🐛 Troubleshooting
Common Issues:
Foreign Key Constraint Errors
Ensure parent records exist before inserting child records
Check constraint definitions in schema files
Duplicate Key Errors
Verify unique constraints (email, phone_number, etc.)
Check sample data for duplicates
Access Denied Errors
Ensure user has proper privileges
Check user creation statements in security files
Query Performance Issues
Check indexes exist on commonly queried fields
Use EXPLAIN to analyze query plans
📖 Learning Resources
Concepts Covered:
✅ Database Design & Normalization
✅ SQL DDL (CREATE, ALTER, DROP)
✅ SQL DML (INSERT, UPDATE, DELETE, SELECT)
✅ Complex Joins (INNER, LEFT, RIGHT, FULL)
✅ Aggregate Functions (COUNT, SUM, AVG, MAX, MIN)
✅ Subqueries & Correlated Subqueries
✅ Stored Procedures & Triggers
✅ Views (Regular & Materialized)
✅ Transaction Management & ACID Properties
✅ Security & Access Control
✅ Performance Optimization & Indexing
💡 Tips for Extension
Add More Features:
Telecom System:
Add network quality monitoring
Implement fraud detection
Add loyalty programs
Create customer segmentation
University System:
Add grade management
Implement prerequisite checking
Create GPA calculation
Add course scheduling
📞 Support
For issues or questions:
Review the SQL files and inline comments
Check the section comments in each file
Test queries incrementally
Verify data constraints
📜 License
These projects are provided for educational purposes. Feel free to modify and extend them for your needs.
✨ Key Takeaways
Telecom System:
Real-world billing and subscription management
Complex financial transactions
Customer relationship tracking
Performance optimization for high-volume data
University System:
Academic institution management
Student lifecycle tracking
Course and curriculum management
Role-based academic operations
🎓 Skills Demonstrated
✅ Database Design & Modeling ✅ SQL Query Writing (Intermediate to Advanced) ✅ Transaction Management ✅ Security & Access Control ✅ Performance Optimization ✅ Data Validation & Integrity ✅ Reporting & Analytics ✅ Real-world Business Logic
Created: 2025 Status: Production Ready Last Updated: October 2026
Enjoy exploring these comprehensive SQL projects! 🚀
