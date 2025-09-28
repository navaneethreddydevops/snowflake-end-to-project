!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create stored procedure for processing order staging data
CREATE OR REPLACE PROCEDURE sp_process_order_staging()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET result STRING := '';
    LET processed_count NUMBER := 0;
    
    -- Clear staging table
    TRUNCATE TABLE stg_orders;
    
    -- Process raw order data with transformations and quality checks
    INSERT INTO stg_orders (
        order_id,
        customer_id,
        order_date,
        order_status,
        order_status_cleaned,
        total_amount,
        currency_code,
        payment_method,
        payment_method_cleaned,
        shipping_address,
        billing_address,
        sales_channel,
        sales_channel_cleaned,
        sales_rep_id,
        region,
        region_cleaned,
        order_year,
        order_month,
        order_quarter,
        order_day_of_week,
        is_weekend,
        data_quality_score,
        data_quality_flags,
        source_system
    )
    SELECT 
        order_id,
        customer_id,
        order_date,
        order_status,
        UPPER(TRIM(order_status)) AS order_status_cleaned,
        total_amount,
        UPPER(TRIM(currency_code)) AS currency_code,
        payment_method,
        UPPER(TRIM(payment_method)) AS payment_method_cleaned,
        shipping_address,
        billing_address,
        sales_channel,
        UPPER(TRIM(sales_channel)) AS sales_channel_cleaned,
        sales_rep_id,
        region,
        UPPER(TRIM(region)) AS region_cleaned,
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        QUARTER(order_date) AS order_quarter,
        DAYNAME(order_date) AS order_day_of_week,
        DAYOFWEEK(order_date) IN (1, 7) AS is_weekend, -- Sunday = 1, Saturday = 7
        -- Data quality score calculation
        CASE 
            WHEN customer_id IS NULL THEN 0.5
            WHEN order_date IS NULL THEN 0.6
            WHEN total_amount IS NULL OR total_amount <= 0 THEN 0.7
            WHEN order_status IS NULL OR order_status = '' THEN 0.9
            ELSE 1.0
        END AS data_quality_score,
        -- Data quality flags
        ARRAY_TO_STRING(
            ARRAY_COMPACT([
                IFF(customer_id IS NULL, 'MISSING_CUSTOMER_ID', NULL),
                IFF(order_date IS NULL, 'MISSING_ORDER_DATE', NULL),
                IFF(total_amount IS NULL OR total_amount <= 0, 'INVALID_AMOUNT', NULL),
                IFF(order_status IS NULL OR order_status = '', 'MISSING_STATUS', NULL)
            ]), 
            ','
        ) AS data_quality_flags,
        source_system
    FROM RAW.raw_orders;
    
    processed_count := (SELECT COUNT(*) FROM stg_orders);
    result := 'Successfully processed ' || processed_count || ' order records';
    
    RETURN result;
END;
$$
COMMENT = 'Process raw order data into staging with quality checks and date dimensions';