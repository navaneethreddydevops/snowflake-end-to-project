-- Change History Information
-- VERSION:      1.0.4
-- DESCRIPTION:  Create stored procedures for school business operations
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: All table and view creation files
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

!set variable_substitution=true;

USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Procedure to enroll a student in a course
CREATE OR REPLACE PROCEDURE SP_ENROLL_STUDENT(
    P_STUDENT_ID INT,
    P_COURSE_ID INT,
    P_ENROLLMENT_DATE DATE DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Enroll a student in a specific course with validation checks'
AS
$$
DECLARE
    enrollment_count INT DEFAULT 0;
    course_exists INT DEFAULT 0;
    student_exists INT DEFAULT 0;
    course_max_enrollment INT DEFAULT 0;
    current_enrollment INT DEFAULT 0;
    course_status VARCHAR(20);
    student_status VARCHAR(20);
    enrollment_date DATE;
BEGIN
    -- Set default enrollment date if not provided
    IF (P_ENROLLMENT_DATE IS NULL) THEN
        enrollment_date := CURRENT_DATE();
    ELSE
        enrollment_date := P_ENROLLMENT_DATE;
    END IF;
    
    -- Check if student exists and is active
    SELECT COUNT(*), MAX(STATUS) INTO student_exists, student_status 
    FROM STUDENTS WHERE STUDENT_ID = P_STUDENT_ID;
    
    IF (student_exists = 0) THEN
        RETURN 'Error: Student ID ' || P_STUDENT_ID || ' does not exist.';
    END IF;
    
    IF (student_status != 'ACTIVE') THEN
        RETURN 'Error: Student is not in ACTIVE status. Current status: ' || student_status;
    END IF;
    
    -- Check if course exists and get details
    SELECT COUNT(*), MAX(STATUS), MAX(MAX_ENROLLMENT) 
    INTO course_exists, course_status, course_max_enrollment
    FROM COURSES WHERE COURSE_ID = P_COURSE_ID;
    
    IF (course_exists = 0) THEN
        RETURN 'Error: Course ID ' || P_COURSE_ID || ' does not exist.';
    END IF;
    
    IF (course_status != 'ACTIVE') THEN
        RETURN 'Error: Course is not active. Current status: ' || course_status;
    END IF;
    
    -- Check if already enrolled
    SELECT COUNT(*) INTO enrollment_count 
    FROM ENROLLMENTS 
    WHERE STUDENT_ID = P_STUDENT_ID AND COURSE_ID = P_COURSE_ID;
    
    IF (enrollment_count > 0) THEN
        RETURN 'Error: Student is already enrolled in this course.';
    END IF;
    
    -- Check course capacity
    SELECT COUNT(*) INTO current_enrollment 
    FROM ENROLLMENTS 
    WHERE COURSE_ID = P_COURSE_ID AND STATUS IN ('ACTIVE', 'COMPLETED');
    
    IF (current_enrollment >= course_max_enrollment) THEN
        RETURN 'Error: Course is at maximum capacity (' || course_max_enrollment || ' students).';
    END IF;
    
    -- Enroll the student
    INSERT INTO ENROLLMENTS (STUDENT_ID, COURSE_ID, ENROLLMENT_DATE, STATUS)
    VALUES (P_STUDENT_ID, P_COURSE_ID, enrollment_date, 'ACTIVE');
    
    RETURN 'Success: Student enrolled successfully in course on ' || enrollment_date;
END;
$$;

-- Procedure to update student grade and status
CREATE OR REPLACE PROCEDURE SP_UPDATE_GRADE(
    P_STUDENT_ID INT,
    P_COURSE_ID INT,
    P_GRADE DECIMAL(3,2),
    P_LETTER_GRADE VARCHAR(2) DEFAULT NULL,
    P_FINAL_EXAM_SCORE DECIMAL(5,2) DEFAULT NULL,
    P_ATTENDANCE_PERCENTAGE DECIMAL(5,2) DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Update student grade and related academic metrics'
AS
$$
DECLARE
    enrollment_count INT DEFAULT 0;
    calculated_letter_grade VARCHAR(2);
BEGIN
    -- Validate grade range
    IF (P_GRADE < 0.0 OR P_GRADE > 4.0) THEN
        RETURN 'Error: Grade must be between 0.0 and 4.0.';
    END IF;
    
    -- Validate attendance percentage if provided
    IF (P_ATTENDANCE_PERCENTAGE IS NOT NULL AND (P_ATTENDANCE_PERCENTAGE < 0 OR P_ATTENDANCE_PERCENTAGE > 100)) THEN
        RETURN 'Error: Attendance percentage must be between 0 and 100.';
    END IF;
    
    -- Calculate letter grade if not provided
    IF (P_LETTER_GRADE IS NULL) THEN
        CASE 
            WHEN P_GRADE >= 4.0 THEN calculated_letter_grade := 'A';
            WHEN P_GRADE >= 3.7 THEN calculated_letter_grade := 'A-';
            WHEN P_GRADE >= 3.3 THEN calculated_letter_grade := 'B+';
            WHEN P_GRADE >= 3.0 THEN calculated_letter_grade := 'B';
            WHEN P_GRADE >= 2.7 THEN calculated_letter_grade := 'B-';
            WHEN P_GRADE >= 2.3 THEN calculated_letter_grade := 'C+';
            WHEN P_GRADE >= 2.0 THEN calculated_letter_grade := 'C';
            WHEN P_GRADE >= 1.7 THEN calculated_letter_grade := 'C-';
            WHEN P_GRADE >= 1.3 THEN calculated_letter_grade := 'D+';
            WHEN P_GRADE >= 1.0 THEN calculated_letter_grade := 'D';
            ELSE calculated_letter_grade := 'F';
        END CASE;
    ELSE
        calculated_letter_grade := P_LETTER_GRADE;
    END IF;
    
    -- Check if enrollment exists
    SELECT COUNT(*) INTO enrollment_count 
    FROM ENROLLMENTS 
    WHERE STUDENT_ID = P_STUDENT_ID AND COURSE_ID = P_COURSE_ID;
    
    IF (enrollment_count = 0) THEN
        RETURN 'Error: Enrollment record not found for Student ID ' || P_STUDENT_ID || ' and Course ID ' || P_COURSE_ID;
    END IF;
    
    -- Update the grade and related information
    UPDATE ENROLLMENTS 
    SET GRADE = P_GRADE, 
        LETTER_GRADE = calculated_letter_grade,
        STATUS = CASE WHEN P_GRADE >= 1.0 THEN 'COMPLETED' ELSE 'FAILED' END,
        FINAL_EXAM_SCORE = COALESCE(P_FINAL_EXAM_SCORE, FINAL_EXAM_SCORE),
        ATTENDANCE_PERCENTAGE = COALESCE(P_ATTENDANCE_PERCENTAGE, ATTENDANCE_PERCENTAGE),
        UPDATED_AT = CURRENT_TIMESTAMP()
    WHERE STUDENT_ID = P_STUDENT_ID AND COURSE_ID = P_COURSE_ID;
    
    RETURN 'Success: Grade updated to ' || P_GRADE || ' (' || calculated_letter_grade || ') successfully.';
END;
$$;

-- Procedure to get student transcript
CREATE OR REPLACE PROCEDURE SP_GET_STUDENT_TRANSCRIPT(P_STUDENT_ID INT)
RETURNS TABLE (
    COURSE_CODE VARCHAR(20),
    COURSE_NAME VARCHAR(100),
    CREDITS INT,
    SEMESTER VARCHAR(20),
    ACADEMIC_YEAR VARCHAR(10),
    INSTRUCTOR_NAME VARCHAR(101),
    GRADE DECIMAL(3,2),
    LETTER_GRADE VARCHAR(2),
    STATUS VARCHAR(20),
    ENROLLMENT_DATE DATE
)
LANGUAGE SQL
COMMENT = 'Retrieve complete academic transcript for a student'
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            c.COURSE_CODE,
            c.COURSE_NAME,
            c.CREDITS,
            c.SEMESTER,
            c.ACADEMIC_YEAR,
            t.FIRST_NAME || ' ' || t.LAST_NAME AS INSTRUCTOR_NAME,
            e.GRADE,
            e.LETTER_GRADE,
            e.STATUS,
            e.ENROLLMENT_DATE
        FROM ENROLLMENTS e
        JOIN COURSES c ON e.COURSE_ID = c.COURSE_ID
        LEFT JOIN TEACHERS t ON c.TEACHER_ID = t.TEACHER_ID
        WHERE e.STUDENT_ID = P_STUDENT_ID
        ORDER BY e.ENROLLMENT_DATE DESC, c.COURSE_CODE
    );
END;
$$;

-- Procedure to withdraw student from course
CREATE OR REPLACE PROCEDURE SP_WITHDRAW_STUDENT(
    P_STUDENT_ID INT,
    P_COURSE_ID INT,
    P_WITHDRAWAL_REASON VARCHAR(255) DEFAULT 'Student requested withdrawal'
)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Withdraw a student from a course'
AS
$$
DECLARE
    enrollment_count INT DEFAULT 0;
    current_status VARCHAR(20);
BEGIN
    -- Check if enrollment exists and get current status
    SELECT COUNT(*), MAX(STATUS) INTO enrollment_count, current_status
    FROM ENROLLMENTS 
    WHERE STUDENT_ID = P_STUDENT_ID AND COURSE_ID = P_COURSE_ID;
    
    IF (enrollment_count = 0) THEN
        RETURN 'Error: Enrollment record not found.';
    END IF;
    
    IF (current_status NOT IN ('ACTIVE')) THEN
        RETURN 'Error: Cannot withdraw from course. Current status: ' || current_status;
    END IF;
    
    -- Update enrollment status to withdrawn
    UPDATE ENROLLMENTS 
    SET STATUS = 'WITHDRAWN',
        UPDATED_AT = CURRENT_TIMESTAMP()
    WHERE STUDENT_ID = P_STUDENT_ID AND COURSE_ID = P_COURSE_ID;
    
    -- Log the withdrawal (if we had a log table)
    -- INSERT INTO ENROLLMENT_LOG (STUDENT_ID, COURSE_ID, ACTION, REASON, ACTION_DATE)
    -- VALUES (P_STUDENT_ID, P_COURSE_ID, 'WITHDRAWAL', P_WITHDRAWAL_REASON, CURRENT_TIMESTAMP());
    
    RETURN 'Success: Student successfully withdrawn from course.';
END;
$$;

-- Procedure to calculate student GPA
CREATE OR REPLACE PROCEDURE SP_CALCULATE_STUDENT_GPA(P_STUDENT_ID INT)
RETURNS TABLE (
    STUDENT_ID INT,
    STUDENT_NAME VARCHAR(101),
    TOTAL_CREDITS_ATTEMPTED INT,
    TOTAL_CREDITS_EARNED INT,
    CUMULATIVE_GPA DECIMAL(3,2),
    COMPLETED_COURSES INT,
    ACTIVE_COURSES INT,
    TOTAL_COURSES INT
)
LANGUAGE SQL
COMMENT = 'Calculate comprehensive GPA and academic statistics for a student'
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            s.STUDENT_ID,
            s.FIRST_NAME || ' ' || s.LAST_NAME AS STUDENT_NAME,
            SUM(c.CREDITS) AS TOTAL_CREDITS_ATTEMPTED,
            SUM(CASE WHEN e.STATUS = 'COMPLETED' AND e.GRADE >= 1.0 THEN c.CREDITS ELSE 0 END) AS TOTAL_CREDITS_EARNED,
            ROUND(
                SUM(CASE WHEN e.GRADE IS NOT NULL THEN e.GRADE * c.CREDITS ELSE 0 END) / 
                NULLIF(SUM(CASE WHEN e.GRADE IS NOT NULL THEN c.CREDITS ELSE 0 END), 0), 2
            ) AS CUMULATIVE_GPA,
            COUNT(CASE WHEN e.STATUS = 'COMPLETED' THEN 1 END) AS COMPLETED_COURSES,
            COUNT(CASE WHEN e.STATUS = 'ACTIVE' THEN 1 END) AS ACTIVE_COURSES,
            COUNT(e.ENROLLMENT_ID) AS TOTAL_COURSES
        FROM STUDENTS s
        LEFT JOIN ENROLLMENTS e ON s.STUDENT_ID = e.STUDENT_ID
        LEFT JOIN COURSES c ON e.COURSE_ID = c.COURSE_ID
        WHERE s.STUDENT_ID = P_STUDENT_ID
        GROUP BY s.STUDENT_ID, s.FIRST_NAME, s.LAST_NAME
    );
END;
$$;

-- Procedure to generate course roster
CREATE OR REPLACE PROCEDURE SP_GET_COURSE_ROSTER(P_COURSE_ID INT)
RETURNS TABLE (
    STUDENT_ID INT,
    STUDENT_NAME VARCHAR(101),
    EMAIL VARCHAR(100),
    ENROLLMENT_DATE DATE,
    STATUS VARCHAR(20),
    CURRENT_GRADE DECIMAL(3,2),
    ATTENDANCE_PERCENTAGE DECIMAL(5,2)
)
LANGUAGE SQL
COMMENT = 'Get current roster for a specific course'
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            s.STUDENT_ID,
            s.FIRST_NAME || ' ' || s.LAST_NAME AS STUDENT_NAME,
            s.EMAIL,
            e.ENROLLMENT_DATE,
            e.STATUS,
            e.GRADE AS CURRENT_GRADE,
            e.ATTENDANCE_PERCENTAGE
        FROM ENROLLMENTS e
        JOIN STUDENTS s ON e.STUDENT_ID = s.STUDENT_ID
        WHERE e.COURSE_ID = P_COURSE_ID
        ORDER BY s.LAST_NAME, s.FIRST_NAME
    );
END;
$$;

-- Grant execute permissions on procedures
GRANT USAGE ON ALL PROCEDURES IN SCHEMA SCHOOL_BUSINESS_SCHEMA TO ROLE SCHOOL_BUSINESS_DB_READ_WRITE_ROLE;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA SCHOOL_BUSINESS_SCHEMA TO ROLE SCHOOL_BUSINESS_DB_READ_WRITE_ROLE;

-- Grant read-only access to some procedures for reporting
GRANT USAGE ON PROCEDURE SP_GET_STUDENT_TRANSCRIPT(INT) TO ROLE SCHOOL_BUSINESS_DB_READ_ROLE;
GRANT USAGE ON PROCEDURE SP_CALCULATE_STUDENT_GPA(INT) TO ROLE SCHOOL_BUSINESS_DB_READ_ROLE;
GRANT USAGE ON PROCEDURE SP_GET_COURSE_ROSTER(INT) TO ROLE SCHOOL_BUSINESS_DB_READ_ROLE;