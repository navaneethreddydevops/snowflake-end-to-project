!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create task for refreshing analytics data
CREATE OR REPLACE TASK TASK_REFRESH_ANALYTICS
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 6 * * * UTC' -- Run at 6 AM UTC daily
AS
$$
BEGIN
    -- Call the customer analytics refresh procedure
    CALL SP_REFRESH_CUSTOMER_ANALYTICS();
    
    -- Add additional analytics refresh logic here as needed
    -- For example: product analytics, inventory analytics, etc.
END;
$$
COMMENT = 'Daily task to refresh all analytics data';

-- Start the task (commented out for initial deployment)
-- ALTER TASK TASK_REFRESH_ANALYTICS RESUME;