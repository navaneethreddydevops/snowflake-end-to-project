-- Change History Information
-- VERSION:      1.0.2
-- DESCRIPTION:  Insert sample data into COURSES table
-- CREATED:      2024-09-24
-- AUTHOR:       School Business Team
-- DEPENDENCIES: courses.sql, teachers_data.sql
-- ENVIRONMENT:  ALL (DEV, QA, PROD)

!set variable_substitution=true;

USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Insert sample courses data
INSERT INTO COURSES (COURSE_NAME, COURSE_CODE, DESCRIPTION, CREDITS, TEACHER_ID, SEMESTER, ACADEMIC_YEAR, MAX_ENROLLMENT, STATUS) VALUES
('Algebra I', 'MATH101', 'Introduction to Algebra - fundamental concepts and problem solving', 3, 1, 'Fall', '2023-2024', 25, 'ACTIVE'),
('Physics I', 'PHYS101', 'Fundamentals of Physics - mechanics and thermodynamics', 4, 2, 'Fall', '2023-2024', 20, 'ACTIVE'),
('English Composition', 'ENG101', 'Basic writing and composition skills for academic success', 3, 3, 'Fall', '2023-2024', 30, 'ACTIVE'),
('World History', 'HIST101', 'Survey of world history from ancient civilizations to modern times', 3, 4, 'Fall', '2023-2024', 28, 'ACTIVE'),
('Geometry', 'MATH201', 'Introduction to geometric principles and proofs', 3, 1, 'Spring', '2023-2024', 25, 'ACTIVE'),
('Chemistry I', 'CHEM101', 'Basic principles of chemistry and laboratory techniques', 4, 5, 'Fall', '2023-2024', 18, 'ACTIVE'),
('Physical Education', 'PE101', 'Introduction to fitness and wellness concepts', 2, 6, 'Fall', '2023-2024', 35, 'ACTIVE'),
('Art Fundamentals', 'ART101', 'Basic drawing and painting techniques', 3, 7, 'Fall', '2023-2024', 20, 'ACTIVE'),
('Music Theory', 'MUS101', 'Introduction to musical notation and theory', 3, 8, 'Fall', '2023-2024', 15, 'ACTIVE'),
('Spanish I', 'SPAN101', 'Beginning Spanish language and culture', 3, 9, 'Fall', '2023-2024', 22, 'ACTIVE'),
('Advanced Physics', 'PHYS201', 'Advanced topics in physics including electricity and magnetism', 4, 2, 'Spring', '2023-2024', 15, 'ACTIVE'),
('Creative Writing', 'ENG201', 'Advanced writing techniques for fiction and poetry', 3, 3, 'Spring', '2023-2024', 18, 'ACTIVE'),
('American History', 'HIST201', 'Comprehensive study of American history', 3, 4, 'Spring', '2023-2024', 25, 'INACTIVE'),
('Calculus I', 'MATH301', 'Introduction to differential and integral calculus', 4, 1, 'Spring', '2023-2024', 20, 'ACTIVE'),
('Biology I', 'BIO101', 'Introduction to biological systems and processes', 4, 10, 'Fall', '2023-2024', 22, 'CANCELLED');

-- Verify the insert
SELECT COUNT(*) AS TOTAL_COURSES FROM COURSES;
SELECT STATUS, COUNT(*) AS COURSE_COUNT FROM COURSES GROUP BY STATUS;
SELECT SEMESTER, COUNT(*) AS COURSE_COUNT FROM COURSES WHERE STATUS = 'ACTIVE' GROUP BY SEMESTER;