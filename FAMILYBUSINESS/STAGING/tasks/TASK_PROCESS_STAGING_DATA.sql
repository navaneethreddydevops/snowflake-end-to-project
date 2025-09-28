!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create task for processing staging data
CREATE OR REPLACE TASK TASK_PROCESS_STAGING_DATA
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 4 * * * UTC' -- Run at 4 AM UTC daily
AS
$$
BEGIN
    -- Process customer staging data
    CALL SP_PROCESS_CUSTOMER_STAGING();
    
    -- Process order staging data
    -- CALL SP_PROCESS_ORDER_STAGING();
    
    -- Add additional staging processing as needed
END;
$$
COMMENT = 'Daily task to process raw data into staging tables';

-- Set task ownership and grant permissions
GRANT OWNERSHIP ON TASK TASK_PROCESS_STAGING_DATA TO ROLE &SNOWSQL_ENVVAR_ROLE;
GRANT OPERATE ON TASK TASK_PROCESS_STAGING_DATA TO ROLE &SNOWSQL_ENVVAR_ROLE;

-- Start the task (commented out for initial deployment)
-- ALTER TASK TASK_PROCESS_STAGING_DATA RESUME;