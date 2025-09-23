-- Test deployment SQL file
-- Creates a test table in the environment

!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create a test table
CREATE TABLE IF NOT EXISTS test_deployment (
    id INTEGER,
    test_name VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert a test record
INSERT INTO test_deployment (id, test_name)
VALUES (1, 'Initial Deployment Test');
