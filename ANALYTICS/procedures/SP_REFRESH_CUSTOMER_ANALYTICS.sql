!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create stored procedure for refreshing customer analytics
CREATE OR REPLACE PROCEDURE SP_REFRESH_CUSTOMER_ANALYTICS()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET RESULT STRING := '';
    LET START_TIME TIMESTAMP := CURRENT_TIMESTAMP();
    
    -- Refresh customer dimension from source
    MERGE INTO DIM_CUSTOMER AS TARGET
    USING (
        SELECT 
            CUSTOMER_ID,
            CUSTOMER_KEY,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE,
            ADDRESS,
            CITY,
            STATE,
            COUNTRY,
            POSTAL_CODE,
            CUSTOMER_SEGMENT,
            REGISTRATION_DATE,
            CURRENT_TIMESTAMP() AS LAST_UPDATED_DATE,
            IS_ACTIVE
        FROM FAMILYBUSINESS.CURATED.CUSTOMERS
    ) AS SOURCE ON TARGET.CUSTOMER_ID = SOURCE.CUSTOMER_ID
    WHEN MATCHED THEN
        UPDATE SET
            CUSTOMER_KEY = SOURCE.CUSTOMER_KEY,
            FIRST_NAME = SOURCE.FIRST_NAME,
            LAST_NAME = SOURCE.LAST_NAME,
            EMAIL = SOURCE.EMAIL,
            PHONE = SOURCE.PHONE,
            ADDRESS = SOURCE.ADDRESS,
            CITY = SOURCE.CITY,
            STATE = SOURCE.STATE,
            COUNTRY = SOURCE.COUNTRY,
            POSTAL_CODE = SOURCE.POSTAL_CODE,
            CUSTOMER_SEGMENT = SOURCE.CUSTOMER_SEGMENT,
            LAST_UPDATED_DATE = SOURCE.LAST_UPDATED_DATE,
            IS_ACTIVE = SOURCE.IS_ACTIVE
    WHEN NOT MATCHED THEN
        INSERT VALUES (
            SOURCE.CUSTOMER_ID,
            SOURCE.CUSTOMER_KEY,
            SOURCE.FIRST_NAME,
            SOURCE.LAST_NAME,
            SOURCE.EMAIL,
            SOURCE.PHONE,
            SOURCE.ADDRESS,
            SOURCE.CITY,
            SOURCE.STATE,
            SOURCE.COUNTRY,
            SOURCE.POSTAL_CODE,
            SOURCE.CUSTOMER_SEGMENT,
            SOURCE.REGISTRATION_DATE,
            SOURCE.LAST_UPDATED_DATE,
            SOURCE.IS_ACTIVE
        );
    
    LET END_TIME TIMESTAMP := CURRENT_TIMESTAMP();
    LET EXECUTION_TIME NUMBER := DATEDIFF('second', :START_TIME, :END_TIME);
    
    SET RESULT = 'Customer analytics refresh completed in ' || :EXECUTION_TIME || ' seconds';
    
    RETURN :RESULT;
END;
$$
COMMENT = 'Stored procedure to refresh customer analytics data';

-- Grant execution permissions to appropriate roles
-- Note: These grants will be applied based on the environment role
GRANT USAGE ON PROCEDURE SP_REFRESH_CUSTOMER_ANALYTICS() TO ROLE &SNOWSQL_ENVVAR_ROLE;