!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create stored procedure for refreshing customer analytics
CREATE OR REPLACE PROCEDURE sp_refresh_customer_analytics()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET result STRING := '';
    LET start_time TIMESTAMP := CURRENT_TIMESTAMP();
    
    -- Refresh customer dimension from source
    MERGE INTO dim_customer AS target
    USING (
        SELECT 
            customer_id,
            customer_key,
            first_name,
            last_name,
            email,
            phone,
            address,
            city,
            state,
            country,
            postal_code,
            customer_segment,
            registration_date,
            CURRENT_TIMESTAMP() AS last_updated_date,
            is_active
        FROM FAMILYBUSINES.CURATED.customers
    ) AS source ON target.customer_id = source.customer_id
    WHEN MATCHED THEN
        UPDATE SET
            customer_key = source.customer_key,
            first_name = source.first_name,
            last_name = source.last_name,
            email = source.email,
            phone = source.phone,
            address = source.address,
            city = source.city,
            state = source.state,
            country = source.country,
            postal_code = source.postal_code,
            customer_segment = source.customer_segment,
            last_updated_date = source.last_updated_date,
            is_active = source.is_active
    WHEN NOT MATCHED THEN
        INSERT VALUES (
            source.customer_id,
            source.customer_key,
            source.first_name,
            source.last_name,
            source.email,
            source.phone,
            source.address,
            source.city,
            source.state,
            source.country,
            source.postal_code,
            source.customer_segment,
            source.registration_date,
            source.last_updated_date,
            source.is_active
        );
    
    LET end_time TIMESTAMP := CURRENT_TIMESTAMP();
    LET execution_time NUMBER := DATEDIFF('second', :start_time, :end_time);
    
    result := 'Customer analytics refresh completed in ' || :execution_time || ' seconds';
    
    RETURN :result;
END;
$$
COMMENT = 'Stored procedure to refresh customer analytics data';