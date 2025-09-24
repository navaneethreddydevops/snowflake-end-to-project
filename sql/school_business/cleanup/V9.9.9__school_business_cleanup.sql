-- Change History Information
-- VERSION:      9.9.9
-- DESCRIPTION:  Complete cleanup script for school business database - USE FOR TESTING ONLY
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: None (cleanup script)
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

-- ⚠️  WARNING: This script will completely destroy all school business data and objects
-- ⚠️  Use only for testing purposes or when completely rebuilding the environment
-- ⚠️  Make sure you have backups if you need to preserve any data

!set variable_substitution=true;

-- Stop all tasks first to prevent them from running during cleanup
USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Suspend all tasks (if they exist and are running)
ALTER TASK IF EXISTS TSK_UPDATE_ENROLLMENT_STATS SUSPEND;
ALTER TASK IF EXISTS TSK_ATTENDANCE_ALERTS SUSPEND;
ALTER TASK IF EXISTS TSK_UPDATE_GRADUATION_STATUS SUSPEND;
ALTER TASK IF EXISTS TSK_CLEANUP_LOGS SUSPEND;
ALTER TASK IF EXISTS TSK_WEEKLY_PERFORMANCE_REPORT SUSPEND;

-- Wait a moment for tasks to stop
CALL SYSTEM$WAIT(5);

-- Drop all tasks
DROP TASK IF EXISTS TSK_UPDATE_ENROLLMENT_STATS;
DROP TASK IF EXISTS TSK_ATTENDANCE_ALERTS;
DROP TASK IF EXISTS TSK_UPDATE_GRADUATION_STATUS;
DROP TASK IF EXISTS TSK_CLEANUP_LOGS;
DROP TASK IF EXISTS TSK_WEEKLY_PERFORMANCE_REPORT;

-- Drop all procedures
DROP PROCEDURE IF EXISTS SP_ENROLL_STUDENT(INT, INT, DATE);
DROP PROCEDURE IF EXISTS SP_UPDATE_GRADE(INT, INT, DECIMAL, VARCHAR, DECIMAL, DECIMAL);
DROP PROCEDURE IF EXISTS SP_GET_STUDENT_TRANSCRIPT(INT);
DROP PROCEDURE IF EXISTS SP_WITHDRAW_STUDENT(INT, INT, VARCHAR);
DROP PROCEDURE IF EXISTS SP_CALCULATE_STUDENT_GPA(INT);
DROP PROCEDURE IF EXISTS SP_GET_COURSE_ROSTER(INT);

-- Drop all views
DROP VIEW IF EXISTS VW_STUDENT_ENROLLMENT_SUMMARY;
DROP VIEW IF EXISTS VW_TEACHER_COURSE_LOAD;
DROP VIEW IF EXISTS VW_COURSE_ENROLLMENT_DETAILS;
DROP VIEW IF EXISTS VW_DEPARTMENT_SUMMARY;
DROP VIEW IF EXISTS VW_STUDENT_TRANSCRIPT;
DROP VIEW IF EXISTS VW_ACADEMIC_PERFORMANCE_ANALYTICS;

-- Drop tables in correct order (considering foreign key dependencies)
-- First, drop tables that reference others
DROP TABLE IF EXISTS ENROLLMENTS;
DROP TABLE IF EXISTS COURSES;

-- Then drop the remaining tables
DROP TABLE IF EXISTS STUDENTS;
DROP TABLE IF EXISTS TEACHERS;

-- Drop system tables
DROP TABLE IF EXISTS SYSTEM_LOG;
DROP TABLE IF EXISTS ENROLLMENT_STATS_HISTORY;

-- Drop schema (this will catch any remaining objects)
DROP SCHEMA IF EXISTS SCHOOL_BUSINESS_SCHEMA;

-- Switch to ACCOUNTADMIN for user and role cleanup
USE ROLE ACCOUNTADMIN;

-- Drop users first (must be done before dropping their assigned roles)
DROP USER IF EXISTS SCHOOL_BUSINESS_DB_READ_USER;
DROP USER IF EXISTS SCHOOL_BUSINESS_DB_READ_WRITE_USER;

-- Drop custom roles
DROP ROLE IF EXISTS SCHOOL_BUSINESS_DB_READ_ROLE;
DROP ROLE IF EXISTS SCHOOL_BUSINESS_DB_READ_WRITE_ROLE;

-- Switch back to SYSADMIN for warehouse and database cleanup
USE ROLE SYSADMIN;

-- Drop warehouse
DROP WAREHOUSE IF EXISTS SCHOOL_BUSINESS_WH;

-- Drop database (this will cascade to any remaining objects)
DROP DATABASE IF EXISTS SCHOOL_BUSINESS_DB;

-- Verification queries (these should return empty results or errors if cleanup was successful)
-- Uncomment these lines if you want to verify the cleanup

/*
-- These queries should fail or return no results after cleanup
SHOW DATABASES LIKE 'SCHOOL_BUSINESS_DB';
SHOW WAREHOUSES LIKE 'SCHOOL_BUSINESS_WH';

USE ROLE ACCOUNTADMIN;
SHOW USERS LIKE 'SCHOOL_BUSINESS_DB_%';
SHOW ROLES LIKE 'SCHOOL_BUSINESS_DB_%';
*/

-- Final confirmation message
SELECT 'School Business Database cleanup completed successfully!' AS CLEANUP_STATUS,
       CURRENT_TIMESTAMP() AS CLEANUP_COMPLETED_AT;