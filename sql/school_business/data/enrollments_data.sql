-- Change History Information
-- VERSION:      1.0.2
-- DESCRIPTION:  Insert sample data into ENROLLMENTS table
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: enrollments.sql, students_data.sql, courses_data.sql
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

!set variable_substitution=true;

USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Insert sample enrollments data
INSERT INTO ENROLLMENTS (STUDENT_ID, COURSE_ID, ENROLLMENT_DATE, GRADE, LETTER_GRADE, STATUS, ATTENDANCE_PERCENTAGE, FINAL_EXAM_SCORE, MIDTERM_SCORE) VALUES
-- John Doe's enrollments
(1, 1, '2021-09-01', 3.5, 'B+', 'COMPLETED', 95.0, 87.5, 82.0),
(1, 2, '2021-09-01', 3.8, 'A-', 'COMPLETED', 98.0, 92.0, 88.5),
(1, 3, '2022-01-15', NULL, NULL, 'ACTIVE', 87.5, NULL, 78.0),
(1, 5, '2022-01-15', 3.2, 'B-', 'COMPLETED', 92.0, 78.5, 85.0),

-- Jane Smith's enrollments  
(2, 1, '2021-09-01', 3.9, 'A-', 'COMPLETED', 96.5, 94.0, 91.5),
(2, 2, '2021-09-01', 4.0, 'A', 'COMPLETED', 100.0, 98.0, 96.0),
(2, 4, '2022-01-15', NULL, NULL, 'ACTIVE', 90.0, NULL, 85.5),
(2, 6, '2022-01-15', 3.7, 'A-', 'COMPLETED', 94.0, 89.0, 87.5),

-- Michael Johnson's enrollments
(3, 1, '2021-09-01', 2.8, 'B-', 'COMPLETED', 78.5, 72.0, 75.5),
(3, 3, '2021-09-01', 3.2, 'B', 'COMPLETED', 85.0, 80.0, 78.0),
(3, 7, '2022-01-15', NULL, NULL, 'ACTIVE', 92.0, NULL, 88.0),
(3, 8, '2022-01-15', 3.6, 'A-', 'COMPLETED', 96.0, 91.0, 85.5),

-- Emily Brown's enrollments
(4, 2, '2022-01-15', NULL, NULL, 'ACTIVE', 88.0, NULL, 82.5),
(4, 4, '2022-01-15', NULL, NULL, 'ACTIVE', 93.5, NULL, 89.0),
(4, 9, '2022-01-15', 3.4, 'B+', 'COMPLETED', 89.5, 84.0, 86.5),
(4, 10, '2022-01-15', 3.8, 'A-', 'COMPLETED', 97.0, 93.5, 90.0),

-- David Wilson's enrollments
(5, 1, '2021-09-01', 3.3, 'B+', 'COMPLETED', 88.0, 81.5, 84.0),
(5, 6, '2021-09-01', 3.1, 'B', 'COMPLETED', 82.5, 76.0, 79.5),
(5, 7, '2022-01-15', NULL, NULL, 'ACTIVE', 95.0, NULL, 92.0),
(5, 14, '2022-01-15', NULL, NULL, 'ACTIVE', 91.0, NULL, 87.5),

-- Sarah Davis's enrollments
(6, 3, '2022-01-15', NULL, NULL, 'ACTIVE', 92.5, NULL, 88.5),
(6, 8, '2022-01-15', 3.9, 'A-', 'COMPLETED', 98.5, 95.0, 92.5),
(6, 10, '2022-01-15', 3.7, 'A-', 'COMPLETED', 94.0, 89.5, 91.0),
(6, 12, '2022-01-15', NULL, NULL, 'ACTIVE', 86.0, NULL, 83.5),

-- Robert Miller's enrollments
(7, 2, '2021-09-01', 3.0, 'B', 'COMPLETED', 80.0, 74.5, 77.0),
(7, 4, '2021-09-01', 3.5, 'B+', 'COMPLETED', 91.5, 86.0, 83.5),
(7, 11, '2022-01-15', NULL, NULL, 'DROPPED', 45.0, NULL, 62.0),
(7, 14, '2022-01-15', NULL, NULL, 'ACTIVE', 89.0, NULL, 85.0),

-- Jessica Garcia's enrollments
(8, 1, '2022-01-15', 3.6, 'A-', 'COMPLETED', 93.0, 88.5, 86.0),
(8, 9, '2022-01-15', 3.8, 'A-', 'COMPLETED', 96.5, 92.0, 89.5),
(8, 10, '2022-01-15', 3.4, 'B+', 'COMPLETED', 87.5, 82.0, 85.5),
(8, 12, '2022-01-15', NULL, NULL, 'ACTIVE', 90.5, NULL, 87.0);

-- Verify the insert
SELECT COUNT(*) AS TOTAL_ENROLLMENTS FROM ENROLLMENTS;
SELECT STATUS, COUNT(*) AS ENROLLMENT_COUNT FROM ENROLLMENTS GROUP BY STATUS;
SELECT 
    s.FIRST_NAME || ' ' || s.LAST_NAME AS STUDENT_NAME,
    COUNT(e.COURSE_ID) AS ENROLLED_COURSES
FROM STUDENTS s
LEFT JOIN ENROLLMENTS e ON s.STUDENT_ID = e.STUDENT_ID
GROUP BY s.STUDENT_ID, s.FIRST_NAME, s.LAST_NAME
ORDER BY s.STUDENT_ID;