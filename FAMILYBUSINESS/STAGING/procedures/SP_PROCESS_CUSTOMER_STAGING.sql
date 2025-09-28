!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create stored procedure for processing customer staging data
CREATE OR REPLACE PROCEDURE SP_PROCESS_CUSTOMER_STAGING()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET RESULT STRING := '';
    LET PROCESSED_COUNT NUMBER := 0;
    
    -- Clear staging table
    TRUNCATE TABLE STG_CUSTOMERS;
    
    -- Process raw customer data with transformations and quality checks
    INSERT INTO STG_CUSTOMERS (
        CUSTOMER_ID,
        CUSTOMER_KEY,
        FIRST_NAME,
        LAST_NAME,
        FULL_NAME,
        EMAIL,
        EMAIL_DOMAIN,
        PHONE,
        PHONE_CLEANED,
        ADDRESS,
        CITY,
        STATE,
        COUNTRY,
        POSTAL_CODE,
        CUSTOMER_SEGMENT,
        REGISTRATION_DATE,
        CUSTOMER_AGE_DAYS,
        IS_ACTIVE,
        DATA_QUALITY_SCORE,
        DATA_QUALITY_FLAGS,
        SOURCE_SYSTEM
    )
    SELECT 
        CUSTOMER_ID,
        CUSTOMER_KEY,
        INITCAP(TRIM(FIRST_NAME)) AS FIRST_NAME,
        INITCAP(TRIM(LAST_NAME)) AS LAST_NAME,
        CONCAT(INITCAP(TRIM(FIRST_NAME)), ' ', INITCAP(TRIM(LAST_NAME))) AS FULL_NAME,
        LOWER(TRIM(EMAIL)) AS EMAIL,
        SUBSTR(LOWER(TRIM(EMAIL)), POSITION('@', LOWER(TRIM(EMAIL))) + 1) AS EMAIL_DOMAIN,
        PHONE,
        REGEXP_REPLACE(PHONE, '[^0-9]', '') AS PHONE_CLEANED,
        ADDRESS,
        INITCAP(TRIM(CITY)) AS CITY,
        UPPER(TRIM(STATE)) AS STATE,
        INITCAP(TRIM(COUNTRY)) AS COUNTRY,
        TRIM(POSTAL_CODE) AS POSTAL_CODE,
        UPPER(TRIM(CUSTOMER_SEGMENT)) AS CUSTOMER_SEGMENT,
        REGISTRATION_DATE,
        DATEDIFF('day', REGISTRATION_DATE, CURRENT_DATE()) AS CUSTOMER_AGE_DAYS,
        IS_ACTIVE,
        -- Data quality score calculation
        CASE 
            WHEN FIRST_NAME IS NULL OR FIRST_NAME = '' THEN 0.8
            WHEN LAST_NAME IS NULL OR LAST_NAME = '' THEN 0.8
            WHEN EMAIL IS NULL OR EMAIL = '' OR NOT CONTAINS(EMAIL, '@') THEN 0.6
            WHEN PHONE IS NULL OR PHONE = '' THEN 0.9
            ELSE 1.0
        END AS DATA_QUALITY_SCORE,
        -- Data quality flags
        ARRAY_TO_STRING(
            ARRAY_COMPACT([
                IFF(FIRST_NAME IS NULL OR FIRST_NAME = '', 'MISSING_FIRST_NAME', NULL),
                IFF(LAST_NAME IS NULL OR LAST_NAME = '', 'MISSING_LAST_NAME', NULL),
                IFF(EMAIL IS NULL OR EMAIL = '' OR NOT CONTAINS(EMAIL, '@'), 'INVALID_EMAIL', NULL),
                IFF(PHONE IS NULL OR PHONE = '', 'MISSING_PHONE', NULL)
            ]), 
            ','
        ) AS DATA_QUALITY_FLAGS,
        SOURCE_SYSTEM
    FROM RAW.RAW_CUSTOMERS;
    
    SET PROCESSED_COUNT = (SELECT COUNT(*) FROM STG_CUSTOMERS);
    SET RESULT = 'Successfully processed ' || :PROCESSED_COUNT || ' customer records';
    
    RETURN :RESULT;
END;
$$
COMMENT = 'Process raw customer data into staging with quality checks';

-- Grant execution permissions to appropriate roles
GRANT USAGE ON PROCEDURE SP_PROCESS_CUSTOMER_STAGING() TO ROLE &SNOWSQL_ENVVAR_ROLE;