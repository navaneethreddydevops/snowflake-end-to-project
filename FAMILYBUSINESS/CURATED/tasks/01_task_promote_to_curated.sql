!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use CURATED schema
USE SCHEMA CURATED;

-- Create task for promoting data to curated layer
CREATE OR REPLACE TASK task_promote_to_curated
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 5 * * * UTC' -- Run at 5 AM UTC daily after staging processing
    AFTER STAGING.task_process_staging_data -- Run after staging task completes
AS
$$
BEGIN
    -- Promote staging data to curated layer
    CALL sp_promote_to_curated();
    
    -- Update customer lifetime metrics
    UPDATE customers 
    SET 
        total_orders = (
            SELECT COUNT(*) 
            FROM orders o 
            WHERE o.customer_id = customers.customer_id
        ),
        lifetime_value = (
            SELECT COALESCE(SUM(total_amount), 0) 
            FROM orders o 
            WHERE o.customer_id = customers.customer_id
        ),
        last_order_date = (
            SELECT MAX(order_date) 
            FROM orders o 
            WHERE o.customer_id = customers.customer_id
        ),
        updated_timestamp = CURRENT_TIMESTAMP()
    WHERE EXISTS (
        SELECT 1 FROM orders o WHERE o.customer_id = customers.customer_id
    );
END;
$$
COMMENT = 'Daily task to promote staging data to curated layer and update metrics';

-- Start the task (commented out for initial deployment)
-- ALTER TASK task_promote_to_curated RESUME;