!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create stored procedure for processing customer staging data
CREATE OR REPLACE PROCEDURE sp_process_customer_staging()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET result STRING := '';
    LET processed_count NUMBER := 0;
    
    -- Clear staging table
    TRUNCATE TABLE stg_customers;
    
    -- Process raw customer data with transformations and quality checks
    INSERT INTO stg_customers (
        customer_id,
        customer_key,
        first_name,
        last_name,
        full_name,
        email,
        email_domain,
        phone,
        phone_cleaned,
        address,
        city,
        state,
        country,
        postal_code,
        customer_segment,
        registration_date,
        customer_age_days,
        is_active,
        data_quality_score,
        data_quality_flags,
        source_system
    )
    SELECT 
        customer_id,
        customer_key,
        INITCAP(TRIM(first_name)) AS first_name,
        INITCAP(TRIM(last_name)) AS last_name,
        CONCAT(INITCAP(TRIM(first_name)), ' ', INITCAP(TRIM(last_name))) AS full_name,
        LOWER(TRIM(email)) AS email,
        SUBSTR(LOWER(TRIM(email)), POSITION('@', LOWER(TRIM(email))) + 1) AS email_domain,
        phone,
        REGEXP_REPLACE(phone, '[^0-9]', '') AS phone_cleaned,
        address,
        INITCAP(TRIM(city)) AS city,
        UPPER(TRIM(state)) AS state,
        INITCAP(TRIM(country)) AS country,
        TRIM(postal_code) AS postal_code,
        UPPER(TRIM(customer_segment)) AS customer_segment,
        registration_date,
        DATEDIFF('day', registration_date, CURRENT_DATE()) AS customer_age_days,
        is_active,
        -- Data quality score calculation
        CASE 
            WHEN first_name IS NULL OR first_name = '' THEN 0.8
            WHEN last_name IS NULL OR last_name = '' THEN 0.8
            WHEN email IS NULL OR email = '' OR NOT CONTAINS(email, '@') THEN 0.6
            WHEN phone IS NULL OR phone = '' THEN 0.9
            ELSE 1.0
        END AS data_quality_score,
        -- Data quality flags
        ARRAY_TO_STRING(
            ARRAY_COMPACT([
                IFF(first_name IS NULL OR first_name = '', 'MISSING_FIRST_NAME', NULL),
                IFF(last_name IS NULL OR last_name = '', 'MISSING_LAST_NAME', NULL),
                IFF(email IS NULL OR email = '' OR NOT CONTAINS(email, '@'), 'INVALID_EMAIL', NULL),
                IFF(phone IS NULL OR phone = '', 'MISSING_PHONE', NULL)
            ]), 
            ','
        ) AS data_quality_flags,
        source_system
    FROM RAW.raw_customers;
    
    processed_count := (SELECT COUNT(*) FROM stg_customers);
    result := 'Successfully processed ' || processed_count || ' customer records';
    
    RETURN result;
END;
$$
COMMENT = 'Process raw customer data into staging with quality checks';