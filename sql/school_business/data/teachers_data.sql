-- Change History Information
-- VERSION:      1.0.2
-- DESCRIPTION:  Insert sample data into TEACHERS table
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: teachers.sql
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

!set variable_substitution=true;

USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Insert sample teachers data
INSERT INTO TEACHERS (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, SUBJECT, DEPARTMENT, SALARY, STATUS) VALUES
('Alice', 'Johnson', 'alice.johnson@school.edu', '555-123-4567', '2020-01-15', 'Mathematics', 'Math Department', 65000.00, 'ACTIVE'),
('Bob', 'Williams', 'bob.williams@school.edu', '555-987-6543', '2019-08-01', 'Physics', 'Science Department', 68000.00, 'ACTIVE'),
('Carol', 'Davis', 'carol.davis@school.edu', '555-246-8135', '2021-02-01', 'English Literature', 'English Department', 62000.00, 'ACTIVE'),
('David', 'Miller', 'david.miller@school.edu', '555-369-2580', '2020-06-15', 'World History', 'Social Studies Department', 64000.00, 'ACTIVE'),
('Emma', 'Wilson', 'emma.wilson@school.edu', '555-147-2583', '2018-09-10', 'Chemistry', 'Science Department', 67000.00, 'ACTIVE'),
('Frank', 'Thompson', 'frank.thompson@school.edu', '555-741-9630', '2022-01-20', 'Physical Education', 'PE Department', 58000.00, 'ACTIVE'),
('Grace', 'Lee', 'grace.lee@school.edu', '555-852-7410', '2019-03-15', 'Art', 'Arts Department', 60000.00, 'ACTIVE'),
('Henry', 'Clark', 'henry.clark@school.edu', '555-963-8520', '2021-08-25', 'Music', 'Arts Department', 61000.00, 'ACTIVE'),
('Isabella', 'Lopez', 'isabella.lopez@school.edu', '555-159-7530', '2020-11-05', 'Spanish', 'Language Department', 63000.00, 'ACTIVE'),
('James', 'White', 'james.white@school.edu', '555-357-4680', '2017-05-12', 'Biology', 'Science Department', 69000.00, 'RETIRED');

-- Verify the insert
SELECT COUNT(*) AS TOTAL_TEACHERS FROM TEACHERS;
SELECT DEPARTMENT, COUNT(*) AS TEACHER_COUNT FROM TEACHERS WHERE STATUS = 'ACTIVE' GROUP BY DEPARTMENT ORDER BY DEPARTMENT;