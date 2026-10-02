-- ============================================================
-- UNIVERSITY COURSE MANAGEMENT & ENROLLMENT SYSTEM
-- Complex Query Demonstrations & Analysis
-- ============================================================

USE DBMS_Sem3;

-- ============================================================
-- QUERY 1: Display all students and their departments
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email,
    s.phone_no,
    d.Dept_name,
    s.Enrollment_date
FROM Student s
LEFT JOIN Department d ON s.Dept_ID = d.Dept_ID;

-- ============================================================
-- QUERY 2: Show all professors and their department assignments
-- ============================================================
SELECT
    p.professor_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Professor_Name,
    p.email,
    p.Type_of_faculty,
    d.Dept_name
FROM Professors p
LEFT JOIN Department d ON p.Dept_ID = d.Dept_ID;

-- ============================================================
-- QUERY 3: Display all students and the courses associated with them
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    c.course_code,
    c.title AS Course_Name,
    c.credits
FROM Student s
INNER JOIN Courses c ON s.Student_ID = c.student_id;

-- ============================================================
-- QUERY 4: Show students whose enrollment payment is still pending
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email,
    e.Payment_Status,
    e.Enrollment_Date,
    e.enrollment_id
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.student_id
WHERE e.Payment_Status = 'PENDING';

-- ============================================================
-- QUERY 5: Find the number of courses offered under each department
-- ============================================================
SELECT
    d.Dept_ID,
    d.Dept_name,
    COUNT(c.course_id) AS Number_of_Courses,
    SUM(c.credits) AS Total_Credits
FROM Department d
LEFT JOIN Courses c ON d.Dept_ID = c.Dept_ID
GROUP BY d.Dept_ID, d.Dept_name
ORDER BY Number_of_Courses DESC;

-- ============================================================
-- QUERY 6: Find the earliest and latest enrollment dates
-- ============================================================
SELECT
    MIN(Enrollment_Date) AS Earliest_Enrollment,
    MAX(Enrollment_Date) AS Latest_Enrollment,
    COUNT(*) AS Total_Enrollments
FROM Enrollment;

-- ============================================================
-- QUERY 7: Show professors whose department ID is assigned
-- ============================================================
SELECT
    p.professor_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Professor_Name,
    p.Type_of_faculty,
    p.hire_date,
    d.Dept_name
FROM Professors p
INNER JOIN Department d ON p.Dept_ID = d.Dept_ID
WHERE d.Dept_ID IS NOT NULL;

-- ============================================================
-- QUERY 8: COUNT - Total Professors
-- ============================================================
SELECT COUNT(*) AS Total_Professors
FROM Professors;

-- ============================================================
-- QUERY 9: AVERAGE - Average Credits per Course
-- ============================================================
SELECT AVG(credits) AS Average_Credits
FROM Courses;

-- ============================================================
-- QUERY 10: MAX AND MIN - Course Credits
-- ============================================================
SELECT
    MAX(credits) AS Maximum_Credits,
    MIN(credits) AS Minimum_Credits,
    AVG(credits) AS Average_Credits
FROM Courses;

-- ============================================================
-- QUERY 11: SUM - Total Credits
-- ============================================================
SELECT SUM(credits) AS Total_Credits
FROM Courses;

-- ============================================================
-- QUERY 12: GROUP BY - Faculty Type Distribution
-- ============================================================
SELECT
    Type_of_faculty,
    COUNT(*) AS Number_of_Professors
FROM Professors
GROUP BY Type_of_faculty;

-- ============================================================
-- QUERY 13: GROUP BY WITH HAVING - Filter Faculty Groups
-- ============================================================
SELECT
    Type_of_faculty,
    COUNT(*) AS Number_of_Professors
FROM Professors
GROUP BY Type_of_faculty
HAVING COUNT(*) > 2
ORDER BY Number_of_Professors DESC;

-- ============================================================
-- QUERY 14: ORDER BY - Payment Status Summary
-- ============================================================
SELECT
    Payment_Status,
    COUNT(*) AS Number_of_Students
FROM Enrollment
GROUP BY Payment_Status
ORDER BY Number_of_Students DESC;

-- ============================================================
-- QUERY 15: Subquery - Courses with Above-Average Credits
-- ============================================================
SELECT
    course_id,
    course_code,
    title,
    credits
FROM Courses
WHERE credits > (
    SELECT AVG(credits)
    FROM Courses
)
ORDER BY credits DESC;

-- ============================================================
-- QUERY 16: EXISTS - Students with Enrollments
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email
FROM Student s
WHERE EXISTS (
    SELECT 1
    FROM Enrollment e
    WHERE e.student_id = s.Student_ID
);

-- ============================================================
-- QUERY 17: IN - Professors in Specific Departments
-- ============================================================
SELECT
    professor_id,
    CONCAT(first_name, ' ', last_name) AS Professor_Name,
    Type_of_faculty,
    Dept_ID
FROM Professors
WHERE Dept_ID IN (
    SELECT Dept_ID
    FROM Department
    WHERE Dept_ID IS NOT NULL
);

-- ============================================================
-- QUERY 18: CONCAT - Full Names
-- ============================================================
SELECT
    professor_id,
    CONCAT(first_name, ' ', last_name) AS Full_Name,
    email,
    Type_of_faculty
FROM Professors;

-- ============================================================
-- QUERY 19: UPPER - Uppercase Faculty Types
-- ============================================================
SELECT
    professor_id,
    first_name,
    UPPER(Type_of_faculty) AS Faculty_Type_Upper
FROM Professors;

-- ============================================================
-- QUERY 20: LENGTH - Name Character Count
-- ============================================================
SELECT
    professor_id,
    first_name,
    LENGTH(first_name) AS Name_Length
FROM Professors
ORDER BY Name_Length DESC;

-- ============================================================
-- QUERY 21: YEAR - Professors Hired in Specific Year
-- ============================================================
SELECT
    professor_id,
    CONCAT(first_name, ' ', last_name) AS Professor_Name,
    hire_date,
    YEAR(hire_date) AS Hire_Year
FROM Professors
WHERE YEAR(hire_date) >= 2015
ORDER BY hire_date;

-- ============================================================
-- QUERY 22: INNER JOIN - Student Enrollment Details
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    e.enrollment_id,
    e.enrollment_date,
    e.payment_status,
    d.Dept_name
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.student_id
INNER JOIN Department d ON s.Dept_ID = d.Dept_ID;

-- ============================================================
-- QUERY 23: LEFT JOIN - All Students with Enrollment Info
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email,
    e.enrollment_id,
    e.payment_status,
    COALESCE(e.enrollment_date, 'Not Enrolled') AS Enrollment_Status
FROM Student s
LEFT JOIN Enrollment e ON s.Student_ID = e.student_id;

-- ============================================================
-- QUERY 24: RIGHT JOIN - Courses with Student Info
-- ============================================================
SELECT
    c.course_id,
    c.course_code,
    c.title,
    c.credits,
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name
FROM Courses c
RIGHT JOIN Student s ON c.student_id = s.Student_ID;

-- ============================================================
-- QUERY 25: Courses with Credits >= 5
-- ============================================================
SELECT
    c.course_id,
    c.course_code,
    c.title,
    c.credits,
    d.Dept_name
FROM Courses c
RIGHT JOIN Department d ON c.Dept_ID = d.Dept_ID
WHERE c.credits >= 5;

-- ============================================================
-- QUERY 26: Full Student Course Department Info (Complex Join)
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    c.course_code,
    c.title AS Course_Name,
    c.credits,
    d.Dept_name,
    e.payment_status
FROM Student s
INNER JOIN Courses c ON s.Student_ID = c.student_id
INNER JOIN Department d ON c.Dept_ID = d.Dept_ID
LEFT JOIN Enrollment e ON s.Student_ID = e.student_id;

-- ============================================================
-- QUERY 27: Payment Analysis - Status Breakdown
-- ============================================================
SELECT
    payment_status,
    COUNT(*) AS Enrollment_Count,
    COUNT(DISTINCT student_id) AS Unique_Students,
    MIN(enrollment_date) AS Earliest_Date,
    MAX(enrollment_date) AS Latest_Date
FROM Enrollment
GROUP BY payment_status;

-- ============================================================
-- QUERY 28: Department Statistics
-- ============================================================
SELECT
    d.Dept_ID,
    d.Dept_name,
    COUNT(DISTINCT s.Student_ID) AS Total_Students,
    COUNT(DISTINCT p.professor_id) AS Total_Professors,
    COUNT(DISTINCT c.course_id) AS Total_Courses,
    AVG(c.credits) AS Average_Credits
FROM Department d
LEFT JOIN Student s ON d.Dept_ID = s.Dept_ID
LEFT JOIN Professors p ON d.Dept_ID = p.Dept_ID
LEFT JOIN Courses c ON d.Dept_ID = c.Dept_ID
GROUP BY d.Dept_ID, d.Dept_name;

-- ============================================================
-- QUERY 29: Student Enrollment History
-- ============================================================
SELECT
    s.Student_ID,
    CONCAT(s.First_name, ' ', s.Last_name) AS Student_Name,
    s.email,
    COUNT(e.enrollment_id) AS Total_Enrollments,
    SUM(CASE WHEN e.payment_status = 'PENDING' THEN 1 ELSE 0 END) AS Pending_Payments,
    SUM(CASE WHEN e.payment_status = 'PAID' THEN 1 ELSE 0 END) AS Completed_Payments
FROM Student s
LEFT JOIN Enrollment e ON s.Student_ID = e.student_id
GROUP BY s.Student_ID, s.First_name, s.Last_name, s.email;

-- ============================================================
-- QUERY 30: High Credit Courses Analysis
-- ============================================================
SELECT
    c.course_code,
    c.title,
    c.credits,
    d.Dept_name,
    COUNT(s.Student_ID) AS Enrolled_Students
FROM Courses c
LEFT JOIN Department d ON c.Dept_ID = d.Dept_ID
LEFT JOIN Student s ON c.student_id = s.Student_ID
WHERE c.credits >= 5
GROUP BY c.course_id, c.course_code, c.title, c.credits, d.Dept_name
ORDER BY c.credits DESC;

-- ============================================================
-- End of Query Demonstrations
-- ============================================================
