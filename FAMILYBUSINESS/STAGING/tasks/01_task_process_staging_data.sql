!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create task for processing staging data
CREATE OR REPLACE TASK task_process_staging_data
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 4 * * * UTC' -- Run at 4 AM UTC daily
AS
$$
BEGIN
    -- Process customer staging data
    CALL sp_process_customer_staging();
    
    -- Process order staging data
    CALL sp_process_order_staging();
    
    -- Add additional staging processing as needed
END;
$$
COMMENT = 'Daily task to process raw data into staging tables';

-- Start the task (commented out for initial deployment)
-- ALTER TASK task_process_staging_data RESUME;