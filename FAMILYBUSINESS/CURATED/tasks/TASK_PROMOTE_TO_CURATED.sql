!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use CURATED schema
USE SCHEMA CURATED;

-- Create task for promoting data to curated layer
CREATE OR REPLACE TASK TASK_PROMOTE_TO_CURATED
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 5 * * * UTC' -- Run at 5 AM UTC daily after staging processing
    -- AFTER STAGING.TASK_PROCESS_STAGING_DATA -- Run after staging task completes
AS
$$
BEGIN
    -- Promote staging data to curated layer
    CALL SP_PROMOTE_TO_CURATED();
    
    -- Update customer lifetime metrics
    UPDATE CUSTOMERS 
    SET 
        TOTAL_ORDERS = (
            SELECT COUNT(*) 
            FROM ORDERS O 
            WHERE O.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
        ),
        LIFETIME_VALUE = (
            SELECT COALESCE(SUM(TOTAL_AMOUNT), 0) 
            FROM ORDERS O 
            WHERE O.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
        ),
        LAST_ORDER_DATE = (
            SELECT MAX(ORDER_DATE) 
            FROM ORDERS O 
            WHERE O.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
        ),
        UPDATED_TIMESTAMP = CURRENT_TIMESTAMP()
    WHERE EXISTS (
        SELECT 1 FROM ORDERS O WHERE O.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
    );
END;
$$
COMMENT = 'Daily task to promote staging data to curated layer and update metrics';

-- Start the task (commented out for initial deployment)
-- ALTER TASK TASK_PROMOTE_TO_CURATED RESUME;