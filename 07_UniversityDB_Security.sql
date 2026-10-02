-- ============================================================
-- UNIVERSITY COURSE MANAGEMENT & ENROLLMENT SYSTEM
-- Security, Access Control & Transaction Management
-- ============================================================

USE DBMS_Sem3;

-- ============================================================
-- USER CREATION & ROLE-BASED ACCESS CONTROL
-- ============================================================

-- Create Student User with LIMITED access
-- CREATE USER 'student_user'@'localhost' IDENTIFIED BY 'Student@123';
-- GRANT SELECT ON DBMS_Sem3.Student TO 'student_user'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Courses TO 'student_user'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Enrollment TO 'student_user'@'localhost';

-- Create Faculty User with access to student and course management
-- CREATE USER 'faculty_user'@'localhost' IDENTIFIED BY 'Faculty@456';
-- GRANT SELECT ON DBMS_Sem3.* TO 'faculty_user'@'localhost';
-- GRANT UPDATE ON DBMS_Sem3.Enrollment TO 'faculty_user'@'localhost';

-- Create Admin User with FULL access
-- CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin@789';
-- GRANT ALL PRIVILEGES ON DBMS_Sem3.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Create Registrar User (enrollment management)
-- CREATE USER 'registrar'@'localhost' IDENTIFIED BY 'Registrar@101';
-- GRANT SELECT, INSERT, UPDATE ON DBMS_Sem3.Enrollment TO 'registrar'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Student TO 'registrar'@'localhost';

-- ============================================================
-- GRANT PRIVILEGES - Role-based Access
-- ============================================================

-- Grant all privileges to admin
-- GRANT ALL PRIVILEGES ON DBMS_Sem3.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Grant specific privileges to students
-- GRANT SELECT ON DBMS_Sem3.Student TO 'student_user'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Department TO 'student_user'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Courses TO 'student_user'@'localhost';
-- GRANT SELECT ON DBMS_Sem3.Enrollment TO 'student_user'@'localhost';

-- Grant update privileges to faculty
-- GRANT UPDATE ON DBMS_Sem3.Enrollment TO 'faculty_user'@'localhost';

-- Check granted privileges
-- SHOW GRANTS FOR 'student_user'@'localhost';
-- SHOW GRANTS FOR 'faculty_user'@'localhost';
-- SHOW GRANTS FOR 'admin_user'@'localhost';

-- ============================================================
-- REVOKE PRIVILEGES
-- ============================================================

-- Revoke INSERT privilege from Student User
-- REVOKE INSERT ON DBMS_Sem3.Enrollment FROM 'student_user'@'localhost';

-- Revoke DELETE privilege from Faculty User
-- REVOKE DELETE ON DBMS_Sem3.* FROM 'faculty_user'@'localhost';

-- Revoke all privileges from a user
-- REVOKE ALL PRIVILEGES ON DBMS_Sem3.* FROM 'student_user'@'localhost';

-- ============================================================
-- STORED PROCEDURES FOR BUSINESS LOGIC
-- ============================================================

DELIMITER $$

-- Procedure 1: Enroll a Student in a Course
CREATE PROCEDURE EnrollStudent(IN p_student_id INT, IN p_payment_status VARCHAR(20))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error enrolling student';
    END;

    START TRANSACTION;
    
    -- Verify student exists
    IF NOT EXISTS (SELECT 1 FROM Student WHERE Student_ID = p_student_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student not found';
    END IF;

    -- Insert enrollment record
    INSERT INTO Enrollment (enrollment_date, payment_status, student_id)
    VALUES (CURDATE(), p_payment_status, p_student_id);

    COMMIT;
END$$

-- Procedure 2: Process Payment for Enrollment
CREATE PROCEDURE ProcessEnrollmentPayment(IN p_enrollment_id INT, IN p_payment_method VARCHAR(30))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error processing payment';
    END;

    START TRANSACTION;

    -- Verify enrollment exists
    IF NOT EXISTS (SELECT 1 FROM Enrollment WHERE enrollment_id = p_enrollment_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Enrollment not found';
    END IF;

    -- Update payment status
    UPDATE Enrollment
    SET payment_status = 'PAID',
        payment_method = p_payment_method
    WHERE enrollment_id = p_enrollment_id;

    COMMIT;
END$$

-- Procedure 3: Get Student Academic Summary
CREATE PROCEDURE GetStudentAcademicSummary(IN p_student_id INT)
BEGIN
    SELECT
        s.Student_ID,
        CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
        d.Dept_name,
        COUNT(c.course_id) AS Enrolled_Courses,
        SUM(c.credits) AS Total_Credits,
        AVG(c.credits) AS Average_Credits
    FROM Student s
    LEFT JOIN Department d ON s.Dept_ID = d.Dept_ID
    LEFT JOIN Courses c ON s.Student_ID = c.student_id
    WHERE s.Student_ID = p_student_id
    GROUP BY s.Student_ID, s.First_name, s.Last_name, d.Dept_name;
END$$

-- Procedure 4: Generate Department Report
CREATE PROCEDURE GenerateDepartmentReport(IN p_dept_id INT)
BEGIN
    SELECT
        d.Dept_ID,
        d.Dept_name,
        COUNT(DISTINCT s.Student_ID) AS Total_Students,
        COUNT(DISTINCT p.professor_id) AS Total_Faculty,
        COUNT(DISTINCT c.course_id) AS Total_Courses,
        SUM(c.credits) AS Total_Credits
    FROM Department d
    LEFT JOIN Student s ON d.Dept_ID = s.Dept_ID
    LEFT JOIN Professors p ON d.Dept_ID = p.Dept_ID
    LEFT JOIN Courses c ON d.Dept_ID = c.Dept_ID
    WHERE d.Dept_ID = p_dept_id
    GROUP BY d.Dept_ID, d.Dept_name;
END$$

DELIMITER ;

-- ============================================================
-- TRIGGERS FOR AUDIT & INTEGRITY
-- ============================================================

-- Note: These triggers would track changes if an audit table exists
-- Example structure for audit table:
-- CREATE TABLE Enrollment_Audit (
--     audit_id INT AUTO_INCREMENT PRIMARY KEY,
--     enrollment_id INT,
--     old_status VARCHAR(20),
--     new_status VARCHAR(20),
--     changed_date DATETIME,
--     changed_by VARCHAR(50)
-- );

-- ============================================================
-- TRANSACTION EXAMPLES
-- ============================================================

-- TRANSACTION 1: Complete Student Enrollment Process
-- BEGIN;
--   INSERT INTO Enrollment (enrollment_date, payment_status, student_id)
--   VALUES (CURDATE(), 'PENDING', 1);
--   
--   SET @enrollment_id = LAST_INSERT_ID();
--   
--   UPDATE Enrollment
--   SET payment_status = 'PAID'
--   WHERE enrollment_id = @enrollment_id;
--   
-- COMMIT;

-- TRANSACTION 2: WITH ROLLBACK on Error
-- START TRANSACTION;
--   DELETE FROM Courses WHERE course_id = 999;
--   -- If an error occurs before COMMIT, automatically ROLLBACK
-- COMMIT;

-- TRANSACTION 3: SAVEPOINT Example
-- START TRANSACTION;
--   INSERT INTO Student VALUES (NULL, 'John', 'Doe', 'john@example.com', '9999999999', '2000-01-01', CURDATE(), 1);
--   SAVEPOINT sp1;
--   
--   INSERT INTO Enrollment VALUES (NULL, CURDATE(), 'PENDING', NULL, NULL, 1);
--   SAVEPOINT sp2;
--   
--   -- If something goes wrong, rollback to sp1
--   ROLLBACK TO SAVEPOINT sp1;
--   
-- COMMIT;

-- ============================================================
-- DATA VALIDATION QUERIES
-- ============================================================

-- Check for orphaned records (referential integrity)
SELECT
    'Orphaned Student Records' AS Issue,
    COUNT(*) AS Count
FROM Student
WHERE Dept_ID NOT IN (SELECT Dept_ID FROM Department);

-- Check for null values in required fields
SELECT
    'Null Student Names' AS Issue,
    COUNT(*) AS Count
FROM Student
WHERE First_name IS NULL OR Last_name IS NULL;

-- Check for duplicate emails
SELECT
    'Duplicate Emails' AS Issue,
    email,
    COUNT(*) AS Count
FROM Student
GROUP BY email
HAVING COUNT(*) > 1;

-- ============================================================
-- BACKUP RECOMMENDATIONS
-- ============================================================

-- Backup command (execute in shell):
-- mysqldump -u admin_user -p DBMS_Sem3 > DBMS_Sem3_backup_$(date +%Y%m%d_%H%M%S).sql

-- Restore command (execute in shell):
-- mysql -u admin_user -p DBMS_Sem3 < DBMS_Sem3_backup_YYYYMMDD_HHMMSS.sql

-- ============================================================
-- PERFORMANCE MONITORING
-- ============================================================

-- Check slow queries (enable slow query log in my.cnf):
-- slow_query_log = 1
-- slow_query_log_file = /var/log/mysql/slow.log
-- long_query_time = 2

-- ============================================================
-- End of Security Configuration
-- ============================================================
