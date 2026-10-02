# SQL Projects - Quick Reference Guide

## 🗂️ File Organization

### Telecom System Files:
```
01_TelecomDB_Schema.sql       → Database & table creation
02_TelecomDB_Data.sql         → Sample data (20 customers)
03_TelecomDB_Queries.sql      → 25 complex queries
04_TelecomDB_Security.sql     → Users, roles, procedures, transactions
```

### University System Files:
```
05_UniversityDB_Schema.sql    → Database & table creation
06_UniversityDB_Queries.sql   → 30 complex queries
07_UniversityDB_Security.sql  → Users, procedures, triggers
```

---

## ⚡ Quick Start Commands

### Setup Telecom System:
```bash
# 1. Create database and schema
mysql -u root -p < 01_TelecomDB_Schema.sql

# 2. Load data
mysql -u root -p TelecomDB < 02_TelecomDB_Data.sql

# 3. Run queries
mysql -u root -p TelecomDB < 03_TelecomDB_Queries.sql

# 4. Setup security
mysql -u root -p TelecomDB < 04_TelecomDB_Security.sql
```

### Setup University System:
```bash
# 1. Create database and schema
mysql -u root -p < 05_UniversityDB_Schema.sql

# 2. Run queries
mysql -u root -p DBMS_Sem3 < 06_UniversityDB_Queries.sql

# 3. Setup security
mysql -u root -p DBMS_Sem3 < 07_UniversityDB_Security.sql
```

---

## 📊 Database Overview

### Telecom System (TelecomDB)

**Tables**: 9
- Customers (20 records)
- Plans (20 records)
- SIM_Cards (20 records)
- Subscriptions (20 records)
- Usage_Records (60+ records)
- Bills (20 records)
- Complaints (6 records)
- Employees
- Network_Areas
- Notifications
- Transaction_Logs

**Relationships**:
```
Customers (1) ──→ (N) SIM_Cards
Customers (1) ──→ (N) Subscriptions
Plans (1) ──→ (N) Subscriptions
SIM_Cards (1) ──→ (N) Usage_Records
Customers (1) ──→ (N) Bills
Customers (1) ──→ (N) Complaints
```

**Key Features**:
- Prepaid & Postpaid subscription types
- Call, Data, SMS usage tracking
- Payment status tracking (Pending, Paid, Partial, Overdue)
- Complaint lifecycle management
- ACID-compliant transactions

---

### University System (DBMS_Sem3)

**Tables**: 5 core + Views
- Department
- Student
- Professors
- Courses
- Enrollment

**Relationships**:
```
Department (1) ──→ (N) Student
Department (1) ──→ (N) Professors
Department (1) ──→ (N) Courses
Student (1) ──→ (N) Courses
Student (1) ──→ (N) Enrollment
```

**Key Features**:
- Student enrollment management
- Course credit tracking
- Faculty type classification
- Payment status tracking
- Academic reporting

---

## 🔍 Key Queries by Category

### Telecom - Revenue & Billing
```
Query 7:  Total amount billed per customer
Query 11: Customers with bills > ₹50
Query 16: Revenue by payment status
Query 17: Customer payment analysis
```

### Telecom - Usage Analytics
```
Query 8:  Calls longer than 3 minutes
Query 9:  Data usage records
Query 13: Usage type distribution
Query 18: Usage statistics by customer
```

### Telecom - Operational
```
Query 1:  Customers and plans
Query 6:  Postpaid customers
Query 12: SIM activation status
Query 21: SIM status summary
```

### University - Academic Analysis
```
Query 1:  Students and departments
Query 5:  Courses per department
Query 26: Full student course info
Query 28: Department statistics
```

### University - Enrollment Management
```
Query 4:  Pending payment enrollments
Query 6:  Enrollment date range
Query 14: Payment status summary
Query 29: Student enrollment history
```

### University - Aggregations & Functions
```
Query 8:  Total professors (COUNT)
Query 9:  Average course credits (AVG)
Query 10: Max/Min credits (MAX/MIN)
Query 11: Total credits (SUM)
```

---

## 📈 Complex Joins Examples

### Telecom:
```sql
-- 3 tables
SELECT c.*, s.*, p.* FROM Customers c
JOIN SIM_Cards s ON c.customer_id = s.customer_id
JOIN Plans p ... WHERE ...

-- 4 tables
SELECT * FROM Customers c
JOIN Bills b ON c.customer_id = b.customer_id
JOIN Usage_Records ur ...
JOIN Plans p ...
```

### University:
```sql
-- 3 tables (INNER)
SELECT s.*, c.*, d.* FROM Student s
INNER JOIN Courses c ON s.Student_ID = c.student_id
INNER JOIN Department d ON c.Dept_ID = d.Dept_ID

-- 4 tables (MIXED)
SELECT s.*, c.*, d.*, e.* FROM Student s
INNER JOIN Courses c ON s.Student_ID = c.student_id
INNER JOIN Department d ON c.Dept_ID = d.Dept_ID
LEFT JOIN Enrollment e ON s.Student_ID = e.student_id
```

---

## 🔐 User Roles & Access

### Telecom System:
| Role | Tables | Permissions |
|------|--------|-------------|
| Admin | ALL | ALL |
| Staff | Customers, SIM_Cards, Subscriptions | SELECT, UPDATE |
| Customer Service | ALL | SELECT + UPDATE (Bills, Complaints) |
| Billing | Bills | SELECT, INSERT, UPDATE |
| Viewer | ALL | SELECT (Read-only) |

### University System:
| Role | Tables | Permissions |
|------|--------|-------------|
| Admin | ALL | ALL |
| Faculty | ALL | SELECT + UPDATE (Enrollment) |
| Registrar | Enrollment, Student | SELECT, INSERT, UPDATE |
| Student | Courses, Student, Enrollment | SELECT (View own records) |
| Viewer | ALL | SELECT (Read-only) |

---

## 💾 Backup & Restore

### Backup:
```bash
# Full database backup
mysqldump -u root -p TelecomDB > telecom_backup.sql
mysqldump -u root -p DBMS_Sem3 > university_backup.sql

# With timestamp
mysqldump -u root -p TelecomDB > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore:
```bash
# From backup
mysql -u root -p TelecomDB < telecom_backup.sql
mysql -u root -p DBMS_Sem3 < university_backup.sql

# Specific table
mysqldump -u root -p TelecomDB Customers > customers.sql
```

---

## 🔄 Transaction Examples

### Telecom - Payment Processing:
```sql
START TRANSACTION;
  -- Lock bill record
  SELECT * FROM Bills WHERE bill_id = X FOR UPDATE;
  
  -- Update payment
  UPDATE Bills SET amount_paid = amount_paid + Y WHERE bill_id = X;
  
  -- Log transaction
  INSERT INTO Transaction_Logs ...
  
COMMIT;  -- or ROLLBACK if error
```

### University - Student Enrollment:
```sql
START TRANSACTION;
  -- Verify student
  IF EXISTS (SELECT 1 FROM Student WHERE Student_ID = X) THEN
    -- Insert enrollment
    INSERT INTO Enrollment (student_id, payment_status, enrollment_date)
    VALUES (X, 'PENDING', CURDATE());
  END IF;
COMMIT;
```

---

## 📋 Views Summary

### Telecom Views:
- `v_customer_summary` - Hide sensitive email
- `v_pending_bills` - Outstanding payments
- `v_active_subscriptions` - Active user plans
- `v_customer_complaints` - Complaint tracking
- `v_revenue_summary` - Revenue by status

### University Views:
- `v_student_courses` - Student enrollments
- `v_enrollment_summary` - Enrollment details
- `v_professor_department` - Faculty assignments
- `v_department_courses` - Course statistics
- `v_pending_payments` - Outstanding fees

---

## 🎯 Common Operations

### Find Overdue Payments (Telecom):
```sql
SELECT * FROM Bills 
WHERE payment_status = 'Overdue' 
AND due_date < CURDATE();
```

### Get Student Academic Standing (University):
```sql
SELECT s.*, COUNT(c.course_id) AS courses,
       SUM(c.credits) AS total_credits
FROM Student s
LEFT JOIN Courses c ON s.Student_ID = c.student_id
GROUP BY s.Student_ID;
```

### Top Spenders (Telecom):
```sql
SELECT c.customer_id, c.first_name,
       SUM(b.total_amount) AS total_spent
FROM Customers c
JOIN Bills b ON c.customer_id = b.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC LIMIT 10;
```

### Departments with Most Students (University):
```sql
SELECT d.Dept_name, COUNT(s.Student_ID) AS student_count
FROM Department d
LEFT JOIN Student s ON d.Dept_ID = s.Dept_ID
GROUP BY d.Dept_ID
ORDER BY student_count DESC;
```

---

## ⚙️ Performance Tuning

### Indexes Present:
```sql
-- Telecom
CREATE INDEX idx_customer_phone ON Customers(phone_number);
CREATE INDEX idx_sim_customer ON SIM_Cards(customer_id);
CREATE INDEX idx_bill_status ON Bills(payment_status);
CREATE INDEX idx_complaint_status ON Complaints(status);

-- University
CREATE INDEX idx_student_email ON Student(email);
CREATE INDEX idx_professor_dept ON Professors(Dept_ID);
CREATE INDEX idx_enrollment_status ON Enrollment(payment_status);
```

### Query Optimization Tips:
1. Always use indexes on JOIN columns
2. Use EXPLAIN to analyze slow queries
3. Avoid SELECT * in production
4. Use WHERE clauses to filter early
5. Monitor query execution plans

---

## 🐛 Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| Foreign key constraint failed | Parent record missing | Insert parent first |
| Duplicate entry | Unique constraint violated | Check for duplicates |
| Access denied | Insufficient privileges | Grant permissions |
| Out of range | Value exceeds column size | Check data types |
| Syntax error | Incorrect SQL | Review query syntax |

---

## 📚 File Execution Order

### First Time Setup:

1. **Telecom System**:
   - ✅ 01_TelecomDB_Schema.sql (creates database)
   - ✅ 02_TelecomDB_Data.sql (loads data)
   - ✅ 03_TelecomDB_Queries.sql (test queries)
   - ✅ 04_TelecomDB_Security.sql (security setup)

2. **University System**:
   - ✅ 05_UniversityDB_Schema.sql (creates database)
   - ✅ 06_UniversityDB_Queries.sql (test queries)
   - ✅ 07_UniversityDB_Security.sql (security setup)

---

## 🎓 Learning Path

### Beginner:
1. Run schema creation
2. Execute basic SELECT queries
3. Explore single-table queries
4. Understand data relationships

### Intermediate:
1. Study JOIN operations
2. Analyze GROUP BY aggregations
3. Explore subqueries
4. Review views and indexes

### Advanced:
1. Implement transactions
2. Create stored procedures
3. Manage user access
4. Optimize query performance

---

## 📞 Quick Help

### Check Database Size:
```sql
SELECT SUM(data_length + index_length) / 1024 / 1024 AS size_mb
FROM information_schema.tables
WHERE table_schema = 'TelecomDB';
```

### View Active Connections:
```sql
SHOW PROCESSLIST;
```

### Check Table Status:
```sql
SHOW TABLE STATUS FROM TelecomDB;
```

### View Current User:
```sql
SELECT USER(), DATABASE();
```

---

## 🔗 Useful SQL Snippets

### Count records in all tables:
```sql
SELECT table_name, table_rows 
FROM information_schema.tables 
WHERE table_schema = 'TelecomDB';
```

### Drop all tables (use carefully!):
```sql
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Bills;
TRUNCATE TABLE Complaints;
-- ... truncate other tables
SET FOREIGN_KEY_CHECKS = 1;
```

### Reset auto-increment:
```sql
ALTER TABLE Customers AUTO_INCREMENT = 1;
```

---

**Last Updated**: October 2026
**Versions**: MySQL 5.7+, MariaDB 10.3+

Happy querying! 🚀
