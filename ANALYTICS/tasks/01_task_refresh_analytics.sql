!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create task for refreshing analytics data
CREATE OR REPLACE TASK task_refresh_analytics
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 6 * * * UTC' -- Run at 6 AM UTC daily
AS
$$
BEGIN
    -- Call the customer analytics refresh procedure
    CALL sp_refresh_customer_analytics();
    
    -- Add additional analytics refresh logic here as needed
    -- For example: product analytics, inventory analytics, etc.
END;
$$
COMMENT = 'Daily task to refresh all analytics data';

-- Start the task (commented out for initial deployment)
-- ALTER TASK task_refresh_analytics RESUME;