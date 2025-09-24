-- Change History Information
-- VERSION:      1.0.2
-- DESCRIPTION:  Insert sample data into STUDENTS table
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: students.sql
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

!set variable_substitution=true;

USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Insert sample students data
INSERT INTO STUDENTS (FIRST_NAME, LAST_NAME, DATE_OF_BIRTH, EMAIL, PHONE_NUMBER, ADDRESS, ENROLLMENT_DATE, STATUS) VALUES
('John', 'Doe', '2005-05-15', 'john.doe@schoolemail.com', '123-456-7890', '123 Main St, Anytown, USA', '2021-09-01', 'ACTIVE'),
('Jane', 'Smith', '2006-08-22', 'jane.smith@schoolemail.com', '987-654-3210', '456 Elm St, Othertown, USA', '2021-09-01', 'ACTIVE'),
('Michael', 'Johnson', '2005-12-10', 'michael.johnson@schoolemail.com', '555-123-4567', '789 Oak Ave, Somewhere, USA', '2021-09-01', 'ACTIVE'),
('Emily', 'Brown', '2006-03-18', 'emily.brown@schoolemail.com', '444-987-6543', '321 Pine St, Anywhere, USA', '2022-01-15', 'ACTIVE'),
('David', 'Wilson', '2005-07-25', 'david.wilson@schoolemail.com', '333-555-7777', '654 Maple Dr, Nowhere, USA', '2021-09-01', 'ACTIVE'),
('Sarah', 'Davis', '2006-11-08', 'sarah.davis@schoolemail.com', '222-888-9999', '987 Cedar Ln, Elsewhere, USA', '2022-01-15', 'ACTIVE'),
('Robert', 'Miller', '2005-09-14', 'robert.miller@schoolemail.com', '111-444-6666', '246 Birch St, Someplace, USA', '2021-09-01', 'ACTIVE'),
('Jessica', 'Garcia', '2006-01-30', 'jessica.garcia@schoolemail.com', '666-222-8888', '135 Spruce Ave, Anyplace, USA', '2022-01-15', 'ACTIVE'),
('Christopher', 'Martinez', '2005-04-12', 'chris.martinez@schoolemail.com', '777-333-5555', '468 Willow Way, Everyplace, USA', '2021-09-01', 'GRADUATED'),
('Ashley', 'Anderson', '2006-06-27', 'ashley.anderson@schoolemail.com', '888-111-4444', '579 Poplar Rd, Noplace, USA', '2022-01-15', 'TRANSFERRED');

-- Verify the insert
SELECT COUNT(*) AS TOTAL_STUDENTS FROM STUDENTS;
SELECT STATUS, COUNT(*) AS COUNT FROM STUDENTS GROUP BY STATUS;