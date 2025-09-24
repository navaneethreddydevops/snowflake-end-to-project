# School Business Database

This directory contains the complete SQL implementation for a school business management system built on Snowflake.

## Project Structure

```
sql/school_business/
├── setup/
│   └── V1.0.0__school_business_setup.sql     # Initial setup (database, warehouse, roles, users)
├── tables/
│   ├── students.sql                          # Students table creation
│   ├── teachers.sql                          # Teachers table creation
│   ├── courses.sql                           # Courses table creation
│   └── enrollments.sql                       # Enrollments table creation
├── data/
│   ├── students_data.sql                     # Sample student data
│   ├── teachers_data.sql                     # Sample teacher data
│   ├── courses_data.sql                      # Sample course data
│   └── enrollments_data.sql                  # Sample enrollment data
├── views/
│   └── V1.0.3__school_business_views.sql     # Reporting and analytics views
├── procedures/
│   └── V1.0.4__school_business_procedures.sql # Stored procedures for operations
├── tasks/
│   └── V1.0.5__school_business_tasks.sql     # Automated tasks and scheduling
├── cleanup/
│   └── V9.9.9__school_business_cleanup.sql   # Complete cleanup script (TESTING ONLY)
└── README.md                                 # This file
```

## Database Schema

### Core Tables

1. **STUDENTS** - Student information and enrollment details
2. **TEACHERS** - Teacher information and employment details  
3. **COURSES** - Course catalog with instructor assignments
4. **ENROLLMENTS** - Student-course enrollment records with grades
5. **SYSTEM_LOG** - System logging for automated tasks
6. **ENROLLMENT_STATS_HISTORY** - Historical statistics tracking

### Key Views

- `VW_STUDENT_ENROLLMENT_SUMMARY` - Student performance overview
- `VW_TEACHER_COURSE_LOAD` - Teacher workload and student metrics
- `VW_COURSE_ENROLLMENT_DETAILS` - Course statistics and performance
- `VW_DEPARTMENT_SUMMARY` - Department-level analytics
- `VW_STUDENT_TRANSCRIPT` - Complete academic records
- `VW_ACADEMIC_PERFORMANCE_ANALYTICS` - Performance analytics

### Stored Procedures

- `SP_ENROLL_STUDENT()` - Enroll student in course with validation
- `SP_UPDATE_GRADE()` - Update student grades and academic status
- `SP_GET_STUDENT_TRANSCRIPT()` - Retrieve student transcript
- `SP_WITHDRAW_STUDENT()` - Withdraw student from course
- `SP_CALCULATE_STUDENT_GPA()` - Calculate comprehensive GPA
- `SP_GET_COURSE_ROSTER()` - Get current course enrollment

### Automated Tasks

- `TSK_UPDATE_ENROLLMENT_STATS` - Daily statistics calculation
- `TSK_ATTENDANCE_ALERTS` - Weekly low attendance monitoring
- `TSK_UPDATE_GRADUATION_STATUS` - Monthly graduation evaluation
- `TSK_CLEANUP_LOGS` - Daily log cleanup
- `TSK_WEEKLY_PERFORMANCE_REPORT` - Weekly performance summary

## Deployment Order

Execute files in this exact order for proper deployment:

1. **Setup**: `setup/V1.0.0__school_business_setup.sql`
2. **Tables**: 
   - `tables/students.sql`
   - `tables/teachers.sql` 
   - `tables/courses.sql`
   - `tables/enrollments.sql`
3. **Sample Data**:
   - `data/students_data.sql`
   - `data/teachers_data.sql`
   - `data/courses_data.sql`
   - `data/enrollments_data.sql`
4. **Views**: `views/V1.0.3__school_business_views.sql`
5. **Procedures**: `procedures/V1.0.4__school_business_procedures.sql`
6. **Tasks**: `tasks/V1.0.5__school_business_tasks.sql`

## Security Model

### Roles

- **SCHOOL_BUSINESS_DB_READ_ROLE**: Read-only access to all data and views
- **SCHOOL_BUSINESS_DB_READ_WRITE_ROLE**: Full CRUD operations on all objects

### Users

- **SCHOOL_BUSINESS_DB_READ_USER**: Reports and analytics user
- **SCHOOL_BUSINESS_DB_READ_WRITE_USER**: Administrative user

### Default Configuration

- Default warehouse: `SCHOOL_BUSINESS_WH`
- Default database: `SCHOOL_BUSINESS_DB`
- Default schema: `SCHOOL_BUSINESS_SCHEMA`

## Task Management

Tasks are created in SUSPENDED state. After deployment, activate them:

```sql
USE ROLE SYSADMIN;
USE DATABASE SCHOOL_BUSINESS_DB;
USE SCHEMA SCHOOL_BUSINESS_SCHEMA;

-- Resume tasks individually
ALTER TASK TSK_UPDATE_ENROLLMENT_STATS RESUME;
ALTER TASK TSK_ATTENDANCE_ALERTS RESUME;
ALTER TASK TSK_UPDATE_GRADUATION_STATUS RESUME;
ALTER TASK TSK_CLEANUP_LOGS RESUME;
ALTER TASK TSK_WEEKLY_PERFORMANCE_REPORT RESUME;
```

## Sample Queries

### Student Performance Report
```sql
SELECT * FROM VW_STUDENT_ENROLLMENT_SUMMARY 
WHERE AVERAGE_GRADE < 2.0;
```

### Department Statistics
```sql
SELECT * FROM VW_DEPARTMENT_SUMMARY 
ORDER BY TOTAL_STUDENTS_ENROLLED DESC;
```

### Course Enrollment Status
```sql
SELECT * FROM VW_COURSE_ENROLLMENT_DETAILS 
WHERE ENROLLMENT_PERCENTAGE > 90;
```

### Enroll Student Example
```sql
CALL SP_ENROLL_STUDENT(1, 5, '2024-01-15');
```

## Testing and Cleanup

⚠️ **WARNING**: The cleanup script will destroy ALL data and objects!

For testing purposes only:
```sql
-- Complete cleanup (USE WITH EXTREME CAUTION)
@cleanup/V9.9.9__school_business_cleanup.sql
```

## Environment Variables

The scripts support environment variable substitution:
- `&SNOWSQL_ENVVAR_DB` - Database name override
- `&SNOWSQL_ENVVAR_WH` - Warehouse name override  
- `&SNOWSQL_ENVVAR_SCHEMA` - Schema name override

## Monitoring and Logging

All automated tasks log their activities to the `SYSTEM_LOG` table:

```sql
-- View recent task logs
SELECT * FROM SYSTEM_LOG 
WHERE LOG_SOURCE LIKE 'TSK_%' 
ORDER BY LOG_DATE DESC 
LIMIT 100;
```

## Support and Maintenance

- All tables include audit fields (`CREATED_AT`, `UPDATED_AT`)
- Comprehensive constraints and data validation
- Automated cleanup and maintenance tasks
- Performance optimized with appropriate indexes
- Full documentation and comments throughout

## Version History

- **V1.0.0**: Initial setup (database, warehouse, roles, users)
- **V1.0.1**: Table creation with constraints and indexes
- **V1.0.2**: Sample data insertion
- **V1.0.3**: Reporting views and analytics
- **V1.0.4**: Stored procedures for operations
- **V1.0.5**: Automated tasks and scheduling
- **V9.9.9**: Complete cleanup script for testing