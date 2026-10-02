-- ============================================================
-- UNIVERSITY COURSE MANAGEMENT & ENROLLMENT SYSTEM
-- Database Schema Definition (DDL)
-- ============================================================
-- Database: DBMS_Sem3
-- Description: A comprehensive database system for managing
--              university academic operations including students,
--              professors, departments, courses, and enrollments
-- ============================================================

-- Create Database
CREATE DATABASE DBMS_Sem3;
USE DBMS_Sem3;

-- ============================================================
-- TABLE: Department
-- ============================================================
CREATE TABLE Department (
    Dept_ID INT AUTO_INCREMENT PRIMARY KEY,
    Dept_name VARCHAR(80) NOT NULL,
    Department_code VARCHAR(15) UNIQUE,
    Student_ID INT
);

-- ============================================================
-- TABLE: Student
-- ============================================================
CREATE TABLE Student (
    Student_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_name VARCHAR(80) NOT NULL,
    Last_name VARCHAR(80) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_no CHAR(10) UNIQUE NOT NULL,
    Date_of_birth DATE,
    Enrollment_date DATE NOT NULL,
    Dept_ID INT,
    CONSTRAINT fk_student_department 
        FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- ============================================================
-- TABLE: Professors
-- ============================================================
CREATE TABLE Professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    Type_of_faculty VARCHAR(20),
    student_id INT,
    Dept_ID INT,
    CONSTRAINT fk_professor_student 
        FOREIGN KEY (student_id) REFERENCES Student(Student_ID),
    CONSTRAINT fk_professor_department 
        FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- ============================================================
-- TABLE: Courses
-- ============================================================
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(15) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    student_id INT,
    Dept_ID INT,
    CONSTRAINT fk_courses_student 
        FOREIGN KEY (student_id) REFERENCES Student(Student_ID),
    CONSTRAINT fk_courses_department 
        FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- ============================================================
-- TABLE: Enrollment
-- ============================================================
CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_date DATE NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    permanent_address VARCHAR(255),
    payment_method VARCHAR(30),
    student_id INT NOT NULL,
    CONSTRAINT fk_enrollment_student 
        FOREIGN KEY (student_id) REFERENCES Student(Student_ID)
);

-- ============================================================
-- INDEXES for Performance Optimization
-- ============================================================
CREATE INDEX idx_student_dept ON Student(Dept_ID);
CREATE INDEX idx_student_email ON Student(email);
CREATE INDEX idx_student_phone ON Student(phone_no);
CREATE INDEX idx_professor_dept ON Professors(Dept_ID);
CREATE INDEX idx_professor_email ON Professors(email);
CREATE INDEX idx_courses_dept ON Courses(Dept_ID);
CREATE INDEX idx_courses_code ON Courses(course_code);
CREATE INDEX idx_enrollment_student ON Enrollment(student_id);
CREATE INDEX idx_enrollment_status ON Enrollment(payment_status);
CREATE INDEX idx_enrollment_date ON Enrollment(enrollment_date);

-- ============================================================
-- VIEWS for Simplified Data Access
-- ============================================================

-- View 1: Student Course Information
CREATE VIEW v_student_courses AS
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    c.course_code,
    c.title AS Course_Name,
    c.credits,
    d.Dept_name
FROM Student s
INNER JOIN Courses c ON s.Student_ID = c.student_id
INNER JOIN Department d ON c.Dept_ID = d.Dept_ID;

-- View 2: Enrollment Status Summary
CREATE VIEW v_enrollment_summary AS
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    e.enrollment_date,
    e.payment_status,
    e.payment_method,
    d.Dept_name
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.student_id
INNER JOIN Department d ON s.Dept_ID = d.Dept_ID;

-- View 3: Professor Department View
CREATE VIEW v_professor_department AS
SELECT
    p.professor_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Professor_Name,
    p.email,
    p.phone_number,
    p.hire_date,
    p.Type_of_faculty,
    d.Dept_name,
    d.Department_code
FROM Professors p
LEFT JOIN Department d ON p.Dept_ID = d.Dept_ID;

-- View 4: Department Course Statistics
CREATE VIEW v_department_courses AS
SELECT
    d.Dept_ID,
    d.Dept_name,
    COUNT(c.course_id) AS Number_of_Courses,
    SUM(c.credits) AS Total_Credits
FROM Department d
LEFT JOIN Courses c ON d.Dept_ID = c.Dept_ID
GROUP BY d.Dept_ID, d.Dept_name;

-- View 5: Pending Payments
CREATE VIEW v_pending_payments AS
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email,
    s.phone_no,
    e.enrollment_id,
    e.enrollment_date,
    e.permanent_address
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.student_id
WHERE e.payment_status = 'PENDING';

-- ============================================================
-- End of Schema Definition
-- ============================================================
